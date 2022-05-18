#!/usr/bin/env bash

set -e

echo "Beginning migration script..."
bin/hn_ag eval "DataService.ReleaseTasks.migrate()"

echo "Starting app..."
bin/hn_ag start