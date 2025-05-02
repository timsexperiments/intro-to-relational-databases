#!/bin/bash

# Usage: ./scripts/run_all.sh <student_github_username>
STUDENT=$1

if [ -z "$STUDENT" ]; then
  echo "Usage: $0 <student_github_username>"
  exit 1
fi

# Find all homework directories in order (e.g., homework_1, homework_2, ...)
for HW_DIR in $(ls -d submissions/homework_* 2>/dev/null | sort -V); do
  SQL_FILE="${HW_DIR}/${STUDENT}/hw.sql"
  if [ -f "$SQL_FILE" ]; then
    echo "Running $SQL_FILE"
    docker exec -i mysql-db mysql -uroot -psecret course_db < "$SQL_FILE"
  else
    echo "No submission found for $STUDENT in $HW_DIR"
  fi
done

echo "All homework scripts executed for $STUDENT."
