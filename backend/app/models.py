from datetime import datetime
from typing import Literal

from pydantic import BaseModel, Field


class WorkSession(BaseModel):
    task_id: str
    category: str
    difficulty: int = Field(ge=1, le=5)
    planned_minutes: int = Field(gt=0, le=720)
    predicted_minutes: float | None = Field(default=None, ge=0, le=720)
    started_at: datetime
    ended_at: datetime
    focus_minutes: int = Field(ge=0, le=720)
    distraction_minutes: int = Field(ge=0, le=720)
    completed: bool
    quality_score: int | None = Field(default=None, ge=1, le=5)


class SessionMetricsResponse(BaseModel):
    actual_minutes: float
    speed_ratio: float
    focus_ratio: float
    absolute_prediction_error: float | None
    productivity_score: float
    label: Literal["early", "on_track", "late"]
