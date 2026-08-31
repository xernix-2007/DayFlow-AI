from datetime import datetime
from typing import Optional
from uuid import uuid4

from fastapi import FastAPI, HTTPException
from pydantic import BaseModel, Field

app = FastAPI(title="DayFlow AI API", version="1.0.0")


class TaskIn(BaseModel):
    title: str = Field(min_length=1, max_length=200)
    category: str = Field(default="Other", max_length=50)
    duration_minutes: int = Field(default=60, ge=1, le=1440)
    start_time: Optional[str] = None


class Task(TaskIn):
    id: str
    done: bool = False
    created_at: datetime


TASKS: dict[str, Task] = {}


@app.get("/health")
def health():
    return {"status": "ok", "service": "dayflow-api"}


@app.get("/api/tasks", response_model=list[Task])
def list_tasks():
    return list(TASKS.values())


@app.post("/api/tasks", response_model=Task, status_code=201)
def create_task(payload: TaskIn):
    task = Task(id=str(uuid4()), created_at=datetime.utcnow(), **payload.model_dump())
    TASKS[task.id] = task
    return task


@app.patch("/api/tasks/{task_id}/toggle", response_model=Task)
def toggle_task(task_id: str):
    task = TASKS.get(task_id)
    if not task:
        raise HTTPException(status_code=404, detail="Task not found")
    task.done = not task.done
    return task


@app.delete("/api/tasks/{task_id}", status_code=204)
def delete_task(task_id: str):
    if task_id not in TASKS:
        raise HTTPException(status_code=404, detail="Task not found")
    del TASKS[task_id]
