#!/usr/bin/env bash
set -euo pipefail

python ml/generate_synthetic_data.py
python ml/train_duration_model.py
