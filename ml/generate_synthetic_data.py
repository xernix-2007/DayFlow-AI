"""Generate a deterministic synthetic dataset for the first ML milestone.

This dataset is deliberately labeled synthetic. It exists to prove the training
pipeline works before the app has collected enough real sessions.
"""

from pathlib import Path

import numpy as np
import pandas as pd

ROOT = Path(__file__).resolve().parents[1]
OUTPUT = ROOT / "data" / "synthetic" / "duration_training.csv"

CATEGORIES = ["DSA", "AI / Data", "Development", "College", "Fitness", "Personal"]
CATEGORY_FACTOR = {
    "DSA": 1.18,
    "AI / Data": 1.25,
    "Development": 1.30,
    "College": 0.95,
    "Fitness": 0.80,
    "Personal": 0.90,
}


def generate(rows: int = 5000, seed: int = 42) -> pd.DataFrame:
    rng = np.random.default_rng(seed)
    category = rng.choice(CATEGORIES, rows)
    difficulty = rng.integers(1, 6, rows)
    planned = rng.integers(15, 241, rows)
    hour = rng.integers(6, 24, rows)
    day = rng.integers(0, 7, rows)
    previous_avg = np.clip(planned * rng.normal(1.0, 0.18, rows), 10, 360)
    completion_rate = np.clip(rng.normal(0.75, 0.15, rows), 0.2, 1.0)
    breaks = rng.poisson(1.2, rows)

    category_factor = np.array([CATEGORY_FACTOR[c] for c in category])
    time_factor = np.where((hour >= 8) & (hour <= 11), 0.92, 1.05)
    difficulty_factor = 1 + (difficulty - 3) * 0.09
    completion_factor = 1 + (0.75 - completion_rate) * 0.35
    noise = rng.normal(0, 8, rows)

    actual = (
        planned
        * category_factor
        * time_factor
        * difficulty_factor
        * completion_factor
        + breaks * 5
        + noise
    )
    actual = np.clip(actual, 5, 480).round(1)

    return pd.DataFrame(
        {
            "category": category,
            "difficulty": difficulty,
            "planned_minutes": planned,
            "hour": hour,
            "day_of_week": day,
            "previous_avg_minutes": previous_avg.round(1),
            "recent_completion_rate": completion_rate.round(3),
            "break_count": breaks,
            "actual_minutes": actual,
        }
    )


if __name__ == "__main__":
    OUTPUT.parent.mkdir(parents=True, exist_ok=True)
    df = generate()
    df.to_csv(OUTPUT, index=False)
    print(f"Generated {len(df):,} synthetic rows at {OUTPUT}")
