#!/bin/sh
set -e

# Ensure the app's dependencies are installed
mix deps.get

# Wait for Postgres to become available.
until psql -h db -U "postgres" -c '\q' 2>/dev/null; do
  >&2 echo "Postgres is unavailable - sleeping"
  sleep 1
done

echo "\nPostgres is available: continuing with database setup..."

#Running
npm install

# Potentially Set up the database
mix ecto.create
mix ecto.migrate

echo "\nTesting the installation..."
# "Prove" that install was successful by running the tests
mix test

#Analysis style code
# Prepare Credo if the project has Credo start code analyze
if mix help credo >/dev/null 2>&1
then
  echo "\nFound Credo: analyzing..."
  mix credo || true
else
  echo "\nNo Credo config: Skipping code analyze..."
fi


#Generate docs
mix docs -o priv/static/doc

echo "\n Launching Phoenix web server..."
# Start the phoenix web server
mix phx.server
