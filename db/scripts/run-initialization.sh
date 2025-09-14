#! /bin/bash

LABEL=$(basename "$0")

# Wait to be sure that SQL Server came up
# Wait for SQL Server to start
echo "$LABEL: ⏳ Waiting for SQL Server to start..."

# Set SQLCMD path dynamically
if [ -d "/opt/mssql-tools18/bin" ]; then
    SQLCMD="/opt/mssql-tools18/bin/sqlcmd"
else
    SQLCMD="/opt/mssql-tools/bin/sqlcmd"
fi

RETRIES=300
until $SQLCMD -S localhost -U sa -P "$MSSQL_SA_PASSWORD" -Q "SELECT 1;" -b -C > /dev/null 2>&1 || [ $RETRIES -eq 0 ]; do
    echo "$LABEL: 🔄 Still waiting... SQL Server is not yet ready. Retries left: $RETRIES"
    sleep 2
    ((RETRIES--))
done

if [ $RETRIES -eq 0 ]; then
    echo "$LABEL: ❌ ERROR: SQL Server did not start in expected time."
    exit 1
fi

echo "$LABEL: ✅ SQL Server is ready!"

echo "$LABEL: 🚧 Creating databases..."

# Run the setup script to create the DB and the schema in the DB
# Note: make sure that your password matches what is in the Dockerfile
for DB_NAME in $(echo $DB_NAMES | sed "s/,/ /g"); do
    echo "$LABEL: 📦 Creating database: $DB_NAME"

    $SQLCMD -S localhost -U sa -P "$MSSQL_SA_PASSWORD" \
            -d master -v DB_NAME="${DB_NAME}" \
            -i create-database.sql -C
done

echo "$LABEL: ✅ All databases created successfully!"