# Predict My Day

The planner separates **prediction** from **scheduling**.

## Prediction

For each task, estimate duration using the best available source:

1. Personal model when enough personal history exists.
2. Historical personal median as a safe fallback.
3. Generic XGBoost bootstrap model before personal history exists.
4. User's planned duration if no model is available.

## Scheduling

The optimizer receives:

- available start/end window
- predicted task durations
- priority
- earliest start
- optional deadline
- configurable break time

Tasks are ordered by priority, then deadline, then earliest start. Tasks that cannot fit are explicitly returned as unscheduled rather than silently dropping them.

## Future improvements

- Fixed calendar events
- User-defined working windows
- energy/peak-hour preference learned from history
- uncertainty intervals, not just point estimates
- buffer based on recent prediction error
- "I'm behind" rescheduling
- multi-day deadline planning
- compare optimized plan against user's original plan
