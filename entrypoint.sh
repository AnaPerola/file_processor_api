#!/bin/bash
set -e

rm -f /app/tmp/pids/server.pid
/usr/local/bin/wait-for-it.sh db:5432 --timeout=30 --strict -- \ bundle exec rails db:migrate 2>/dev/null || bundle exec rails db:create db:migrate

exec "$@"
