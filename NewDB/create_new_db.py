import sqlite3
from pathlib import Path

SQL_FILE = Path("new_schema.sql")
DB_FILE = Path("Newdb.sqlite")   # or app.db

sql = SQL_FILE.read_text(encoding="utf-8")

conn = sqlite3.connect(DB_FILE)

# Enable FK enforcement for THIS connection (recommended even if your SQL has the PRAGMA)
conn.execute("PRAGMA foreign_keys = ON;")  # foreign keys are per-connection [web:6]

conn.executescript(sql)  # runs the whole .sql file (many statements) [web:3][web:1]
conn.commit()
conn.close()

print("Created:", DB_FILE)