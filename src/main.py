from src.models.db import connect
from src.utils.config import CONFIG
from src.generators.users import generate_users
from src.generators.projects import generate_projects
from src.generators.tasks import generate_tasks
import sqlite3

def main():
    conn = connect(CONFIG["DB_PATH"])

    with open("schema.sql") as f:
        conn.executescript(f.read())

    org_id = "org-1"
    conn.execute("INSERT INTO organizations VALUES (?, ?)",
                 (org_id, CONFIG["COMPANY_NAME"]))

    teams = []
    for i in range(20):
        tid = f"team-{i}"
        teams.append(tid)
        conn.execute("INSERT INTO teams VALUES (?, ?, ?)",
                     (tid, f"Team {i}", org_id))

    users = generate_users(conn, teams, CONFIG["TOTAL_USERS"], "acme.com")
    projects = generate_projects(conn, teams, users, CONFIG["TOTAL_PROJECTS"])
    generate_tasks(conn, projects, users)

    conn.commit()
    conn.close()
    print("✅ Asana simulation database created successfully.")

if __name__ == "__main__":
    main()
