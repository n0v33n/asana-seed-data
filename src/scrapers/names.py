from faker import Faker
fake = Faker()

def generate_name():
    return fake.name()

def generate_email(name, domain):
    base = name.lower().replace(" ", ".")
    return f"{base}@{domain}"
