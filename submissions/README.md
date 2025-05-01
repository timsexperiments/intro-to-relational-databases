# Submissions

This guide explains how ot submit your HW assignments.

## Submitting Your Homework

### How to Submit

1. For each homework assignment, create a folder named with your GitHub username inside the corresponding homework directory.  
   For example, for Homework 1, your files should be in:  
   `submissions/homework_1/<your-github-username>/`

2. Inside your folder, include:
   - `hw.sql` — Your SQL script for the assignment.
   - `hw.md` — Your written answers and explanations for the assignment questions.

**Example:**

```
submissions/
  homework_1/
    alice123/
      hw.sql
      hw.md
  homework_2/
    alice123/
      hw.sql
      hw.md
```

**Instructions:**

- Complete the homework as described in the assignment markdown.
- Place your solution files in the correct directory as shown above.
- Commit your changes and push your branch.
- Open a pull request to submit your homework for review.

**Notes:**

- Each homework _may_ build on the previous ones, so make sure you complete them in order.
- Your SQL script should not drop or conflict with previous tables/data.
- If you need to update a previous submission, just update your files and submit a new pull request.

**Review Process:**

- The instructor will review your pull request, provide feedback, and merge it when complete.
- If changes are needed, update your files and push again.

**Automated Testing:**

- Scripts are provided to run your SQL files against the course database.
- See the root README for details on running and testing homework scripts.
