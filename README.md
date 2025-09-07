# Relational Database Course

Welcome! This repository contains a collaborative, hands-on course for learning relational databases with MySQL. Each lesson is paired with a homework assignment, and the table below serves as a roadmap linking every lesson to its corresponding homework. Students submit their solutions as pull requests.

## Lesson Plan

| Part | Lesson # | Topic | Lesson | Homework |
|------|----------|-------|--------|----------|
| Foundations | 1 | Intro to Relational Databases | [Lesson](lessons/01_intro.md) | [HW1](homework/hw1.md) |
| Foundations | 2 | Database Fundamentals | [Lesson](lessons/02_database_fundamentals.md) | [HW2](homework/hw2.md) |
| Foundations | 3 | Relationships & Cardinality | [Lesson](lessons/03_relationships_and_cardinality.md) | [HW3](homework/hw3.md) |
| Foundations | 4 | Normalization | [Lesson](lessons/04_normalization.md) | [HW4](homework/hw4.md) |
| Working with Data | 5 | Inserting, Updating, and Deleting Data | [Lesson](lessons/05_insert_update_delete_transactions.md) | [HW5](homework/hw5.md) |
| Working with Data | 6 | SELECT Basics | [Lesson](lessons/06_introduction_to_selects.md) | [HW6](homework/hw6.md) |
| Working with Data | 7 | Joins | [Lesson](lessons/07_joins.md) | [HW7](homework/hw7.md) |
| Working with Data | 8 | Indexing & Performance | [Lesson](lessons/08_indexing.md) | [HW8](homework/hw8.md) |
| Working with Data | 9 | Expressions & Functions | [Lesson](lessons/09_expressions_and_functions.md) | [HW9](homework/hw9.md) |
| Working with Data | 10 | Aggregation & Grouping | [Lesson](lessons/10_aggregation.md) | [HW10](homework/hw10.md) |
| Working with Data | 11 | Set Operations | [Lesson](lessons/11_set_operations.md) | [HW11](homework/hw11.md) |
| Working with Data | 12 | Subqueries | [Lesson](lessons/12_subqueries.md) | [HW12](homework/hw12.md) |
| Working with Data | 13 | Common Table Expressions | [Lesson](lessons/13_ctes.md) | [HW13](homework/hw13.md) |
| Working with Data | 14 | Window Functions | [Lesson](lessons/14_window_functions.md) | [HW14](homework/hw14.md) |
| Working with Data | 15 | Views & Triggers | *coming soon* | *coming soon* |
| Working with Data | 16 | Stored Procedures | *coming soon* | *coming soon* |
| From SQL to APIs | 17 | REST API Foundations | *coming soon* | *coming soon* |
| From SQL to APIs | 18 | Validation & Error Handling | *coming soon* | *coming soon* |
| From SQL to APIs | 19 | Authentication & Authorization | *coming soon* | *coming soon* |
| From SQL to APIs | 20 | Testing & Documentation | *coming soon* | *coming soon* |
| From SQL to APIs | 21 | Reports, Pagination & Filtering | *coming soon* | *coming soon* |
| From SQL to APIs | 22 | Performance & Deployment | *coming soon* | *coming soon* |
| Capstone | 23 | Final Project | *coming soon* | *coming soon* |

The API-focused lessons emphasize conceptual understanding. Step-by-step Hono implementations are provided as supplemental practice activities.

## How This Works

- Lessons are in the `lessons/` directory.
- Homework assignments are in `homework/`, one per lesson.
- Submit your homework in the `submissions/` directory, following the instructions in each assignment.
- Each homework builds on the previous one, so complete them in order.

## Prerequisites

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) (with WSL2 integration on Windows)
- [Git](https://git-scm.com/)
- [MySQL client](https://dev.mysql.com/downloads/shell/) (optional, for direct DB access)
- [curl](https://curl.se/) (for API testing, included in most systems)
- (Optional) [Postman](https://www.postman.com/downloads/) for API testing

## Quick Start

1. **Clone this repository:**

   ```bash
   git clone https://github.com/<your-org>/relational-db-course.git
   cd relational-db-course
   ```

2. **Start the MySQL Docker container:**

   ```bash
   docker compose -f docker/docker-compose.yml up -d
   ```

   This will start a MySQL 8 container with a persistent volume at `./docker/mysql-data`.

3. **Connect to MySQL:**

   ```bash
   docker exec -it mysql-db mysql -uroot -psecret
   ```

   - Host: `localhost`
   - Port: `3306`
   - User: `root`
   - Password: `secret`

4. **Run a homework SQL script:**

   ```bash
   ./scripts/run_hw.sh 1 <student-github-username>
   ```

   This will execute the SQL file for HW1 for the specified student.

5. **Run all homework scripts in order:**

   ```bash
   ./scripts/run_all.sh <student-github-username>
   ```

6. **Clean the database (drops all tables):**
   ```bash
   ./scripts/clean_db.sh
   ```

## Submitting Homework

- For each assignment, create a folder under `submissions/hwX/<your-github-username>/` and add:
  - `solution.sql` — your SQL script
  - `explanation.md` — a brief explanation of your approach and any assumptions
- Submit a pull request to this repository.

## Docker & Database Details

- The MySQL data is stored in a Docker volume mapped to `./docker/mysql-data` for persistence.
- The database is named `course_db` by default.
- You can reset the database at any time using the provided scripts.

## Questions?

Open an issue or ask in the course chat!
