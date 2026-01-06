import uuid
import random
from src.utils.dates import random_past_date, random_future_date

def generate_tasks(conn, projects, users, per_project=25):
    tasks = []
    for project in projects:
        for _ in range(per_project):
            tid = str(uuid.uuid4())
            created = random_past_date()
            completed = random.random() < 0.65
            completed_at = random_future_date() if completed else None

            tasks.append((
                tid,
                "Execute task",
                "Detailed task description",
                project,
                None,
                random.choice(users),
                None,
                created,
                random_future_date(),
                completed,
                completed_at
            ))

    conn.executemany(
        "INSERT INTO tasks VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", tasks
    )
