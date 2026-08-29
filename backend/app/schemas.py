from pydantic import BaseModel, Field


class DurationPredictionRequest(BaseModel):
    category: str
    difficulty: int = Field(ge=1, le=5)
    planned_minutes: int = Field(gt=0, le=720)
    hour: int = Field(ge=0, le=23)
    day_of_week: int = Field(ge=0, le=6)
    previous_avg_minutes: float = Field(ge=0, le=720)
    recent_completion_rate: float = Field(ge=0, le=1)
    break_count: int = Field(ge=0, le=50)


class DurationPredictionResponse(BaseModel):
    predicted_minutes: float
    model: str
    source: str
