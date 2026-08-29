# DayFlow behavioral data

DayFlow's ML advantage comes from measuring the difference between **planned**, **predicted**, and **actual** work.

## Task

- id
- title
- category
- priority
- difficulty
- planned_start
- planned_minutes
- predicted_minutes
- completed

## Work session

- task_id
- started_at
- ended_at
- focus_minutes
- distraction_minutes
- paused_seconds
- quality_score

## Derived metrics

- actual_minutes
- speed_ratio = planned_minutes / actual_minutes
- focus_ratio = focus_minutes / (focus_minutes + distraction_minutes)
- absolute_prediction_error = |predicted_minutes - actual_minutes|
- productivity_score

## Training rule

Do not train on incomplete or obviously corrupted sessions. Personal training should use chronological splits so the model only learns from behavior that existed before the prediction.

## Privacy rule

Desktop application tracking should be opt-in. Store the minimum information required for the chosen feature and provide a clear way to disable/delete the data.
