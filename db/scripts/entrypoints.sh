#!/bin/bash
set -e

# Start SQL Server in the background
/opt/mssql/bin/sqlservr &

# Capture its PID
pid=$!

# Run your initialization script (which includes readiness checks)
./run-initialization.sh

# Wait for SQL Server process to keep container alive
wait "$pid"