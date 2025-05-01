#!/bin/bash

# Usage: ./scripts/run_hw.sh <hw_number> <student_github_username>
HW_NUM=$1
STUDENT=$2
SQL_FILE="submissions/hw${HW_NUM}/${STUDENT}/solution.sql"

if [ ! -f "$SQL_FILE" ]; then
  echo "SQL file not found: $SQL_FILE"
  exit 1
fi

docker exec -i mysql-db mysql -uroot -psecret course_db < "$SQL_FILE"
echo "Executed $SQL_FILE"
