import os
from dotenv import load_dotenv

load_dotenv()

CONFIG = {
    "DB_PATH": os.getenv("DB_PATH"),
    "TOTAL_USERS": int(os.getenv("TOTAL_USERS", 6000)),
    "TOTAL_PROJECTS": int(os.getenv("TOTAL_PROJECTS", 1200)),
    "COMPANY_NAME": os.getenv("COMPANY_NAME", "Acme SaaS Inc"),
    "OPENAI_API_KEY": os.getenv("OPENAI_API_KEY")
}
