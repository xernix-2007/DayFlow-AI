"""Load the trained duration model and make one prediction."""

from pathlib import Path

import joblib
import pandas as pd

ROOT = Path(__file__).resolve().parents[1]
MODEL_PATH = ROOT / "models" / "duration_model.joblib"

FEATURES = [
    "category",
    "difficulty",
    "planned_minutes",
    "hour",
    "day_of_week",
    "previous_avg_minutes",
    "recent_completion_rate",
    "break_count",
]


def predict_duration(features: dict) -> float:
    if not MODEL_PATH.exists():
        raise FileNotFoundError("Train the duration model before requesting predictions.")

    row = pd.DataFrame([{key: features[key] for key in FEATURES}])
    model = joblib.load(MODEL_PATH)
    return float(model.predict(row)[0])
