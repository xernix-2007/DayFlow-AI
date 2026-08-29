from datetime import datetime

from pydantic import BaseModel, Field


class PlanTaskRequest(BaseModel):
    id: str
    title: str
    priority: int = Field(ge=1, le=4)
    predicted_minutes: int = Field(gt=0, le=720)
    earliest_start: datetime
    deadline: datetime | None = None


class PlanRequest(BaseModel):
    day_start: datetime
    day_end: datetime
    break_minutes: int = Field(default=10, ge=0, le=60)
    tasks: list[PlanTaskRequest]


class ScheduledTaskResponse(BaseModel):
    id: str
    title: str
    start: datetime
    end: datetime
    predicted_minutes: int


class PlanResponse(BaseModel):
    scheduled: list[ScheduledTaskResponse]
    unscheduled_ids: list[str]
    used_minutes: int
    available_minutes: int
    utilization: float
