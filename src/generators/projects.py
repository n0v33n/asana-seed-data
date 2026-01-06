import uuid
import random
from src.utils.dates import random_past_date, random_future_date

STATUSES = ["active", "completed", "on_hold"]

def generate_projects(conn, teams, owners, count):
    projects = []
    for _ in range(count):
        pid = str(uuid.uuid4())
        projects.append((
            pid,
            f"Project {pid[:6]}",
            "Strategic initiative",
            random.choice(teams),
            random.choice(owners),
            random_past_date(),
            random_future_date(),
            random.choice(STATUSES)
        ))

    conn.executemany(
        "INSERT INTO projects VALUES (?, ?, ?, ?, ?, ?, ?, ?)", projects
    )
    return [p[0] for p in projects]
