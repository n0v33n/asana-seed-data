import sqlite3

DB_PATH = "output/finaldb.sqlite"
N_ROWS = 4

def get_tables(cur):
    return [r[0] for r in cur.execute("""
        SELECT name
        FROM sqlite_master
        WHERE type='table' AND name NOT LIKE 'sqlite_%'
        ORDER BY name
    """).fetchall()]  # table list from sqlite_master [web:55]

def get_columns(cur, table):
    return [r[1] for r in cur.execute(f'PRAGMA table_info("{table}")').fetchall()]

def main():
    con = sqlite3.connect(DB_PATH)
    cur = con.cursor()

    tables = get_tables(cur)
    print(f"Database: {DB_PATH}")
    print(f"Tables found: {len(tables)}\n")

    for t in tables:
        cols = get_columns(cur, t)

        cur.execute(f'SELECT * FROM "{t}" LIMIT {N_ROWS}')  # LIMIT returns only N rows [web:69]
        rows = cur.fetchall()

        print(f"TABLE: {t}")
        if not rows:
            print("  (no rows)\n")
            continue

        for i, row in enumerate(rows, start=1):
            print(f"  Row {i}:")
            for c, v in zip(cols, row):
                print(f"    {c} = {v}")
        print()

    con.close()

if __name__ == "__main__":
    main()
