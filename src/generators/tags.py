# src/generators/tags.py
import uuid
import random

BASE_TAGS = ["urgent", "bug", "feature", "frontend", "backend", "analytics", "marketing", "design", "onboarding"]

def populate_tags(conn):
    rows = []
    for tag in BASE_TAGS:
        tid = str(uuid.uuid4())
        rows.append((tid, tag))
    conn.executemany("INSERT INTO tags VALUES (?, ?)", rows)
    return {name: tid for tid, name in rows}
