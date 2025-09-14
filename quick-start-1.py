import os

import pandas as pd
import mlflow, mlflow.data
import sklearn

import logging

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(name)s - %(levelname)s - %(message)s"
)


if __name__ == "__main__":

    logging.info("MLflow version: %s", mlflow.__version__)

    # get iris dataset and save to data/iris.csv
    path_to = "data/iris.csv"
    if not os.path.exists(path_to):
        logging.info("Downloading iris dataset to %s", path_to)
        iris = sklearn.datasets.load_iris(as_frame=True).frame
        os.makedirs(os.path.dirname(path_to), exist_ok=True)
        iris.to_csv(path_to, index=False)
        logging.info("Iris dataset downloaded to %s", path_to)
    else:
        logging.info("Iris dataset already exists at %s", path_to)
    
    iris = pd.read_csv(path_to)

    with mlflow.start_run() as run:

        ds = mlflow.data.from_pandas(
            iris, 
            source = path_to,
            name = "Iris dataset"
        )

        mlflow.log_input(ds, context="training")

    logged_run = mlflow.get_run(run.info.run_id)

    logged_dataset = logged_run.inputs.dataset_inputs[0].dataset

    logging.info("Logged dataset: %s", logged_dataset)
    logging.info("Dataset name: %s", logged_dataset.name)
    logging.info("Dataset source: %s", logged_dataset.source)
    logging.info("Dataset digest: %s", logged_dataset.digest)

    dataset_source = mlflow.data.get_source(logged_dataset)
    local_dataset = dataset_source.load()
    logging.info("Loaded dataset from source: %s", local_dataset)
    loaded_data = pd.read_csv(local_dataset)
