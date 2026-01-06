from openai import OpenAI
from src.utils.config import CONFIG

client = OpenAI(api_key=CONFIG["OPENAI_API_KEY"])

def generate_text(prompt: str, temperature=0.7) -> str:
    response = client.chat.completions.create(
        model="gpt-4o-mini",
        messages=[{"role": "user", "content": prompt}],
        temperature=temperature
    )
    return response.choices[0].message.content.strip()
