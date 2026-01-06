PRAGMA foreign_keys = ON;

CREATE TABLE organizations (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL
);

CREATE TABLE teams (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    organization_id TEXT,
    FOREIGN KEY (organization_id) REFERENCES organizations(id)
);

CREATE TABLE users (
    id TEXT PRIMARY KEY,
    full_name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    role TEXT NOT NULL,
    team_id TEXT,
    joined_at TIMESTAMP,
    FOREIGN KEY (team_id) REFERENCES teams(id)
);

CREATE TABLE projects (
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

CREATE TABLE sections (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    project_id TEXT,
    FOREIGN KEY (project_id) REFERENCES projects(id)
);

CREATE TABLE tasks (
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

CREATE TABLE tags (
    id TEXT PRIMARY KEY,
    name TEXT UNIQUE NOT NULL,
    color TEXT,
    created_at TIMESTAMP
);

CREATE TABLE task_tags (
    task_id TEXT NOT NULL,
    tag_id TEXT NOT NULL,
    PRIMARY KEY (task_id, tag_id),
    FOREIGN KEY (task_id) REFERENCES tasks(id),
    FOREIGN KEY (tag_id) REFERENCES tags(id)
);

CREATE TABLE comments (
    id TEXT PRIMARY KEY,
    task_id TEXT,
    author_id TEXT,
    content TEXT,
    created_at TIMESTAMP,
    FOREIGN KEY (task_id) REFERENCES tasks(id),
    FOREIGN KEY (author_id) REFERENCES users(id)
);
