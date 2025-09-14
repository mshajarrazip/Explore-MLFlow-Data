#! /bin/bash

source /.venv/bin/activate

mlflow server --host 0.0.0.0 --port 5000 \
    --backend-store-uri ${MLFLOW_BACKEND_STORE_URI} \
    --artifacts-destination ${MLFLOW_S3_ENDPOINT_URL} \
    --serve-artifacts
