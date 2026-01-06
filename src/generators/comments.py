# src/generators/comments.py
import uuid
import random
from datetime import datetime
from typing import List

SAMPLE_COMMENTS = [
    "Looks good to me — I'll take the next action.",
    "We need more clarity on acceptance criteria.",
    "Blocked on design deliverables.",
    "Deployed to staging, verifying now.",
    "Can we push this to next sprint?"
]

def generate_comments(conn, task_ids: List[str], user_ids: List[str], pct_with_comments=0.6, max_comments_per_task=4):
    rows = []
    for t in task_ids:
        if random.random() > pct_with_comments:
            continue
        ccount = random.randint(1, max_comments_per_task)
        for _ in range(ccount):
            cid = str(uuid.uuid4())
            author = random.choice(user_ids)
            content = random.choice(SAMPLE_COMMENTS)
            created_at = datetime.now().isoformat()
            rows.append((cid, t, author, content, created_at))
    if rows:
        conn.executemany("INSERT INTO comments VALUES (?, ?, ?, ?, ?)", rows)
    return [r[0] for r in rows]
