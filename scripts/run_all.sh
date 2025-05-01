#!/bin/bash

# Runs all homework SQL scripts in order for all students
for HW_DIR in submissions/hw*/; do
  for STUDENT_DIR in "$HW_DIR"*/; do
    SQL_FILE="${STUDENT_DIR}solution.sql"
    if [ -f "$SQL_FILE" ]; then
      echo "Running $SQL_FILE"
      docker exec -i mysql-db mysql -uroot -psecret course_db < "$SQL_FILE"
    fi
  done
done
echo "All homework scripts executed."
