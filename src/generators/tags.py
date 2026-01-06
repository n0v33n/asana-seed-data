import uuid
import random
from datetime import datetime
from typing import List, Dict

# --------------------------------------
# TAG VOCABULARY (realistic Asana usage)
# --------------------------------------
TAG_CATALOG = {
    "priority": ["High Priority", "Medium Priority", "Low Priority"],
    "status": ["Blocked", "Needs Review", "Ready", "In Progress"],
    "type": ["Bug", "Tech Debt", "Feature", "Experiment"],
    "process": ["Follow-up", "Customer Request", "Internal"],
    "marketing": ["SEO", "Content", "Paid Ads", "Email"],
}

TAG_COLORS = [
    "red", "orange", "yellow", "green", "blue",
    "purple", "pink", "teal", "gray"
]

# --------------------------------------
# TAG GENERATION
# --------------------------------------
def generate_tags(conn) -> Dict[str, str]:
    """
    Creates global reusable tags.
    Returns mapping: tag_name -> tag_id
    """
    tag_map = {}
    rows = []

    for group, names in TAG_CATALOG.items():
        for name in names:
            tag_id = str(uuid.uuid4())
            tag_map[name] = tag_id

            rows.append(
                (
                    tag_id,
                    name,
                    random.choice(TAG_COLORS),
                    datetime.utcnow().isoformat(),
                )
            )

    conn.executemany(
        "INSERT INTO tags (id, name, color, created_at) VALUES (?, ?, ?, ?)",
        rows,
    )

    return tag_map
