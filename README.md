# Relational Database Course

Welcome! This repository contains a collaborative, hands-on course for learning relational databases with MySQL. Each lesson is paired with a homework assignment. Students submit their solutions as pull requests.

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
