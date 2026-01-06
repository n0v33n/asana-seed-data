# src/utils/llm.py
import json
import re
from typing import List, Dict, Any
from src.utils.config import CONFIG

OPENAI_KEY = CONFIG.get("OPENAI_API_KEY")

if OPENAI_KEY:
    try:
        from openai import OpenAI
        client = OpenAI(api_key=OPENAI_KEY)
    except Exception as e:
        print("⚠️ OpenAI client init failed:", e)
        client = None
else:
    client = None

# Regex to safely extract JSON from noisy LLM output
JSON_RE = re.compile(r"\[[\s\S]*\]")

def _extract_json(text: str) -> List[Dict[str, Any]]:
    """
    Extract JSON array from LLM output, even if wrapped in text or markdown.
    """
    match = JSON_RE.search(text)
    if not match:
        raise ValueError("No JSON array found in LLM output")
    return json.loads(match.group())

def generate_tasks_with_llm(prompt: str, temperature: float = 0.5) -> List[Dict[str, Any]]:
    """
    Calls OpenAI and returns a list of task objects:
    [{title, description, type, priority}, ...]
    """
    if not client:
        raise RuntimeError("OpenAI client not configured")

    response = client.chat.completions.create(
        model="gpt-4o-mini",
        messages=[
            {
                "role": "system",
                "content": "You are a JSON-only generator. Return ONLY valid JSON."
            },
            {
                "role": "user",
                "content": prompt
            }
        ],
        temperature=temperature,
        max_tokens=800
    )

    raw = response.choices[0].message.content.strip()
    return _extract_json(raw)
