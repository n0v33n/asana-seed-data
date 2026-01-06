import uuid
import random
import json
from typing import List, Dict
from datetime import datetime, timedelta
from pathlib import Path
from faker import Faker
import math

from src.utils.llm import generate_tasks_with_llm

fake = Faker()

# -------------------------------------------------
# CONFIGURATION (documented + adjustable)
# -------------------------------------------------
DEFAULT_TASKS_PER_PROJECT = 25
MAX_TASKS_PER_LLM_CALL = 6
MAX_LLM_PROJECTS = 2           # cost control
PCT_UNASSIGNED = 0.15
PCT_OVERDUE = 0.05
PCT_NO_DUE_DATE = 0.10

PROMPT_TEMPLATE = Path("prompts/task_prompt_template.txt").read_text()

ENGINEERING_COMPONENTS = [
    "Auth Service", "API Gateway", "Billing Module", "UI Layer",
    "Search Index", "Notification Service"
]
ENGINEERING_ACTIONS = [
    "Refactor", "Implement", "Optimize", "Fix", "Extend"
]
ENGINEERING_DETAILS = [
    "error handling", "pagination support", "performance bottleneck",
    "edge cases", "logging pipeline"
]

MARKETING_CAMPAIGNS = [
    "Q4 Growth", "Product Launch", "Retention Push",
    "SEO Optimization", "Email Nurture"
]
MARKETING_DELIVERABLES = [
    "Landing Page", "Ad Copy", "Email Sequence",
    "Blog Post", "Campaign Analytics"
]

# -------------------------------------------------
# HELPERS
# -------------------------------------------------
def _to_datetime(value):
    return value if isinstance(value, datetime) else datetime.fromisoformat(value)

def _weekday_weighted_datetime(start: datetime, end: datetime) -> datetime:
    """Bias creation dates toward Mon–Wed"""
    for _ in range(10):
        dt = fake.date_time_between(start_date=start, end_date=end)
        if dt.weekday() <= 2:  # Mon–Wed
            return dt
    return dt

# -------------------------------------------------
# FALLBACK TASK CONTENT (NO LLM)
# -------------------------------------------------
def _fallback_task_content(project_type: str) -> Dict:
    if project_type == "engineering":
        title = (
            f"{random.choice(ENGINEERING_COMPONENTS)} - "
            f"{random.choice(ENGINEERING_ACTIONS)} - "
            f"{random.choice(ENGINEERING_DETAILS)}"
        )
    elif project_type == "marketing":
        title = (
            f"{random.choice(MARKETING_CAMPAIGNS)} - "
            f"{random.choice(MARKETING_DELIVERABLES)}"
        )
    else:
        title = fake.sentence(nb_words=6)

    # Description distribution
    r = random.random()
    if r < 0.20:
        description = ""
    elif r < 0.70:
        description = fake.paragraph(nb_sentences=random.randint(1, 3))
    else:
        bullets = "\n".join(f"- {s}" for s in fake.sentences(4))
        description = bullets

    return {
        "title": title,
        "description": description
    }

# -------------------------------------------------
# LLM TASK GENERATION
# -------------------------------------------------
def _generate_llm_tasks(project: Dict, n: int) -> List[Dict]:
    prompt = PROMPT_TEMPLATE.format(
        n=n,
        project_context=json.dumps(
            {
                "project_name": project["name"],
                "project_type": project["type"],
                "team_id": project["team_id"],
                "status": project["status"]
            }
        ),
    )
    return generate_tasks_with_llm(prompt)

# -------------------------------------------------
# MAIN GENERATOR
# -------------------------------------------------
def generate_tasks(
    conn,
    projects: List[Dict],
    user_ids: List[str],
    section_map: Dict[str, List[str]],
) -> List[str]:

    rows = []
    all_task_ids = []

    for p_index, project in enumerate(projects):
        use_llm = p_index < MAX_LLM_PROJECTS

        project_start = _to_datetime(project["start_date"])
        project_end = _to_datetime(project["end_date"])

        total_tasks = max(5, int(random.gauss(DEFAULT_TASKS_PER_PROJECT, 5)))
        remaining = total_tasks

        while remaining > 0:
            batch = min(remaining, MAX_TASKS_PER_LLM_CALL)

            if use_llm:
                try:
                    items = _generate_llm_tasks(project, batch)
                except Exception:
                    items = [_fallback_task_content(project["type"]) for _ in range(batch)]
            else:
                items = [_fallback_task_content(project["type"]) for _ in range(batch)]

            for item in items:
                task_id = str(uuid.uuid4())

                created_at = _weekday_weighted_datetime(project_start, project_end)

                # -------------------------
                # Due date distribution
                # -------------------------
                r = random.random()
                if r < PCT_NO_DUE_DATE:
                    due_date = None
                elif r < PCT_NO_DUE_DATE + PCT_OVERDUE:
                    due_date = fake.date_time_between(
                        start_date=project_start,
                        end_date=created_at,
                    )
                else:
                    # bucketed planning horizons
                    horizon = random.random()
                    if horizon < 0.25:
                        delta_days = random.randint(1, 7)
                    elif horizon < 0.65:
                        delta_days = random.randint(8, 30)
                    else:
                        delta_days = random.randint(31, 90)
                    due_date = created_at + timedelta(days=delta_days)

                # -------------------------
                # Assignment
                # -------------------------
                assignee = (
                    None if random.random() < PCT_UNASSIGNED else random.choice(user_ids)
                )

                # -------------------------
                # Completion logic
                # -------------------------
                if project["type"] == "engineering":
                    completed_prob = 0.75
                elif project["type"] == "marketing":
                    completed_prob = 0.60
                else:
                    completed_prob = 0.50

                completed = random.random() < completed_prob
                completed_at = None

                if completed:
                    # log-normal–like skew
                    days = max(1, int(math.exp(random.gauss(1.2, 0.6))))
                    completed_at = (created_at + timedelta(days=min(days, 14))).isoformat()

                section_id = random.choice(section_map.get(project["id"], []))

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
                        due_date.isoformat() if due_date else None,
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
