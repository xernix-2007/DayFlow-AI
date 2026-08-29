from fastapi import FastAPI, HTTPException

from app.models import SessionMetricsResponse, WorkSession
from app.schemas import DurationPredictionRequest, DurationPredictionResponse

app = FastAPI(title="DayFlow AI API", version="0.1.0")


@app.get("/health")
def health() -> dict[str, str]:
    return {"status": "ok", "service": "dayflow-api"}


@app.post("/predict/duration", response_model=DurationPredictionResponse)
def predict_duration(request: DurationPredictionRequest) -> DurationPredictionResponse:
    try:
        from ml.predict_duration import predict_duration as predict

        minutes = predict(request.model_dump())
    except FileNotFoundError as exc:
        raise HTTPException(status_code=503, detail=str(exc)) from exc

    return DurationPredictionResponse(
        predicted_minutes=round(minutes, 1),
        model="xgboost-duration-v0",
        source="bootstrap-synthetic",
    )


@app.post("/sessions/metrics", response_model=SessionMetricsResponse)
def session_metrics(session: WorkSession) -> SessionMetricsResponse:
    actual = (session.ended_at - session.started_at).total_seconds() / 60
    if actual <= 0:
        raise HTTPException(status_code=400, detail="ended_at must be after started_at")

    speed_ratio = session.planned_minutes / actual
    total_observed = session.focus_minutes + session.distraction_minutes
    focus_ratio = session.focus_minutes / total_observed if total_observed else 0.0
    prediction_error = (
        abs(session.predicted_minutes - actual)
        if session.predicted_minutes is not None
        else None
    )

    completion = 1.0 if session.completed else 0.0
    adherence = min(1.0, session.planned_minutes / actual) if actual else 0.0
    quality = (session.quality_score / 5) if session.quality_score else 1.0
    productivity = (completion * 0.35 + focus_ratio * 0.30 + adherence * 0.20 + quality * 0.15) * 100

    if actual < session.planned_minutes * 0.9:
        label = "early"
    elif actual <= session.planned_minutes * 1.1:
        label = "on_track"
    else:
        label = "late"

    return SessionMetricsResponse(
        actual_minutes=round(actual, 2),
        speed_ratio=round(speed_ratio, 3),
        focus_ratio=round(focus_ratio, 3),
        absolute_prediction_error=round(prediction_error, 2) if prediction_error is not None else None,
        productivity_score=round(productivity, 1),
        label=label,
    )
