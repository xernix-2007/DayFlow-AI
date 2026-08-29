"""Train a baseline task-duration model from a CSV dataset.

Expected columns:
category,difficulty,planned_minutes,hour,day_of_week,
previous_avg_minutes,recent_completion_rate,break_count,actual_minutes

The model is intentionally simple for the first milestone. Personal data should
replace synthetic data once enough real sessions have been collected.
"""

from pathlib import Path

import joblib
import pandas as pd
from sklearn.compose import ColumnTransformer
from sklearn.metrics import mean_absolute_error, root_mean_squared_error
from sklearn.model_selection import train_test_split
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import OneHotEncoder
from xgboost import XGBRegressor

ROOT = Path(__file__).resolve().parents[1]
DATASET = ROOT / "data" / "synthetic" / "duration_training.csv"
MODEL_DIR = ROOT / "models"
MODEL_PATH = MODEL_DIR / "duration_model.joblib"

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
TARGET = "actual_minutes"


def train() -> None:
    if not DATASET.exists():
        raise FileNotFoundError(
            f"Dataset not found: {DATASET}. Generate the bootstrap dataset first."
        )

    df = pd.read_csv(DATASET)
    missing = set(FEATURES + [TARGET]) - set(df.columns)
    if missing:
        raise ValueError(f"Missing dataset columns: {sorted(missing)}")

    X = df[FEATURES]
    y = df[TARGET]
    X_train, X_test, y_train, y_test = train_test_split(
        X, y, test_size=0.2, random_state=42
    )

    categorical = ["category"]
    numeric = [column for column in FEATURES if column not in categorical]

    preprocessor = ColumnTransformer(
        transformers=[
            ("category", OneHotEncoder(handle_unknown="ignore"), categorical),
            ("numeric", "passthrough", numeric),
        ]
    )

    model = Pipeline(
        steps=[
            ("preprocessor", preprocessor),
            (
                "regressor",
                XGBRegressor(
                    n_estimators=300,
                    max_depth=5,
                    learning_rate=0.05,
                    subsample=0.85,
                    colsample_bytree=0.85,
                    objective="reg:squarederror",
                    random_state=42,
                ),
            ),
        ]
    )

    model.fit(X_train, y_train)
    predictions = model.predict(X_test)
    mae = mean_absolute_error(y_test, predictions)
    rmse = root_mean_squared_error(y_test, predictions)

    MODEL_DIR.mkdir(parents=True, exist_ok=True)
    joblib.dump(model, MODEL_PATH)

    print(f"MAE: {mae:.2f} minutes")
    print(f"RMSE: {rmse:.2f} minutes")
    print(f"Saved model: {MODEL_PATH}")


if __name__ == "__main__":
    train()
