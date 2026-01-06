import uuid
import random
from src.scrapers.names import generate_name
from src.utils.dates import random_past_date

ROLES = ["Engineer", "Product Manager", "Designer", "Marketer", "Ops"]

def generate_users(conn, teams, count, domain):
    users = []
    used_emails = set()

    for _ in range(count):
        uid = str(uuid.uuid4())
        name = generate_name()

        base_email = name.lower().replace(" ", ".")
        email = f"{base_email}@{domain}"

        suffix = 1
        while email in used_emails:
            email = f"{base_email}{suffix}@{domain}"
            suffix += 1

        used_emails.add(email)

        users.append((
            uid,
            name,
            email,
            random.choice(ROLES),
            random.choice(teams),
            random_past_date()
        ))

    conn.executemany(
        "INSERT INTO users VALUES (?, ?, ?, ?, ?, ?)",
        users
    )

    return [u[0] for u in users]
