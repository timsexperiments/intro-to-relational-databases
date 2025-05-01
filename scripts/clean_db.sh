#!/bin/bash
# Drops all tables in course_db
docker exec -i mysql-db mysql -uroot -psecret course_db -e "SET FOREIGN_KEY_CHECKS = 0; \
  SET @tables = NULL; \
  SELECT GROUP_CONCAT('\`', table_name, '\`') INTO @tables \
    FROM information_schema.tables WHERE table_schema = 'course_db'; \
  SET @tables = IFNULL(@tables, 'dummy'); \
  SET @sql = CONCAT('DROP TABLE IF EXISTS ', @tables); \
  PREPARE stmt FROM @sql; \
  EXECUTE stmt; \
  DEALLOCATE PREPARE stmt; \
  SET FOREIGN_KEY_CHECKS = 1;"

echo "All tables dropped from course_db."
