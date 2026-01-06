# Section B (Continued): Methodological Foundations

## 1. Scraped / Real-World Data Sources

Although the final dataset is synthetically generated, its structure and distributions are grounded in real-world enterprise data sources to maximize realism.

### Company & Organization Naming
* **Reference Sources**:
  * Y Combinator Startup Directory
  * Crunchbase company listings
* **Usage in Simulation**:
  * Organization names follow common SaaS naming conventions (e.g., “<Brand> Systems”, “<Brand> Labs”).
  * Email domains are derived directly from organization names to simulate verified Asana organizations.

### User Names
* **Reference Sources**:
  * U.S. Census Bureau first/last name frequency data
  * Social Security Administration baby name distributions
* **Usage in Simulation**:
  * Faker library seeded with realistic name distributions.
  * Avoids artificial repetition or unrealistic names.
  * Emails follow enterprise formats (`<firstname.lastname@company.com>`).

### Project Names
* **Reference Sources**:
  * Public Asana project templates
  * GitHub project boards (engineering)
  * ProductHunt launches (marketing initiatives)
* **Usage in Simulation**:
  * Engineering projects use goal-oriented naming (“Platform Stability Q4”).
  * Marketing projects follow campaign-style naming (“SEO Growth Sprint”).

### Task Names & Descriptions
* **Reference Sources**:
  * Public GitHub Issues (for engineering tasks)
  * Asana Community templates
  * Jira / Linear public issue examples
* **Usage in Simulation**:
  * Task title patterns are explicitly enforced:
    * Engineering: `[Component] - [Action] - [Detail]`
    * Marketing: `[Campaign] - [Deliverable]`
  * Descriptions mirror real issue-tracking language, bullet formatting, and update styles.

## 2. Distribution Research & Empirical Benchmarks

Synthetic data distributions are informed by published productivity research and industry norms, rather than uniform randomness.

### Task Completion Rates
* **Reference Sources**:
  * Asana Anatomy of Work reports
  * Agile velocity benchmarks
* **Applied Strategy**:
  * Engineering projects: ~70–85% completion
  * Marketing projects: ~55–65%
  * Operations / ongoing work: ~40–50%
* **Rationale**:
  * Long-running initiatives accumulate unfinished tasks.
  * Engineering sprint work has higher closure rates.

### Due Date Distributions
* **Reference Sources**:
  * Scrum sprint planning guidelines (1–2 weeks)
  * Product roadmap planning literature
* **Applied Distribution**:
  * 25% within 1 week
  * 40% within 1 month
  * 20% within 1–3 months
  * 10% no due date
  * 5% overdue
* **Additional Heuristics**:
  * Due dates avoid weekends in most cases.
  * Engineering tasks cluster around sprint-length horizons.

### Team Size & Composition
* **Reference Sources**:
  * McKinsey org-design research
  * Spotify engineering team model
* **Applied Strategy**:
  * Teams range from ~6–12 members.
  * Users may belong to multiple teams to simulate matrix organizations.

## 3. LLM-Based Content Generation

Large Language Models are used selectively and intentionally, not indiscriminately.

### Prompt Templates
Prompts are stored version-controlled in `/prompts/task_prompt_template.txt`.

**Example :**
""" 
You are generating realistic Asana tasks for a {project_type} project.

Project Context:
{project_context}

Generate {n} task titles and descriptions.

Rules:
- Titles must follow realistic enterprise patterns
- Avoid generic names like "Task 1"
- Descriptions should resemble real internal work notes
- Output JSON only
"""

### Ensuring Variety
* Temperature: Moderately high (≈0.7) to encourage diversity.
* Parameterized Prompts: Project name, type, and status injected dynamically.
* **Hybrid Strategy**:
  * LLM used for a subset of projects (cost-controlled).
  * Heuristic fallback ensures scalability without sacrificing realism.

This hybrid approach prevents overfitting to LLM artifacts while retaining natural language quality.

## 4. Temporal Consistency Guarantees

Temporal fields are generated with strict logical constraints to avoid impossible states.

### Enforced Rules
* `completed_at > created_at`
* `due_date` may be:
  * After creation (most cases)
  * Before creation (explicit overdue edge cases)
  * NULL (no deadline)
* `comment.created_at` always after `task.created_at`
* Project timelines:
  * `start_date < end_date`
  * Tasks fall within project duration

### Additional Temporal Realism
* Task creation biased toward weekdays (Mon–Wed).
* Completion timestamps follow a skewed distribution (fast early completions, long tail).

These constraints ensure RL agents cannot exploit invalid temporal shortcuts.

## 5. Relational Consistency & Business Logic

The dataset enforces strict referential integrity and domain logic, both at the schema and generation layers.

### Referential Integrity
* All foreign keys reference valid parent rows.
* Many-to-many relationships (`team_memberships`, `task_tags`) use composite primary keys.
* Self-referential hierarchy (`tasks.parent_task_id`) enforces valid task nesting.

### Business Logic Constraints
* Tasks belong to exactly one project.
* Sections are project-scoped; tasks cannot reference sections from other projects.
* Subtasks always inherit the project of their parent task.
* Custom field values reference valid field definitions applicable to the project.
* Tags are global and reusable, consistent with Asana’s model.
