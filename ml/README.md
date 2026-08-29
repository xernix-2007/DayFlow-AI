# ML Pipeline

The ML service will eventually predict how long a task will take and how likely it is to be completed.

## Bootstrap strategy

Before enough personal observations exist, generate a synthetic dataset with realistic relationships between:

- task category
- difficulty
- planned duration
- time of day
- day of week
- previous average duration
- recent completion rate
- break frequency
- focus ratio

The synthetic dataset is only for validating the pipeline. It must never be presented as evidence that the model understands the user.

## Personal training data

Once DayFlow collects enough real sessions, personal data becomes the preferred training/evaluation source.

Every completed session should preserve:

- prediction at planning time
- actual duration
- task metadata
- model version
- prediction error

Use a chronological split for personal data to avoid leaking future behavior into the past.

## Initial metrics

Duration regression:

- MAE
- RMSE
- Median absolute error
- P90 absolute error

Completion classification:

- ROC-AUC
- Precision
- Recall
- F1
- Calibration

The system should compare the ML model against a simple historical-median baseline.
