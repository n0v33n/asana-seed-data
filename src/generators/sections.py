# src/generators/sections.py
import uuid

DEFAULT_SECTIONS_BY_TYPE = {
    "engineering": ["Backlog", "Sprint Backlog", "In Progress", "Review", "Done"],
    "marketing": ["Ideas", "Planning", "Assets", "Scheduled", "Launched"],
    "operations": ["To Do", "In Progress", "Waiting", "Completed"]
}

def generate_sections(conn, projects):
    rows = []
    project_section_map = {}

    for p in projects:
        ptype = p.get("type", "engineering")
        section_names = DEFAULT_SECTIONS_BY_TYPE.get(
            ptype, DEFAULT_SECTIONS_BY_TYPE["engineering"]
        )
        section_ids = []

        for name in section_names:
            sid = str(uuid.uuid4())
            section_ids.append(sid)
            rows.append((sid, name, p["id"]))

        project_section_map[p["id"]] = section_ids

    conn.executemany(
        "INSERT INTO sections VALUES (?, ?, ?)",
        rows
    )

    return project_section_map
