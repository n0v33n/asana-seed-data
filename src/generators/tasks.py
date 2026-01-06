# src/generators/tasks.py
import uuid
import random
import json
from typing import List, Dict
from datetime import datetime, timedelta
from pathlib import Path
from faker import Faker

from src.utils.llm import generate_tasks_with_llm

fake = Faker()

# -------------------------------
# CONFIGURATION
# -------------------------------
DEFAULT_TASKS_PER_PROJECT = 25
MAX_TASKS_PER_LLM_CALL = 6
MAX_LLM_PROJECTS = 1
PCT_UNASSIGNED = 0.15
PCT_OVERDUE = 0.10

PROMPT_TEMPLATE = Path("prompts/task_prompt_template.txt").read_text()

# -------------------------------
# HELPERS
# -------------------------------
def _to_datetime(value):
    """Convert ISO string or datetime to datetime."""
    if isinstance(value, datetime):
        return value
    return datetime.fromisoformat(value)

# -------------------------------
# FALLBACK GENERATION
# -------------------------------
def _fallback_generate(n: int) -> List[Dict]:
    return [
        {
            "title": fake.sentence(nb_words=6),
            "description": fake.paragraph(nb_sentences=4),
            "type": "generic",
            "priority": random.choice(["low", "medium", "high"]),
        }
        for _ in range(n)
    ]

# -------------------------------
# LLM TASK GENERATION
# -------------------------------
def _generate_llm_tasks(project: Dict, n: int) -> List[Dict]:
    prompt = PROMPT_TEMPLATE.format(
        n=n,
        project_context=json.dumps(
            {
                "project_name": project["name"],
                "project_type": project["type"],
                "team_id": project["team_id"],
                "status": project["status"],
            }
        ),
    )
    return generate_tasks_with_llm(prompt)

# -------------------------------
# MAIN GENERATOR
# -------------------------------
def generate_tasks(
    conn,
    projects: List[Dict],
    user_ids: List[str],
    section_map: Dict[str, List[str]],
) -> List[str]:

    rows = []
    all_task_ids = []

    for idx, project in enumerate(projects):
        use_llm = idx < MAX_LLM_PROJECTS

        project_start = _to_datetime(project["start_date"])
        project_end = _to_datetime(project["end_date"])

        total_tasks = max(5, int(random.gauss(DEFAULT_TASKS_PER_PROJECT, 5)))
        remaining = total_tasks

        while remaining > 0:
            batch = min(remaining, MAX_TASKS_PER_LLM_CALL)

            if use_llm:
                try:
                    items = _generate_llm_tasks(project, batch)
                except Exception as e:
                    print("⚠️ LLM failed → fallback:", e)
                    items = _fallback_generate(batch)
            else:
                items = _fallback_generate(batch)

            for item in items:
                task_id = str(uuid.uuid4())

                created_at = fake.date_time_between(
                    start_date=project_start,
                    end_date=project_end,
                )

                # Due date
                if random.random() < PCT_OVERDUE:
                    due_date = fake.date_time_between(
                        start_date=project_start,
                        end_date=created_at,
                    )
                else:
                    due_date = fake.date_time_between(
                        start_date=created_at,
                        end_date=project_end,
                    )

                # Assignment
                assignee = (
                    None
                    if random.random() < PCT_UNASSIGNED
                    else random.choice(user_ids)
                )

                # Completion
                completed_prob = 0.65 if project["type"] == "engineering" else 0.5
                completed = random.random() < completed_prob

                completed_at = None
                if completed:
                    completed_at = (
                        created_at + timedelta(days=random.randint(1, 14))
                    ).isoformat()

                section_id = (
                    random.choice(section_map.get(project["id"], []))
                    if section_map
                    else None
                )

                rows.append(
                    (
                        task_id,
                        item["title"][:250],
                        item["description"][:2000],
                        project["id"],
                        section_id,
                        assignee,
                        None,
                        created_at.isoformat(),
                        due_date.isoformat(),
                        int(completed),
                        completed_at,
                    )
                )

                all_task_ids.append(task_id)

            remaining -= batch

    conn.executemany(
        "INSERT INTO tasks VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
        rows,
    )

    return all_task_ids
