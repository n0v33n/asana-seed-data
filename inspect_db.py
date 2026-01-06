import sqlite3

conn = sqlite3.connect("output/asana_simulation.sqlite")

tables = ["users", "projects", "tasks"]

for table in tables:
    count = conn.execute(f"SELECT COUNT(*) FROM {table}").fetchone()[0]
    print(table, count)

rows = conn.execute(
    "SELECT full_name, email, role FROM users LIMIT 50"
).fetchall()

print("\nSample users:")
for r in rows:
    print(r)

conn.close()
