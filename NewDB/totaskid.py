import sqlite3

DB_PATH = "Newdb.sqlite"

MIGRATION_SQL = r"""
PRAGMA foreign_keys = OFF;

-- 0) Add uuid columns (idempotent-ish: will fail if column already exists)
ALTER TABLE organizations ADD COLUMN uuid TEXT;
ALTER TABLE teams          ADD COLUMN uuid TEXT;
ALTER TABLE users          ADD COLUMN uuid TEXT;
ALTER TABLE projects       ADD COLUMN uuid TEXT;
ALTER TABLE sections       ADD COLUMN uuid TEXT;
ALTER TABLE tasks          ADD COLUMN uuid TEXT;
ALTER TABLE tags           ADD COLUMN uuid TEXT;
ALTER TABLE comments       ADD COLUMN uuid TEXT;

-- UUIDv4 expression as a repeated inline snippet:
-- lower(hex(randomblob(4)))||'-'||lower(hex(randomblob(2)))||'-'||'4'||substr(lower(hex(randomblob(2))),2)||'-'||substr('89ab',abs(random())%4+1,1)||substr(lower(hex(randomblob(2))),2)||'-'||lower(hex(randomblob(6)))

-- 1) Fill uuid columns (only where NULL)
UPDATE organizations
SET uuid =
  lower(hex(randomblob(4)))||'-'||lower(hex(randomblob(2)))||'-'||'4'||substr(lower(hex(randomblob(2))),2)||'-'||
  substr('89ab',abs(random())%4+1,1)||substr(lower(hex(randomblob(2))),2)||'-'||lower(hex(randomblob(6)))
WHERE uuid IS NULL;

UPDATE teams
SET uuid =
  lower(hex(randomblob(4)))||'-'||lower(hex(randomblob(2)))||'-'||'4'||substr(lower(hex(randomblob(2))),2)||'-'||
  substr('89ab',abs(random())%4+1,1)||substr(lower(hex(randomblob(2))),2)||'-'||lower(hex(randomblob(6)))
WHERE uuid IS NULL;

UPDATE users
SET uuid =
  lower(hex(randomblob(4)))||'-'||lower(hex(randomblob(2)))||'-'||'4'||substr(lower(hex(randomblob(2))),2)||'-'||
  substr('89ab',abs(random())%4+1,1)||substr(lower(hex(randomblob(2))),2)||'-'||lower(hex(randomblob(6)))
WHERE uuid IS NULL;

UPDATE projects
SET uuid =
  lower(hex(randomblob(4)))||'-'||lower(hex(randomblob(2)))||'-'||'4'||substr(lower(hex(randomblob(2))),2)||'-'||
  substr('89ab',abs(random())%4+1,1)||substr(lower(hex(randomblob(2))),2)||'-'||lower(hex(randomblob(6)))
WHERE uuid IS NULL;

UPDATE sections
SET uuid =
  lower(hex(randomblob(4)))||'-'||lower(hex(randomblob(2)))||'-'||'4'||substr(lower(hex(randomblob(2))),2)||'-'||
  substr('89ab',abs(random())%4+1,1)||substr(lower(hex(randomblob(2))),2)||'-'||lower(hex(randomblob(6)))
WHERE uuid IS NULL;

UPDATE tasks
SET uuid =
  lower(hex(randomblob(4)))||'-'||lower(hex(randomblob(2)))||'-'||'4'||substr(lower(hex(randomblob(2))),2)||'-'||
  substr('89ab',abs(random())%4+1,1)||substr(lower(hex(randomblob(2))),2)||'-'||lower(hex(randomblob(6)))
WHERE uuid IS NULL;

UPDATE tags
SET uuid =
  lower(hex(randomblob(4)))||'-'||lower(hex(randomblob(2)))||'-'||'4'||substr(lower(hex(randomblob(2))),2)||'-'||
  substr('89ab',abs(random())%4+1,1)||substr(lower(hex(randomblob(2))),2)||'-'||lower(hex(randomblob(6)))
WHERE uuid IS NULL;

UPDATE comments
SET uuid =
  lower(hex(randomblob(4)))||'-'||lower(hex(randomblob(2)))||'-'||'4'||substr(lower(hex(randomblob(2))),2)||'-'||
  substr('89ab',abs(random())%4+1,1)||substr(lower(hex(randomblob(2))),2)||'-'||lower(hex(randomblob(6)))
WHERE uuid IS NULL;


-- 2) Rewrite all FK columns to UUID values (using scalar subqueries)
UPDATE teams
SET organization_id = (SELECT uuid FROM organizations o WHERE o.id = teams.organization_id)
WHERE organization_id IS NOT NULL;

UPDATE users
SET team_id = (SELECT uuid FROM teams t WHERE t.id = users.team_id)
WHERE team_id IS NOT NULL;

UPDATE projects
SET team_id  = (SELECT uuid FROM teams t WHERE t.id = projects.team_id),
    owner_id = (SELECT uuid FROM users u WHERE u.id = projects.owner_id)
WHERE team_id IS NOT NULL OR owner_id IS NOT NULL;

UPDATE sections
SET project_id = (SELECT uuid FROM projects p WHERE p.id = sections.project_id)
WHERE project_id IS NOT NULL;

UPDATE tasks
SET project_id     = (SELECT uuid FROM projects p WHERE p.id = tasks.project_id),
    section_id     = (SELECT uuid FROM sections s WHERE s.id = tasks.section_id),
    assignee_id    = (SELECT uuid FROM users u WHERE u.id = tasks.assignee_id),
    parent_task_id = (SELECT uuid FROM tasks pt WHERE pt.id = tasks.parent_task_id)
WHERE project_id IS NOT NULL OR section_id IS NOT NULL OR assignee_id IS NOT NULL OR parent_task_id IS NOT NULL;

UPDATE task_tags
SET task_id = (SELECT uuid FROM tasks t WHERE t.id = task_tags.task_id),
    tag_id  = (SELECT uuid FROM tags g  WHERE g.id = task_tags.tag_id);

UPDATE comments
SET task_id   = (SELECT uuid FROM tasks t WHERE t.id = comments.task_id),
    author_id = (SELECT uuid FROM users u WHERE u.id = comments.author_id)
WHERE task_id IS NOT NULL OR author_id IS NOT NULL;


-- 3) Rebuild tables so uuid becomes the real PRIMARY KEY named "id"
-- This is required because SQLite ALTER TABLE is limited. [web:75]
-- Organizations
CREATE TABLE organizations_new (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL
);
INSERT INTO organizations_new(id, name)
SELECT uuid, name FROM organizations;

-- Teams
CREATE TABLE teams_new (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  organization_id TEXT,
  FOREIGN KEY (organization_id) REFERENCES organizations(id)
);
INSERT INTO teams_new(id, name, organization_id)
SELECT uuid, name, organization_id FROM teams;

-- Users
CREATE TABLE users_new (
  id TEXT PRIMARY KEY,
  full_name TEXT NOT NULL,
  email TEXT UNIQUE NOT NULL,
  role TEXT NOT NULL,
  team_id TEXT,
  joined_at TIMESTAMP,
  FOREIGN KEY (team_id) REFERENCES teams(id)
);
INSERT INTO users_new(id, full_name, email, role, team_id, joined_at)
SELECT uuid, full_name, email, role, team_id, joined_at FROM users;

-- Projects
CREATE TABLE projects_new (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  description TEXT,
  team_id TEXT,
  owner_id TEXT,
  start_date DATE,
  end_date DATE,
  status TEXT,
  FOREIGN KEY (team_id) REFERENCES teams(id),
  FOREIGN KEY (owner_id) REFERENCES users(id)
);
INSERT INTO projects_new(id, name, description, team_id, owner_id, start_date, end_date, status)
SELECT uuid, name, description, team_id, owner_id, start_date, end_date, status FROM projects;

-- Sections
CREATE TABLE sections_new (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  project_id TEXT,
  FOREIGN KEY (project_id) REFERENCES projects(id)
);
INSERT INTO sections_new(id, name, project_id)
SELECT uuid, name, project_id FROM sections;

-- Tasks
CREATE TABLE tasks_new (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  description TEXT,
  project_id TEXT,
  section_id TEXT,
  assignee_id TEXT,
  parent_task_id TEXT,
  created_at TIMESTAMP,
  due_date DATE,
  completed BOOLEAN,
  completed_at TIMESTAMP,
  FOREIGN KEY (project_id) REFERENCES projects(id),
  FOREIGN KEY (section_id) REFERENCES sections(id),
  FOREIGN KEY (assignee_id) REFERENCES users(id),
  FOREIGN KEY (parent_task_id) REFERENCES tasks(id)
);
INSERT INTO tasks_new(id, name, description, project_id, section_id, assignee_id, parent_task_id, created_at, due_date, completed, completed_at)
SELECT uuid, name, description, project_id, section_id, assignee_id, parent_task_id, created_at, due_date, completed, completed_at
FROM tasks;

-- Tags
CREATE TABLE tags_new (
  id TEXT PRIMARY KEY,
  name TEXT UNIQUE NOT NULL,
  color TEXT,
  created_at TIMESTAMP
);
INSERT INTO tags_new(id, name, color, created_at)
SELECT uuid, name, color, created_at FROM tags;

-- Task_Tags
CREATE TABLE task_tags_new (
  task_id TEXT NOT NULL,
  tag_id TEXT NOT NULL,
  PRIMARY KEY (task_id, tag_id),
  FOREIGN KEY (task_id) REFERENCES tasks(id),
  FOREIGN KEY (tag_id) REFERENCES tags(id)
);
INSERT INTO task_tags_new(task_id, tag_id)
SELECT task_id, tag_id FROM task_tags;

-- Comments
CREATE TABLE comments_new (
  id TEXT PRIMARY KEY,
  task_id TEXT,
  author_id TEXT,
  content TEXT,
  created_at TIMESTAMP,
  FOREIGN KEY (task_id) REFERENCES tasks(id),
  FOREIGN KEY (author_id) REFERENCES users(id)
);
INSERT INTO comments_new(id, task_id, author_id, content, created_at)
SELECT uuid, task_id, author_id, content, created_at FROM comments;


-- 4) Swap
DROP TABLE comments;
DROP TABLE task_tags;
DROP TABLE tags;
DROP TABLE tasks;
DROP TABLE sections;
DROP TABLE projects;
DROP TABLE users;
DROP TABLE teams;
DROP TABLE organizations;

ALTER TABLE organizations_new RENAME TO organizations;
ALTER TABLE teams_new         RENAME TO teams;
ALTER TABLE users_new         RENAME TO users;
ALTER TABLE projects_new      RENAME TO projects;
ALTER TABLE sections_new      RENAME TO sections;
ALTER TABLE tasks_new         RENAME TO tasks;
ALTER TABLE tags_new          RENAME TO tags;
ALTER TABLE task_tags_new     RENAME TO task_tags;
ALTER TABLE comments_new      RENAME TO comments;

PRAGMA foreign_keys = ON;

-- Optional: check FKs after migration
PRAGMA foreign_key_check;
"""

def main():
    with sqlite3.connect(DB_PATH) as conn:
        # Don't start an explicit transaction around PRAGMA foreign_keys toggling.
        conn.executescript(MIGRATION_SQL)  # executes multiple statements safely [web:33]
        conn.commit()

if __name__ == "__main__":
    main()
