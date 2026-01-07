import sqlite3
import pandas as pd
from pathlib import Path

DB_PATH = "finaldb.sqlite"
OUTPUT_DIR = Path("csv")
OUTPUT_DIR.mkdir(exist_ok=True)

conn = sqlite3.connect(DB_PATH)

tables = [
    "organizations",
    "teams",
    "users",
    "projects",
    "sections",
    "tasks",
    "tags",
    "task_tags",
    "comments",
]

for table in tables:
    df = pd.read_sql_query(f"SELECT * FROM {table}", conn)
    df.to_csv(OUTPUT_DIR / f"{table}.csv", index=False)
    print(f"Exported {table}.csv")

conn.close()
