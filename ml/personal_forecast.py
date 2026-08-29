"""Personal forecasting helpers.

Uses simple, explainable historical statistics until enough user sessions exist
for a supervised model. This prevents overfitting a tiny personal dataset.
"""

from dataclasses import dataclass
from statistics import median


@dataclass(frozen=True)
class PersonalForecast:
    predicted_minutes: float
    confidence: float
    samples: int
    method: str


def forecast_duration(
    historical_minutes: list[float],
    planned_minutes: float,
) -> PersonalForecast:
    clean = [value for value in historical_minutes if value > 0]
    if not clean:
        return PersonalForecast(
            predicted_minutes=planned_minutes,
            confidence=0.15,
            samples=0,
            method="planned-duration-baseline",
        )

    estimate = median(clean)
    # Confidence rises with sample count but deliberately stays conservative.
    confidence = min(0.95, 0.35 + 0.06 * len(clean))
    return PersonalForecast(
        predicted_minutes=round(estimate, 1),
        confidence=round(confidence, 2),
        samples=len(clean),
        method="personal-historical-median",
    )
