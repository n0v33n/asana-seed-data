import sqlite3

FINAL  = "finaldb.sqlite"
DB1    = "Newdb.sqlite"
DB2    = "asana_simulation.sqlite"

con = sqlite3.connect(FINAL)   # Creates finaldb.sqlite if it doesn't exist [web:41]
cur = con.cursor()

cur.execute("ATTACH DATABASE ? AS db1", (DB1,))  # attach Newdb.sqlite [web:17]
cur.execute("ATTACH DATABASE ? AS db2", (DB2,))  # attach asana_simulation.sqlite [web:17]

# 1) Create tables in finaldb.sqlite from DB1 and copy data
tables1 = [r[0] for r in cur.execute("""
    SELECT name
    FROM db1.sqlite_master
    WHERE type='table' AND name NOT LIKE 'sqlite_%'
""").fetchall()]

for t in tables1:
    # Create same schema in FINAL (main)
    cur.execute(f'CREATE TABLE IF NOT EXISTS main."{t}" AS SELECT * FROM db1."{t}" WHERE 0')
    # Copy rows from DB1
    cur.execute(f'INSERT INTO main."{t}" SELECT * FROM db1."{t}"')

# 2) Append DB2 rows into those tables (only if table exists in main)
tables2 = [r[0] for r in cur.execute("""
    SELECT name
    FROM db2.sqlite_master
    WHERE type='table' AND name NOT LIKE 'sqlite_%'
""").fetchall()]

for t in tables2:
    exists = cur.execute("""
        SELECT 1
        FROM main.sqlite_master
        WHERE type='table' AND name=?
    """, (t,)).fetchone()

    if exists:
        cur.execute(f'INSERT INTO main."{t}" SELECT * FROM db2."{t}"')
    else:
        # If you want DB2-only tables also copied into FINAL, keep this:
        cur.execute(f'CREATE TABLE main."{t}" AS SELECT * FROM db2."{t}"')

con.commit()
cur.execute("DETACH DATABASE db1")
cur.execute("DETACH DATABASE db2")
con.close()
