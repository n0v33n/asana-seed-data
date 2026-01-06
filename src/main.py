# src/main.py
import os
from src.models.db import connect
from src.utils.config import CONFIG
from src.generators.users import generate_users
from src.generators.projects import generate_projects
from src.generators.sections import generate_sections
from src.generators.tasks import generate_tasks
# from src.generators.tags import populate_tags
from src.generators.comments import generate_comments
from src.generators.tags import generate_tags
from src.generators.task_tags import generate_task_tags

def main():
    db_path = CONFIG["DB_PATH"] or "output/asana_simulation.sqlite"
    os.makedirs(os.path.dirname(db_path), exist_ok=True)
    conn = connect(db_path)

    # create schema fresh (idempotent for dev)
    with open("schema.sql", "r", encoding="utf-8") as f:
        conn.executescript(f.read())

    org_id = "org-1"
    conn.execute("INSERT INTO organizations VALUES (?, ?)", (org_id, CONFIG["COMPANY_NAME"]))

    # create teams
    teams = []
    for i in range(20):
        tid = f"team-{i}"
        teams.append(tid)
        conn.execute("INSERT INTO teams VALUES (?, ?, ?)", (tid, f"Team {i}", org_id))

    # users
    print("Generating users...")
    users = generate_users(conn, teams, CONFIG["TOTAL_USERS"], CONFIG.get("COMPANY_NAME").split()[0].lower() + ".com")
    # generate projects
    print("Generating projects...")
    projects = generate_projects(conn, teams, users, CONFIG["TOTAL_PROJECTS"])
    # sections
    print("Generating sections...")
    section_map = generate_sections(conn, projects)
    # tags
    print("Populating tags...")
    # tag_map = populate_tags(conn)
    # tasks (this uses LLM if configured)
    print("Generating tasks (this may use OpenAI) ...")
    task_ids = generate_tasks(conn, projects, users, section_map)
    # comments
    print("Generating comments...")
    generate_comments(conn, task_ids, users)
    # 1. Generate tags (global)
    tag_map = generate_tags(conn)
    # 2. Generate task-tag relationships
    generate_task_tags(conn, task_ids, tag_map)
    conn.commit()
    conn.close()
    print("✅ Asana simulation database created successfully.")

if __name__ == "__main__":
    main()
