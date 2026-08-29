from fastapi import FastAPI, HTTPException

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
