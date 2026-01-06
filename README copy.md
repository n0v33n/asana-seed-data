# Asana Enterprise Simulation Dataset Generator

## Project Overview

This project generates a highly realistic synthetic dataset simulating a large B2B SaaS organization's usage of Asana. The dataset is stored in a SQLite database and models a company with 5,000–10,000 employees, spanning engineering, marketing, and operations teams.

The schema and data generation are designed to closely mirror real Asana data structures and usage patterns, including:

- Hierarchical tasks (subtasks via self-referential foreign key)
- Project-specific custom fields
- Sections (columns/boards)
- Tags, comments, and team memberships
- Temporal and relational consistency

This makes the dataset particularly suitable for training and evaluating reinforcement learning (RL) agents in complex, multi-step enterprise workflows, without exploitable artifacts or shortcuts.

## Key Features

- **Realism Grounded in Real-World Sources**: Names, distributions, and patterns derived from public data (e.g., Crunchbase, GitHub issues, Asana reports).
- **Strict Consistency**: Enforced temporal logic (e.g., `completed_at > created_at`), referential integrity, and business rules (e.g., subtasks inherit project).
- **Hybrid Content Generation**: Selective use of LLMs for natural task titles/descriptions, with heuristic fallbacks for scale and control.
- **Scalable Configuration**: Adjustable via environment variables (e.g., user count, project count).

## Database Schema

### ER Diagram Reference

![ER Diagram](dberdiagram.png)

*(An ER diagram visualizing relationships between organizations, teams, users, projects, sections, tasks, comments, custom fields, and tags.)*

### Detailed Tables

(See **Section A: Database Schema** in the provided documentation for full table definitions, columns, constraints, and relationships.)

**Key design decisions:**
- UUIDs for all IDs (mirroring Asana GIDs).
- Self-referential `parent_task_id` in `tasks` for unlimited subtask nesting.
- Separate tables for custom field definitions (project-scoped) and values.
- Global reusable tags with many-to-many task associations.

The schema faithfully represents Asana's data model, including project-specific custom fields, sections as task groupings, and threaded comments.

## Data Generation Methodology

### Methodological Foundations (Section B Continued)

- Grounded in scraped/real-world sources for names, projects, and tasks.
- Empirical distributions from productivity research (e.g., Asana Anatomy of Work reports).
- Selective LLM usage for varied, natural language content.
- Strict temporal and relational guarantees.

### Seed Data Strategy (Section B)

Column-by-column breakdown of generation strategies, sources, and justifications for each table (organizations, teams, users, projects, tasks, etc.).

**Highlights:**
- Task completion rates: Engineering ~70–85%, Marketing ~55–65%, Operations ~40–50%.
- Due date distributions: Realistic horizons with weekday bias and overdue cases.
- Task naming patterns: Enforced conventions (e.g., `[Component] - [Action] - [Detail]` for engineering).

## Prerequisites

- Python 3.8+
- Required packages:

```bash
pip install faker openai python-dotenv pandas
```

*(Note: `sqlite3` and `uuid` are part of the Python standard library.)*

## Environment Configuration

Create a `.env` file in the project root directory with the following content:

```dotenv
OPENAI_API_KEY=your_api_key_here          # Required for LLM-based task generation (optional if using heuristic-only mode)
COMPANY_NAME=Acme SaaS Inc                # Name of the simulated organization
TOTAL_USERS=6000                          # Target number of users (recommended: 5000–10000)
TOTAL_PROJECTS=1200                       # Target number of projects
DB_PATH=output/asana_simulation.sqlite     # Path to the output SQLite database
```

You can add additional optional variables as needed (e.g., for controlling LLM temperature, seed, etc.).

## How to Run

1. Activate your Python virtual environment (if using one).

2. Navigate to the project root directory:

```bash
cd /path/to/asana-seed-data
```

   Example (as in your setup):

```bash
cd D:\Office\Project\AIML PRO\MY PRO\Scalar Assignment\asana-seed-data
```

3. Run the generator:

```bash
python -m src.main
```

**What happens when you run it:**

- Loads environment variables
- Creates the SQLite database and schema
- Sequentially populates all tables with consistent synthetic data
- Uses OpenAI (if API key provided) selectively for realistic task titles and descriptions
- Prints progress logs and final database location

Generation time varies with scale and LLM usage (typically several hours for large datasets).

The resulting database file (`asana_simulation.sqlite` by default) can be opened with any SQLite viewer (e.g., DB Browser for SQLite) or used directly in downstream applications or RL environments.

## Output

- A single SQLite database file at the path specified by `DB_PATH`.
- Fully populated with realistic, relationally consistent data ready for analysis, querying, or agent training.

## Notes

- All constraints are strictly enforced to prevent invalid states that RL agents could exploit.
- LLM usage is limited for cost control; you can adjust the proportion or disable it in the code if preferred.
- The generation logic is modular and lives in the `src/` directory — easy to extend or customize.

This dataset provides a robust, enterprise-scale simulation of Asana, ideal for advanced AI research and development.

**Enjoy!**