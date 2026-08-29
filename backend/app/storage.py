"""Small JSONL store for the backend prototype.

Production cloud persistence will move to PostgreSQL. JSONL keeps the local
prototype dependency-light while preserving raw session events for training.
"""

import json
from datetime import datetime
from pathlib import Path
from typing import Any

ROOT = Path(__file__).resolve().parents[2]
DATA_DIR = ROOT / "data" / "events"
SESSIONS_FILE = DATA_DIR / "sessions.jsonl"


def append_session(event: dict[str, Any]) -> None:
    DATA_DIR.mkdir(parents=True, exist_ok=True)
    record = {**event, "recorded_at": datetime.utcnow().isoformat() + "Z"}
    with SESSIONS_FILE.open("a", encoding="utf-8") as handle:
        handle.write(json.dumps(record) + "\n")
