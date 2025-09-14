#! /bin/bash

/opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P Password123 -Q "IF DB_ID('mlpreds') IS NULL BEGIN RAISERROR('Database does not exist', 16, 1) END;" -C
