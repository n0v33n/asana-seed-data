import random
from typing import List, Dict, Tuple

# --------------------------------------
# TASK ↔ TAG ASSOCIATION
# --------------------------------------
def generate_task_tags(
    conn,
    task_ids: List[str],
    tag_map: Dict[str, str],
):
    """
    Assigns 0–4 tags per task using realistic skewed distribution.
    """

    rows = []

    tag_ids = list(tag_map.values())

    for task_id in task_ids:
        r = random.random()

        if r < 0.30:
            num_tags = 0
        elif r < 0.65:
            num_tags = 1
        elif r < 0.85:
            num_tags = 2
        elif r < 0.95:
            num_tags = 3
        else:
            num_tags = 4

        if num_tags == 0:
            continue

        selected = random.sample(tag_ids, k=num_tags)

        for tag_id in selected:
            rows.append((task_id, tag_id))

    conn.executemany(
        "INSERT OR IGNORE INTO task_tags (task_id, tag_id) VALUES (?, ?)",
        rows,
    )
