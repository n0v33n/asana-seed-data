# Section B: Seed Data Methodology

This section describes the column-by-column data generation strategy for each table in the Asana simulation. The guiding principle is to balance realism, scalability, and internal consistency, while avoiding patterns that could create shortcuts for reinforcement-learning agents.

### Table: organizations

| Column       | Data Type          | Source Strategy | Methodology & Justification |
|--------------|--------------------|-----------------|-----------------------------|
| id           | TEXT (UUID)        | Generated       | UUIDv4 used to simulate Asana GIDs and ensure uniqueness across entities. |
| name         | TEXT               | Synthetic       | Generated as a realistic B2B SaaS company name using common naming conventions (e.g., “Acme Systems”). |
| domain       | TEXT               | Synthetic       | Company email domain derived from organization name (e.g., acme.com). Used to model Asana organizations with verified domains. |
| created_at   | TIMESTAMP          | Synthetic       | Fixed historical timestamp to represent an established organization. |

### Table: teams

| Column          | Data Type          | Source Strategy      | Methodology & Justification |
|-----------------|--------------------|----------------------|-----------------------------|
| id              | TEXT (UUID)        | Generated            | UUIDv4 for referential integrity. |
| organization_id | TEXT (FK)          | Derived              | All teams belong to the single simulated organization. |
| name            | TEXT               | Synthetic + Heuristics | Team names follow common enterprise structures (e.g., “Backend Engineering”, “Growth Marketing”, “Operations”). |
| created_at      | TIMESTAMP          | Synthetic            | Distributed across early organization history to reflect gradual team formation. |

### Table: users

| Column       | Data Type          | Source Strategy      | Methodology & Justification |
|--------------|--------------------|----------------------|-----------------------------|
| id           | TEXT (UUID)        | Generated            | UUIDv4 ensures global uniqueness. |
| email        | TEXT               | Synthetic            | Constructed from first/last names and organization domain to simulate real enterprise emails. |
| first_name   | TEXT               | Faker                | Generated from realistic name distributions. |
| last_name    | TEXT               | Faker                | Same as above. |
| role         | TEXT               | Synthetic            | Assigned from common enterprise roles (Engineer, PM, Designer, Marketer, Ops). |
| created_at   | TIMESTAMP          | Synthetic            | Spread across a 6-month window to reflect organizational growth. |

### Table: team_memberships

| Column     | Data Type   | Source Strategy | Methodology & Justification |
|------------|-------------|-----------------|-----------------------------|
| user_id    | TEXT (FK)   | Derived         | References existing users. |
| team_id    | TEXT (FK)   | Derived         | Users assigned to 1–2 teams to reflect realistic cross-team collaboration. |
| joined_at  | TIMESTAMP   | Synthetic       | Always after user creation, preserving temporal consistency. |

### Table: projects

| Column          | Data Type          | Source Strategy      | Methodology & Justification |
|-----------------|--------------------|----------------------|-----------------------------|
| id              | TEXT (UUID)        | Generated            | UUIDv4 to mirror Asana project identifiers. |
| team_id         | TEXT (FK)          | Derived              | Projects owned by a single team, consistent with Asana. |
| name            | TEXT               | Synthetic + Heuristics | Project names follow patterns inspired by public Asana templates and GitHub project boards (e.g., “Q4 Platform Stability”). |
| type            | TEXT               | Synthetic            | Categorized as engineering, marketing, or operations to drive downstream task behavior. |
| status          | TEXT               | Synthetic            | Selected from realistic project states (active, planning, completed). |
| start_date      | DATE               | Synthetic            | Distributed over a 6-month window. |
| end_date        | DATE               | Derived              | Always after start_date; varies by project type. |
| created_at      | TIMESTAMP          | Derived              | Slightly before start_date to reflect planning phase. |

### Table: sections

| Column     | Data Type   | Source Strategy   | Methodology & Justification |
|------------|-------------|-------------------|-----------------------------|
| id         | TEXT (UUID) | Generated         | UUIDv4 identifiers. |
| project_id | TEXT (FK)   | Derived           | Sections scoped per project. |
| name       | TEXT        | Heuristics        | Standard workflow sections (Backlog, In Progress, Review, Done). |
| position   | INTEGER     | Synthetic         | Ordered to reflect UI layout in Asana. |

### Table: tasks

| Column           | Data Type            | Source Strategy       | Methodology & Justification |
|------------------|----------------------|-----------------------|-----------------------------|
| id               | TEXT (UUID)          | Generated             | UUIDv4 generation to simulate Asana’s GID format. |
| name             | TEXT                 | LLM + Heuristics      | Engineering tasks follow “[Component] - [Action] - [Detail]” patterns derived from public GitHub issues. Marketing tasks follow “[Campaign] - [Deliverable]”. LLM is used selectively for realism, with heuristic fallback for scale. |
| description      | TEXT                 | LLM + Templates       | Rich descriptions with explicit length distribution: 20% empty, 50% short (1–3 sentences), 30% detailed with bullet points. Reflects real Asana usage patterns. |
| project_id       | TEXT (FK)            | Derived               | Task always belongs to exactly one project. |
| section_id       | TEXT (FK)            | Derived               | Assigned to valid section within the same project. |
| assignee_id      | TEXT (FK)            | Derived               | 15% of tasks unassigned. Others assigned randomly from users, approximating workload distribution observed in Asana benchmarks. |
| parent_task_id   | TEXT (FK)            | Derived               | Used to represent subtasks via self-referencing hierarchy. |
| created_at       | TIMESTAMP            | Synthetic             | Weekday-biased generation (Mon–Wed higher frequency) within project timeline. |
| due_date         | DATE                 | Synthetic + Heuristics | Distribution: 25% ≤ 1 week, 40% ≤ 1 month, 20% 1–3 months, 10% no due date, 5% overdue. Preserves realistic planning horizons. |
| completed        | BOOLEAN              | Synthetic + Heuristics | Completion probability varies by project type (engineering ≈75%, marketing ≈60%, ops ≈50%). |
| completed_at     | TIMESTAMP            | Derived               | If completed, set 1–14 days after creation using log-normal-like skew. Always after created_at and before now. |

### Table: comments

| Column            | Data Type   | Source Strategy      | Methodology & Justification |
|-------------------|-------------|----------------------|-----------------------------|
| id                | TEXT (UUID) | Generated            | Unique identifier. |
| task_id           | TEXT (FK)   | Derived              | Each comment attached to a valid task. |
| author_id         | TEXT (FK)   | Derived              | Selected from users, often matching assignee to simulate ownership. |
| body              | TEXT        | Synthetic + Templates | Generated short conversational updates, questions, or status notes. |
| created_at        | TIMESTAMP   | Derived              | Always after task creation to maintain temporal consistency. |

### Table: custom_field_definitions

| Column      | Data Type          | Source Strategy | Methodology & Justification |
|-------------|--------------------|-----------------|-----------------------------|
| id          | TEXT (UUID)        | Generated       | Unique identifier. |
| name        | TEXT               | Synthetic       | Examples: Priority, Effort, Sprint, Risk. |
| field_type  | TEXT               | Synthetic       | Enum-like values (text, number, enum). |
| project_id  | TEXT (FK)          | Derived         | Fields can be project-specific or global, mirroring Asana behavior. |
| created_at  | TIMESTAMP          | Synthetic       | Generated before task population. |

### Table: custom_field_values

| Column            | Data Type   | Source Strategy | Methodology & Justification |
|-------------------|-------------|-----------------|-----------------------------|
| task_id           | TEXT (FK)   | Derived         | References valid tasks. |
| custom_field_id   | TEXT (FK)   | Derived         | References field definitions. |
| value             | TEXT        | Synthetic       | Populated based on field type (e.g., numeric effort, enum priority). |

### Table: tags

| Column      | Data Type          | Source Strategy      | Methodology & Justification |
|-------------|--------------------|----------------------|-----------------------------|
| id          | TEXT (UUID)        | Generated            | UUIDv4 identifier. |
| name        | TEXT               | Synthetic + Heuristics | Common enterprise tags: Priority, Blocked, Bug, SEO, Customer Request. |
| color       | TEXT               | Synthetic            | Chosen from standard Asana color palette. |
| created_at  | TIMESTAMP          | Synthetic            | Generated at tag creation time. |

### Table: task_tags

| Column   | Data Type   | Source Strategy | Methodology & Justification |
|----------|-------------|-----------------|-----------------------------|
| task_id  | TEXT (FK)   | Derived         | Valid task reference. |
| tag_id   | TEXT (FK)   | Derived         | Valid tag reference. |


### Temporal & Relational Consistency Guarantees

- All foreign keys reference valid parent entities.
- `completed_at > created_at` is strictly enforced.
- Subtasks always belong to the same project as their parent.
- Sections are project-scoped.
- Custom fields and tags are reusable but constrained by valid relationships.
