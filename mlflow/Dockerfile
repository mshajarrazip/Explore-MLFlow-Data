################################################################################
#
#   Ubuntu 22.04, python3.11, pyodbc
#
################################################################################
FROM ubuntu:22.04
ENV TZ=Asia/Kuala_Lumpur

ARG MLFLOW_ARTIFACTS_URI
ARG MLFLOW_BACKEND_URI

SHELL ["/bin/bash", "-c"]

ENV MLFLOW_ARTIFACTS_URI=${MLFLOW_ARTIFACTS_URI}
ENV MLFLOW_BACKEND_URI=${MLFLOW_BACKEND_URI}

# install python 3.11
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y tzdata && \
    apt install -y software-properties-common && \
    add-apt-repository -y ppa:deadsnakes/ppa && \
    apt update && \
    apt install -y python3.11 && \
    apt-get install -y python3.11-venv python3-pip

RUN apt-get install -y curl 
    
RUN curl -sS https://bootstrap.pypa.io/get-pip.py | python3.11
    
# pyodbc prereqs + mssql odbc driver
# RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
#     curl https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/prod.list > \
#         /etc/apt/sources.list.d/mssql-release.list && \
#     apt-get update && \
#     ACCEPT_EULA=Y apt-get install -y msodbcsql18 && \
#     apt-get install -y unixodbc unixodbc-dev libpq-dev
# pyodbc prereqs + mssql odbc driver
RUN (curl -sSL https://packages.microsoft.com/keys/microsoft.asc | \
     gpg --dearmor -o /usr/share/keyrings/microsoft-archive-keyring.gpg && \
     curl -sSL https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/prod.list | \
     tee /etc/apt/sources.list.d/mssql-release.list && \
     echo "deb [arch=amd64,arm64,armhf signed-by=/usr/share/keyrings/microsoft-archive-keyring.gpg] https://packages.microsoft.com/ubuntu/$(lsb_release -rs)/prod jammy main" > /etc/apt/sources.list.d/mssql-release.list) || \
    (curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
     curl https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/prod.list > \
         /etc/apt/sources.list.d/mssql-release.list) && \
    apt-get update && \
    ACCEPT_EULA=Y apt-get install -y msodbcsql18 && \
    apt-get install -y unixodbc unixodbc-dev libpq-dev
    
RUN apt clean && \
    apt-get clean

# Install python packages
RUN python3.11 -m venv /.venv && \
    source /.venv/bin/activate && \
    pip install --upgrade pip && \
    pip install cryptography==44.0.0 && \
    pip install boto3==1.35.81 && \
    pip install pymysql==1.1.1 && \
    pip install pyodbc==5.2.0 && \
    pip install mlflow==2.17.2

COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh