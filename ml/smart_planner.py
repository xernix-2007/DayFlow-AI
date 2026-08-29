"""Schedule tasks into a day using predicted duration and constraints.

This is intentionally deterministic before introducing ML into scheduling.
The ML models provide estimates; this layer makes the actual planning decision.
"""

from dataclasses import dataclass
from datetime import datetime, timedelta


@dataclass(frozen=True)
class PlannedTask:
    task_id: str
    title: str
    priority: int
    predicted_minutes: int
    earliest_start: datetime
    deadline: datetime | None = None


@dataclass(frozen=True)
class ScheduledTask:
    task_id: str
    title: str
    start: datetime
    end: datetime
    predicted_minutes: int


@dataclass(frozen=True)
class PlanResult:
    scheduled: list[ScheduledTask]
    unscheduled: list[PlannedTask]
    used_minutes: int
    available_minutes: int


def optimize_day(
    tasks: list[PlannedTask],
    day_start: datetime,
    day_end: datetime,
    break_minutes: int = 10,
) -> PlanResult:
    if day_end <= day_start:
        raise ValueError("day_end must be after day_start")
    if break_minutes < 0:
        raise ValueError("break_minutes cannot be negative")

    available = int((day_end - day_start).total_seconds() // 60)
    cursor = day_start
    scheduled: list[ScheduledTask] = []
    unscheduled: list[PlannedTask] = []

    ordered = sorted(
        tasks,
        key=lambda task: (-task.priority, task.deadline or datetime.max, task.earliest_start),
    )

    for task in ordered:
        start = max(cursor, task.earliest_start)
        end = start + timedelta(minutes=task.predicted_minutes)
        if task.deadline is not None and end > task.deadline:
            unscheduled.append(task)
            continue
        if end > day_end:
            unscheduled.append(task)
            continue

        scheduled.append(
            ScheduledTask(
                task_id=task.task_id,
                title=task.title,
                start=start,
                end=end,
                predicted_minutes=task.predicted_minutes,
            )
        )
        cursor = end + timedelta(minutes=break_minutes)

    used = sum(item.predicted_minutes for item in scheduled)
    return PlanResult(
        scheduled=scheduled,
        unscheduled=unscheduled,
        used_minutes=used,
        available_minutes=available,
    )
