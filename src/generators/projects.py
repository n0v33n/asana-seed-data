# src/generators/projects.py
import uuid
import random
from datetime import datetime, timedelta
from src.utils.dates import random_past_date, random_future_date
from typing import List, Dict, Any

PROJECT_TYPES = ["engineering", "marketing", "operations"]

def generate_projects(conn, teams: List[str], owners: List[str], count: int) -> List[Dict[str, Any]]:
    """
    Insert projects; return list of dicts with keys: id, name, team_id, owner_id, type, start_date, end_date
    """
    projects = []
    rows = []
    for _ in range(count):
        pid = str(uuid.uuid4())
        ptype = random.choice(PROJECT_TYPES)
        start = random_past_date(365)  # projects started within last year
        # typical project length varies by type
        if ptype == "engineering":
            length_days = random.randint(14, 120)
        elif ptype == "marketing":
            length_days = random.randint(7, 90)
        else:
            length_days = random.randint(7, 60)
        end = start + timedelta(days=length_days)
        name = f"{ptype.capitalize()} - {pid[:6]}"
        owner = random.choice(owners)
        team_id = random.choice(teams)
        status = random.choices(["active", "completed", "on_hold"], weights=[0.6, 0.3, 0.1])[0]

        projects.append({
            "id": pid,
            "name": name,
            "description": f"Project of type {ptype} for {team_id}",
            "team_id": team_id,
            "owner_id": owner,
            "start_date": start.isoformat(),
            "end_date": end.isoformat(),
            "status": status,
            "type": ptype
        })
        rows.append((
            pid, name, f"Project of type {ptype}", team_id, owner, start.isoformat(), end.isoformat(), status
        ))

    conn.executemany(
        "INSERT INTO projects VALUES (?, ?, ?, ?, ?, ?, ?, ?)",
        rows
    )
    return projects
