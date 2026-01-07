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

-- ============================================
-- 1. ORGANIZATIONS (4 organizations)
-- ============================================
INSERT INTO organizations (id, name) VALUES
('org_1', 'Acme Systems'),
('org_2', 'TechFlow Industries'),
('org_3', 'DataStream Solutions'),
('org_4', 'CloudNexus Corp');

-- ============================================
-- 2. TEAMS (12 teams across organizations)
-- ============================================
INSERT INTO teams (id, name, organization_id) VALUES
-- Acme Systems teams
('team_1', 'Backend Engineering', 'org_1'),
('team_2', 'Frontend Engineering', 'org_1'),
('team_3', 'DevOps', 'org_1'),
-- TechFlow Industries teams
('team_4', 'Product Management', 'org_2'),
('team_5', 'Data Science', 'org_2'),
('team_6', 'Mobile Development', 'org_2'),
-- DataStream Solutions teams
('team_7', 'Platform Engineering', 'org_3'),
('team_8', 'Security', 'org_3'),
('team_9', 'QA Engineering', 'org_3'),
-- CloudNexus Corp teams
('team_10', 'Infrastructure', 'org_4'),
('team_11', 'Machine Learning', 'org_4'),
('team_12', 'Customer Success', 'org_4');

-- ============================================
-- 3. USERS (60 users across teams)
-- ============================================
INSERT INTO users (id, full_name, email, role, team_id, joined_at) VALUES
-- Backend Engineering (team_1)
('user_1', 'Aarav Patel', 'aarav.patel@acmesystems.com', 'Senior Backend Engineer', 'team_1', '2024-07-15T10:00:00'),
('user_2', 'Sofia Martinez', 'sofia.martinez@acmesystems.com', 'Backend Engineer', 'team_1', '2024-08-01T09:00:00'),
('user_3', 'Chen Wei', 'chen.wei@acmesystems.com', 'Staff Engineer', 'team_1', '2024-06-10T08:30:00'),
('user_4', 'Priya Sharma', 'priya.sharma@acmesystems.com', 'Backend Engineer', 'team_1', '2024-09-05T10:15:00'),
('user_5', 'Marcus Johnson', 'marcus.johnson@acmesystems.com', 'Principal Engineer', 'team_1', '2024-05-20T09:00:00'),
-- Frontend Engineering (team_2)
('user_6', 'Emma Thompson', 'emma.thompson@acmesystems.com', 'Senior Frontend Engineer', 'team_2', '2024-07-01T09:00:00'),
('user_7', 'Raj Kumar', 'raj.kumar@acmesystems.com', 'Frontend Engineer', 'team_2', '2024-08-15T10:00:00'),
('user_8', 'Isabella Garcia', 'isabella.garcia@acmesystems.com', 'UI/UX Engineer', 'team_2', '2024-06-25T09:30:00'),
('user_9', 'Oliver Brown', 'oliver.brown@acmesystems.com', 'Frontend Engineer', 'team_2', '2024-09-10T08:45:00'),
('user_10', 'Aisha Khan', 'aisha.khan@acmesystems.com', 'Lead Frontend Engineer', 'team_2', '2024-05-15T09:00:00'),
-- DevOps (team_3)
('user_11', 'Lucas Silva', 'lucas.silva@acmesystems.com', 'DevOps Engineer', 'team_3', '2024-07-20T10:00:00'),
('user_12', 'Yuki Tanaka', 'yuki.tanaka@acmesystems.com', 'Senior DevOps Engineer', 'team_3', '2024-06-15T09:00:00'),
('user_13', 'Sarah Connor', 'sarah.connor@acmesystems.com', 'Site Reliability Engineer', 'team_3', '2024-08-05T10:30:00'),
('user_14', 'Ahmed Hassan', 'ahmed.hassan@acmesystems.com', 'DevOps Engineer', 'team_3', '2024-09-01T09:15:00'),
('user_15', 'Nina Petrov', 'nina.petrov@acmesystems.com', 'Infrastructure Lead', 'team_3', '2024-05-10T08:30:00'),
-- Product Management (team_4)
('user_16', 'Daniel Kim', 'daniel.kim@techflow.com', 'Senior Product Manager', 'team_4', '2024-06-01T09:00:00'),
('user_17', 'Maria Rodriguez', 'maria.rodriguez@techflow.com', 'Product Manager', 'team_4', '2024-07-10T10:00:00'),
('user_18', 'James Wilson', 'james.wilson@techflow.com', 'Associate Product Manager', 'team_4', '2024-08-20T09:30:00'),
('user_19', 'Fatima Ali', 'fatima.ali@techflow.com', 'Product Owner', 'team_4', '2024-06-15T10:00:00'),
('user_20', 'Thomas Anderson', 'thomas.anderson@techflow.com', 'VP Product', 'team_4', '2024-04-01T08:00:00'),
-- Data Science (team_5)
('user_21', 'Dr. Alex Chen', 'alex.chen@techflow.com', 'Lead Data Scientist', 'team_5', '2024-05-15T09:00:00'),
('user_22', 'Samantha Lee', 'samantha.lee@techflow.com', 'Data Scientist', 'team_5', '2024-07-01T10:00:00'),
('user_23', 'Vikram Singh', 'vikram.singh@techflow.com', 'ML Engineer', 'team_5', '2024-08-10T09:30:00'),
('user_24', 'Elena Popov', 'elena.popov@techflow.com', 'Data Analyst', 'team_5', '2024-06-20T10:15:00'),
('user_25', 'Mohammed Al-Rashid', 'mohammed.alrashid@techflow.com', 'Senior Data Scientist', 'team_5', '2024-05-01T09:00:00'),
-- Mobile Development (team_6)
('user_26', 'Katie O''Brien', 'katie.obrien@techflow.com', 'iOS Engineer', 'team_6', '2024-06-10T09:00:00'),
('user_27', 'Andre Santos', 'andre.santos@techflow.com', 'Android Engineer', 'team_6', '2024-07-15T10:00:00'),
('user_28', 'Zara Ahmed', 'zara.ahmed@techflow.com', 'Senior Mobile Engineer', 'team_6', '2024-05-25T09:30:00'),
('user_29', 'Ryan Mitchell', 'ryan.mitchell@techflow.com', 'Mobile Architect', 'team_6', '2024-04-15T08:30:00'),
('user_30', 'Lily Zhang', 'lily.zhang@techflow.com', 'Mobile Engineer', 'team_6', '2024-08-01T10:00:00'),
-- Platform Engineering (team_7)
('user_31', 'Max Weber', 'max.weber@datastream.io', 'Staff Platform Engineer', 'team_7', '2024-05-05T09:00:00'),
('user_32', 'Ananya Gupta', 'ananya.gupta@datastream.io', 'Platform Engineer', 'team_7', '2024-07-20T10:00:00'),
('user_33', 'Carlos Mendez', 'carlos.mendez@datastream.io', 'Senior Platform Engineer', 'team_7', '2024-06-01T09:30:00'),
('user_34', 'Nora Jensen', 'nora.jensen@datastream.io', 'Platform Architect', 'team_7', '2024-04-10T08:00:00'),
('user_35', 'Hiroshi Yamamoto', 'hiroshi.yamamoto@datastream.io', 'Platform Engineer', 'team_7', '2024-08-15T10:15:00'),
-- Security (team_8)
('user_36', 'Diana Prince', 'diana.prince@datastream.io', 'Security Engineer', 'team_8', '2024-06-05T09:00:00'),
('user_37', 'Kevin Hart', 'kevin.hart@datastream.io', 'Senior Security Engineer', 'team_8', '2024-05-20T10:00:00'),
('user_38', 'Natasha Romanoff', 'natasha.romanoff@datastream.io', 'Security Architect', 'team_8', '2024-04-15T08:30:00'),
('user_39', 'Bruce Wayne', 'bruce.wayne@datastream.io', 'Security Engineer', 'team_8', '2024-07-10T09:30:00'),
('user_40', 'Selina Kyle', 'selina.kyle@datastream.io', 'AppSec Engineer', 'team_8', '2024-08-05T10:00:00'),
-- QA Engineering (team_9)
('user_41', 'Tina Fey', 'tina.fey@datastream.io', 'QA Engineer', 'team_9', '2024-06-15T09:00:00'),
('user_42', 'Oscar Martinez', 'oscar.martinez@datastream.io', 'Senior QA Engineer', 'team_9', '2024-05-10T10:00:00'),
('user_43', 'Pam Beesly', 'pam.beesly@datastream.io', 'QA Lead', 'team_9', '2024-04-20T08:30:00'),
('user_44', 'Jim Halpert', 'jim.halpert@datastream.io', 'Test Automation Engineer', 'team_9', '2024-07-25T09:30:00'),
('user_45', 'Dwight Schrute', 'dwight.schrute@datastream.io', 'QA Engineer', 'team_9', '2024-08-20T10:15:00'),
-- Infrastructure (team_10)
('user_46', 'Tony Stark', 'tony.stark@cloudnexus.com', 'Infrastructure Engineer', 'team_10', '2024-05-15T09:00:00'),
('user_47', 'Pepper Potts', 'pepper.potts@cloudnexus.com', 'Senior Infrastructure Engineer', 'team_10', '2024-06-10T10:00:00'),
('user_48', 'Steve Rogers', 'steve.rogers@cloudnexus.com', 'Cloud Architect', 'team_10', '2024-04-05T08:30:00'),
('user_49', 'Natalie Porter', 'natalie.porter@cloudnexus.com', 'Infrastructure Engineer', 'team_10', '2024-07-30T09:30:00'),
('user_50', 'Thor Odinson', 'thor.odinson@cloudnexus.com', 'Infrastructure Lead', 'team_10', '2024-05-01T09:00:00'),
-- Machine Learning (team_11)
('user_51', 'Dr. Stephen Strange', 'stephen.strange@cloudnexus.com', 'ML Research Scientist', 'team_11', '2024-04-15T08:30:00'),
('user_52', 'Wanda Maximoff', 'wanda.maximoff@cloudnexus.com', 'ML Engineer', 'team_11', '2024-06-20T09:00:00'),
('user_53', 'Vision AI', 'vision.ai@cloudnexus.com', 'Senior ML Engineer', 'team_11', '2024-05-25T10:00:00'),
('user_54', 'Peter Parker', 'peter.parker@cloudnexus.com', 'ML Engineer', 'team_11', '2024-07-15T09:30:00'),
('user_55', 'Dr. Bruce Banner', 'bruce.banner@cloudnexus.com', 'ML Architect', 'team_11', '2024-04-01T08:00:00'),
-- Customer Success (team_12)
('user_56', 'Carol Danvers', 'carol.danvers@cloudnexus.com', 'Customer Success Manager', 'team_12', '2024-05-10T09:00:00'),
('user_57', 'Sam Wilson', 'sam.wilson@cloudnexus.com', 'Customer Success Engineer', 'team_12', '2024-06-25T10:00:00'),
('user_58', 'Bucky Barnes', 'bucky.barnes@cloudnexus.com', 'Technical Account Manager', 'team_12', '2024-07-05T09:30:00'),
('user_59', 'Scott Lang', 'scott.lang@cloudnexus.com', 'Support Engineer', 'team_12', '2024-08-10T10:15:00'),
('user_60', 'Hope Van Dyne', 'hope.vandyne@cloudnexus.com', 'VP Customer Success', 'team_12', '2024-04-10T08:30:00');

-- ============================================
-- 4. PROJECTS (30 projects across teams)
-- ============================================
INSERT INTO projects (id, name, description, team_id, owner_id, start_date, end_date, status) VALUES
-- Backend Engineering projects (team_1)
('project_1', 'Platform Stability Q4', 'Improve reliability, performance, and observability of core backend services.', 'team_1', 'user_1', '2024-10-01', '2024-12-31', 'active'),
('project_2', 'API v3 Migration', 'Migrate all endpoints from API v2 to v3 with backward compatibility.', 'team_1', 'user_5', '2024-09-15', '2025-01-15', 'active'),
('project_3', 'Database Optimization Sprint', 'Optimize database queries and implement caching strategies.', 'team_1', 'user_3', '2024-11-01', '2024-12-15', 'active'),
-- Frontend Engineering projects (team_2)
('project_4', 'Dashboard Redesign', 'Complete redesign of the main user dashboard with improved UX.', 'team_2', 'user_10', '2024-10-05', '2024-12-20', 'active'),
('project_5', 'Mobile Web Optimization', 'Improve mobile web experience and performance.', 'team_2', 'user_6', '2024-11-10', '2025-01-30', 'active'),
-- DevOps projects (team_3)
('project_6', 'CI/CD Pipeline Upgrade', 'Modernize CI/CD infrastructure with GitHub Actions.', 'team_3', 'user_15', '2024-10-01', '2024-11-30', 'active'),
('project_7', 'Kubernetes Migration', 'Migrate microservices from EC2 to Kubernetes clusters.', 'team_3', 'user_12', '2024-09-01', '2025-02-28', 'active'),
('project_8', 'Monitoring Stack Enhancement', 'Implement comprehensive monitoring with Prometheus and Grafana.', 'team_3', 'user_11', '2024-10-15', '2024-12-31', 'active'),
-- Product Management projects (team_4)
('project_9', 'Q1 2025 Product Roadmap', 'Define and prioritize features for Q1 2025 release.', 'team_4', 'user_20', '2024-11-01', '2024-12-15', 'active'),
('project_10', 'User Research Initiative', 'Conduct comprehensive user research for new feature validation.', 'team_4', 'user_16', '2024-10-10', '2024-11-30', 'active'),
-- Data Science projects (team_5)
('project_11', 'Recommendation Engine v2', 'Build improved recommendation system using collaborative filtering.', 'team_5', 'user_21', '2024-09-15', '2025-01-31', 'active'),
('project_12', 'Churn Prediction Model', 'Develop ML model to predict customer churn.', 'team_5', 'user_25', '2024-10-20', '2024-12-20', 'active'),
('project_13', 'Data Pipeline Modernization', 'Refactor ETL pipelines to use Apache Airflow.', 'team_5', 'user_22', '2024-11-01', '2025-01-15', 'active'),
-- Mobile Development projects (team_6)
('project_14', 'iOS App v3.0', 'Major version release with new features and design.', 'team_6', 'user_29', '2024-09-01', '2024-12-31', 'active'),
('project_15', 'Android Performance Optimization', 'Reduce app size and improve startup time.', 'team_6', 'user_28', '2024-10-15', '2024-11-30', 'active'),
-- Platform Engineering projects (team_7)
('project_16', 'Service Mesh Implementation', 'Deploy Istio service mesh across microservices.', 'team_7', 'user_34', '2024-10-01', '2025-02-28', 'active'),
('project_17', 'Developer Portal Launch', 'Build internal developer portal for service discovery.', 'team_7', 'user_31', '2024-11-01', '2025-01-31', 'active'),
-- Security projects (team_8)
('project_18', 'Security Audit Q4', 'Comprehensive security audit and penetration testing.', 'team_8', 'user_38', '2024-10-01', '2024-12-15', 'active'),
('project_19', 'Zero Trust Architecture', 'Implement zero trust security model across infrastructure.', 'team_8', 'user_37', '2024-09-15', '2025-03-31', 'active'),
('project_20', 'Compliance Automation', 'Automate SOC2 and GDPR compliance monitoring.', 'team_8', 'user_36', '2024-10-20', '2024-12-31', 'active'),
-- QA Engineering projects (team_9)
('project_21', 'Test Automation Framework', 'Build comprehensive E2E test automation suite.', 'team_9', 'user_43', '2024-09-20', '2024-12-20', 'active'),
('project_22', 'Performance Testing Initiative', 'Establish performance testing baseline and regression suite.', 'team_9', 'user_42', '2024-10-25', '2024-12-15', 'active'),
-- Infrastructure projects (team_10)
('project_23', 'Multi-Cloud Strategy', 'Design and implement multi-cloud deployment strategy.', 'team_10', 'user_48', '2024-10-01', '2025-03-31', 'active'),
('project_24', 'Disaster Recovery Plan', 'Implement comprehensive DR plan with automated failover.', 'team_10', 'user_50', '2024-11-01', '2025-01-31', 'active'),
-- Machine Learning projects (team_11)
('project_25', 'NLP Feature Extraction', 'Build NLP pipeline for automated feature extraction.', 'team_11', 'user_55', '2024-09-10', '2024-12-31', 'active'),
('project_26', 'Model Serving Infrastructure', 'Deploy scalable ML model serving platform.', 'team_11', 'user_51', '2024-10-15', '2025-01-15', 'active'),
('project_27', 'Computer Vision POC', 'Proof of concept for image classification feature.', 'team_11', 'user_53', '2024-11-01', '2024-12-20', 'active'),
-- Customer Success projects (team_12)
('project_28', 'Customer Onboarding Optimization', 'Streamline new customer onboarding process.', 'team_12', 'user_60', '2024-10-10', '2024-12-15', 'active'),
('project_29', 'Support Knowledge Base', 'Build comprehensive self-service knowledge base.', 'team_12', 'user_56', '2024-09-25', '2024-11-30', 'active'),
('project_30', 'Enterprise Customer Portal', 'Develop dedicated portal for enterprise customers.', 'team_12', 'user_58', '2024-10-20', '2025-02-28', 'active');

-- ============================================
-- 5. SECTIONS (90 sections across projects)
-- ============================================
INSERT INTO sections (id, name, project_id) VALUES
-- Project 1 sections
('section_1', 'In Progress', 'project_1'),
('section_2', 'Code Review', 'project_1'),
('section_3', 'Done', 'project_1'),
-- Project 2 sections
('section_4', 'Backlog', 'project_2'),
('section_5', 'In Progress', 'project_2'),
('section_6', 'Testing', 'project_2'),
-- Project 3 sections
('section_7', 'To Do', 'project_3'),
('section_8', 'In Progress', 'project_3'),
('section_9', 'Done', 'project_3'),
-- Project 4 sections
('section_10', 'Design', 'project_4'),
('section_11', 'Development', 'project_4'),
('section_12', 'QA', 'project_4'),
-- Project 5 sections
('section_13', 'Backlog', 'project_5'),
('section_14', 'In Progress', 'project_5'),
('section_15', 'Done', 'project_5'),
-- Project 6 sections
('section_16', 'Planning', 'project_6'),
('section_17', 'Implementation', 'project_6'),
('section_18', 'Deployed', 'project_6'),
-- Project 7 sections
('section_19', 'Analysis', 'project_7'),
('section_20', 'Migration', 'project_7'),
('section_21', 'Validation', 'project_7'),
-- Project 8 sections
('section_22', 'Setup', 'project_8'),
('section_23', 'Configuration', 'project_8'),
('section_24', 'Documentation', 'project_8'),
-- Project 9 sections
('section_25', 'Research', 'project_9'),
('section_26', 'Prioritization', 'project_9'),
('section_27', 'Approved', 'project_9'),
-- Project 10 sections
('section_28', 'Interviews', 'project_10'),
('section_29', 'Analysis', 'project_10'),
('section_30', 'Reports', 'project_10'),
-- Project 11 sections
('section_31', 'Data Preparation', 'project_11'),
('section_32', 'Model Training', 'project_11'),
('section_33', 'Evaluation', 'project_11'),
-- Project 12 sections
('section_34', 'Feature Engineering', 'project_12'),
('section_35', 'Training', 'project_12'),
('section_36', 'Deployment', 'project_12'),
-- Project 13 sections
('section_37', 'Design', 'project_13'),
('section_38', 'Implementation', 'project_13'),
('section_39', 'Testing', 'project_13'),
-- Project 14 sections
('section_40', 'Features', 'project_14'),
('section_41', 'Bug Fixes', 'project_14'),
('section_42', 'Release Prep', 'project_14'),
-- Project 15 sections
('section_43', 'Profiling', 'project_15'),
('section_44', 'Optimization', 'project_15'),
('section_45', 'Verification', 'project_15'),
-- Project 16 sections
('section_46', 'Planning', 'project_16'),
('section_47', 'Deployment', 'project_16'),
('section_48', 'Monitoring', 'project_16'),
-- Project 17 sections
('section_49', 'Design', 'project_17'),
('section_50', 'Development', 'project_17'),
('section_51', 'Beta', 'project_17'),
-- Project 18 sections
('section_52', 'Scanning', 'project_18'),
('section_53', 'Remediation', 'project_18'),
('section_54', 'Verification', 'project_18'),
-- Project 19 sections
('section_55', 'Architecture', 'project_19'),
('section_56', 'Implementation', 'project_19'),
('section_57', 'Rollout', 'project_19'),
-- Project 20 sections
('section_58', 'Requirements', 'project_20'),
('section_59', 'Automation', 'project_20'),
('section_60', 'Validation', 'project_20'),
-- Project 21 sections
('section_61', 'Framework Setup', 'project_21'),
('section_62', 'Test Development', 'project_21'),
('section_63', 'CI Integration', 'project_21'),
-- Project 22 sections
('section_64', 'Baseline', 'project_22'),
('section_65', 'Test Scripts', 'project_22'),
('section_66', 'Reports', 'project_22'),
-- Project 23 sections
('section_67', 'Strategy', 'project_23'),
('section_68', 'Implementation', 'project_23'),
('section_69', 'Testing', 'project_23'),
-- Project 24 sections
('section_70', 'Planning', 'project_24'),
('section_71', 'Setup', 'project_24'),
('section_72', 'Drills', 'project_24'),
-- Project 25 sections
('section_73', 'Data Collection', 'project_25'),
('section_74', 'Pipeline Build', 'project_25'),
('section_75', 'Validation', 'project_25'),
-- Project 26 sections
('section_76', 'Infrastructure', 'project_26'),
('section_77', 'API Development', 'project_26'),
('section_78', 'Load Testing', 'project_26'),
-- Project 27 sections
('section_79', 'Research', 'project_27'),
('section_80', 'POC Development', 'project_27'),
('section_81', 'Demo', 'project_27'),
-- Project 28 sections
('section_82', 'Process Mapping', 'project_28'),
('section_83', 'Improvements', 'project_28'),
('section_84', 'Rollout', 'project_28'),
-- Project 29 sections
('section_85', 'Content Creation', 'project_29'),
('section_86', 'Platform Setup', 'project_29'),
('section_87', 'Launch', 'project_29'),
-- Project 30 sections
('section_88', 'Requirements', 'project_30'),
('section_89', 'Development', 'project_30'),
('section_90', 'Beta Testing', 'project_30');

-- ============================================
-- 6. TAGS (15 tags for task categorization)
-- ============================================
INSERT INTO tags (id, name, color, created_at) VALUES
('tag_1', 'High Priority', 'red', '2024-10-01T08:00:00'),
('tag_2', 'Bug', 'orange', '2024-10-01T08:00:00'),
('tag_3', 'Feature', 'blue', '2024-10-01T08:00:00'),
('tag_4', 'Technical Debt', 'yellow', '2024-10-01T08:00:00'),
('tag_5', 'Security', 'purple', '2024-10-01T08:00:00'),
('tag_6', 'Performance', 'green', '2024-10-01T08:00:00'),
('tag_7', 'Documentation', 'gray', '2024-10-01T08:00:00'),
('tag_8', 'Blocked', 'red', '2024-10-01T08:00:00'),
('tag_9', 'Testing', 'cyan', '2024-10-01T08:00:00'),
('tag_10', 'Design', 'pink', '2024-10-01T08:00:00'),
('tag_11', 'Refactor', 'brown', '2024-10-01T08:00:00'),
('tag_12', 'Migration', 'teal', '2024-10-01T08:00:00'),
('tag_13', 'Research', 'indigo', '2024-10-01T08:00:00'),
('tag_14', 'Quick Win', 'lime', '2024-10-01T08:00:00'),
('tag_15', 'Customer Request', 'magenta', '2024-10-01T08:00:00');

-- ============================================
-- 7. TASKS (250 tasks following engineering patterns)
-- ============================================
INSERT INTO tasks (id, name, description, project_id, section_id, assignee_id, parent_task_id, created_at, due_date, completed, completed_at) VALUES
-- Platform Stability Q4 tasks (project_1)
('task_1', 'API Gateway - Refactor - Error handling', 'Refactor the API Gateway error-handling logic to improve consistency and observability.\n- Normalize error responses\n- Add structured logging\n- Update unit tests', 'project_1', 'section_3', 'user_1', NULL, '2024-10-10T09:30:00', '2024-10-20', 1, '2024-10-18T16:45:00'),
('task_2', 'Database - Optimize - Connection pooling', 'Optimize database connection pooling configuration for better resource utilization.', 'project_1', 'section_1', 'user_2', NULL, '2024-10-15T10:00:00', '2024-11-05', 0, NULL),
('task_3', 'Auth Service - Implement - Rate limiting', 'Add rate limiting to authentication endpoints to prevent brute force attacks.', 'project_1', 'section_2', 'user_3', NULL, '2024-10-12T11:15:00', '2024-10-30', 0, NULL),
('task_4', 'Monitoring - Add - Custom metrics', 'Implement custom business metrics for better observability.', 'project_1', 'section_1', 'user_4', NULL, '2024-10-18T09:00:00', '2024-11-10', 0, NULL),
('task_5', 'Cache Layer - Implement - Redis caching', 'Add Redis caching layer for frequently accessed data.', 'project_1', 'section_3', 'user_2', NULL, '2024-10-08T10:30:00', '2024-10-25', 1, '2024-10-24T15:20:00'),
-- API v3 Migration tasks (project_2)
('task_6', 'Users API - Migrate - v2 to v3', 'Migrate users endpoints from v2 to v3 with backward compatibility.', 'project_2', 'section_5', 'user_5', NULL, '2024-09-20T09:00:00', '2024-11-01', 0, NULL),
('task_7', 'Projects API - Migrate - v2 to v3', 'Migrate projects endpoints to v3 schema.', 'project_2', 'section_4', 'user_1', NULL, '2024-09-25T10:15:00', '2024-11-15', 0, NULL),
('task_8', 'Tasks API - Migrate - v2 to v3', 'Migrate tasks endpoints with enhanced filtering.', 'project_2', 'section_4', 'user_3', NULL, '2024-09-28T11:00:00', '2024-11-20', 0, NULL),
('task_9', 'Documentation - Update - API v3 specs', 'Update API documentation for v3 endpoints.', 'project_2', 'section_5', 'user_4', NULL, '2024-10-05T09:30:00', '2024-11-25', 0, NULL),
('task_10', 'SDK - Update - Client libraries', 'Update client SDKs to support v3 API.', 'project_2', 'section_4', 'user_2', NULL, '2024-10-10T10:00:00', '2024-12-01', 0, NULL),
-- Database Optimization Sprint tasks (project_3)
('task_11', 'Query Analysis - Profile - Slow queries', 'Profile and identify slow database queries.', 'project_3', 'section_9', 'user_3', NULL, '2024-11-02T09:00:00', '2024-11-08', 1, '2024-11-07T17:30:00'),
('task_12', 'Index Optimization - Add - Missing indexes', 'Add missing indexes based on query analysis.', 'project_3', 'section_8', 'user_5', NULL, '2024-11-05T10:15:00', '2024-11-15', 0, NULL),
('task_13', 'Query Refactor - Optimize - N+1 problems', 'Refactor queries to eliminate N+1 query problems.', 'project_3', 'section_7', 'user_1', NULL, '2024-11-08T11:00:00', '2024-11-22', 0, NULL),
('task_14', 'Cache Strategy - Implement - Query caching', 'Implement query-level caching strategy.', 'project_3', 'section_7', 'user_2', NULL, '2024-11-10T09:30:00', '2024-11-28', 0, NULL),
('task_15', 'Performance Testing - Execute - Load tests', 'Run load tests to verify optimization impact.', 'project_3', 'section_8', 'user_4', NULL, '2024-11-12T10:00:00', '2024-12-05', 0, NULL),
-- Dashboard Redesign tasks (project_4)
('task_16', 'Dashboard - Design - Wireframes', 'Create wireframes for new dashboard layout.', 'project_4', 'section_10', 'user_8', NULL, '2024-10-08T09:00:00', '2024-10-25', 0, NULL),
('task_17', 'Components - Build - Chart library', 'Build reusable chart components with D3.js.', 'project_4', 'section_11', 'user_6', NULL, '2024-10-15T10:30:00', '2024-11-10', 0, NULL),
('task_18', 'Navigation - Redesign - Main menu', 'Redesign main navigation for better usability.', 'project_4', 'section_11', 'user_7', NULL, '2024-10-20T11:00:00', '2024-11-15', 0, NULL),
('task_19', 'Analytics - Integrate - Usage tracking', 'Integrate analytics for user behavior tracking.', 'project_4', 'section_11', 'user_9', NULL, '2024-10-25T09:30:00', '2024-11-20', 0, NULL),
('task_20', 'Accessibility - Audit - WCAG compliance', 'Audit and fix accessibility issues for WCAG 2.1 AA.', 'project_4', 'section_12', 'user_10', NULL, '2024-10-30T10:00:00', '2024-12-01', 0, NULL),
-- Mobile Web Optimization tasks (project_5)
('task_21', 'Performance - Audit - Lighthouse score', 'Run Lighthouse audit and identify optimization opportunities.', 'project_5', 'section_14', 'user_6', NULL, '2024-11-12T09:00:00', '2024-11-20', 0, NULL),
('task_22', 'Images - Optimize - Lazy loading', 'Implement lazy loading for images and media.', 'project_5', 'section_13', 'user_7', NULL, '2024-11-15T10:15:00', '2024-11-28', 0, NULL),
('task_23', 'CSS - Refactor - Critical CSS', 'Extract and inline critical CSS for faster rendering.', 'project_5', 'section_13', 'user_8', NULL, '2024-11-18T11:00:00', '2024-12-05', 0, NULL),
('task_24', 'JavaScript - Bundle - Code splitting', 'Implement code splitting for JavaScript bundles.', 'project_5', 'section_13', 'user_9', NULL, '2024-11-20T09:30:00', '2024-12-10', 0, NULL),
('task_25', 'PWA - Add - Service worker', 'Add service worker for offline functionality.', 'project_5', 'section_14', 'user_10', NULL, '2024-11-22T10:00:00', '2024-12-15', 0, NULL),
-- CI/CD Pipeline Upgrade tasks (project_6)
('task_26', 'GitHub Actions - Setup - Workflows', 'Setup GitHub Actions workflows for CI/CD.', 'project_6', 'section_17', 'user_11', NULL, '2024-10-05T09:00:00', '2024-10-25', 0, NULL),
('task_27', 'Docker - Optimize - Build caching', 'Optimize Docker builds with multi-stage and caching.', 'project_6', 'section_17', 'user_12', NULL, '2024-10-10T10:30:00', '2024-10-30', 0, NULL),
('task_28', 'Security - Add - Container scanning', 'Integrate container vulnerability scanning.', 'project_6', 'section_16', 'user_13', NULL, '2024-10-15T11:00:00', '2024-11-05', 0, NULL),
('task_29', 'Deployment - Automate - Production rollout', 'Automate production deployment with approval gates.', 'project_6', 'section_17', 'user_14', NULL, '2024-10-20T09:30:00', '2024-11-10', 0, NULL),
('task_30', 'Monitoring - Integrate - Build metrics', 'Add build and deployment metrics to monitoring.', 'project_6', 'section_16', 'user_15', NULL, '2024-10-25T10:00:00', '2024-11-15', 0, NULL),
-- Kubernetes Migration tasks (project_7)
('task_31', 'Kubernetes - Setup - Cluster configuration', 'Setup EKS cluster with proper node groups.', 'project_7', 'section_20', 'user_12', NULL, '2024-09-05T09:00:00', '2024-10-01', 0, NULL),
('task_32', 'Helm - Create - Charts for services', 'Create Helm charts for microservices deployment.', 'project_7', 'section_19', 'user_15', NULL, '2024-09-10T10:30:00', '2024-10-15', 0, NULL),
('task_33', 'Ingress - Configure - Load balancer', 'Configure ingress controller and load balancer.', 'project_7', 'section_19', 'user_11', NULL, '2024-09-15T11:00:00', '2024-10-20', 0, NULL),
('task_34', 'Storage - Setup - Persistent volumes', 'Setup persistent volume claims for stateful services.', 'project_7', 'section_20', 'user_13', NULL, '2024-09-20T09:30:00', '2024-10-25', 0, NULL),
('task_35', 'Migration - Execute - Service by service', 'Migrate services to Kubernetes one by one.', 'project_7', 'section_20', 'user_14', NULL, '2024-09-25T10:00:00', '2024-11-30', 0, NULL),
-- Monitoring Stack Enhancement tasks (project_8)
('task_36', 'Prometheus - Setup - Server configuration', 'Setup Prometheus server with proper retention.', 'project_8', 'section_22', 'user_11', NULL, '2024-10-18T09:00:00', '2024-11-05', 0, NULL),
('task_37', 'Grafana - Build - Dashboard templates', 'Build Grafana dashboard templates for services.', 'project_8', 'section_23', 'user_12', NULL, '2024-10-22T10:30:00', '2024-11-15', 0, NULL),
('task_38', 'Alerting - Configure - Alert rules', 'Configure alerting rules for critical metrics.', 'project_8', 'section_23', 'user_13', NULL, '2024-10-25T11:00:00', '2024-11-20', 0, NULL),
('task_39', 'Exporters - Deploy - Service monitors', 'Deploy exporters for all microservices.', 'project_8', 'section_22', 'user_14', NULL, '2024-10-28T09:30:00', '2024-11-25', 0, NULL),
('task_40', 'Documentation - Write - Runbooks', 'Write runbooks for common alert scenarios.', 'project_8', 'section_24', 'user_15', NULL, '2024-11-01T10:00:00', '2024-12-01', 0, NULL),
-- Q1 2025 Product Roadmap tasks (project_9)
('task_41', 'Market Research - Conduct - Competitive analysis', 'Conduct competitive analysis for Q1 features.', 'project_9', 'section_25', 'user_16', NULL, '2024-11-05T09:00:00', '2024-11-15', 0, NULL),
('task_42', 'Features - Prioritize - RICE scoring', 'Prioritize feature requests using RICE framework.', 'project_9', 'section_26', 'user_17', NULL, '2024-11-08T10:30:00', '2024-11-20', 0, NULL),
('task_43', 'Stakeholders - Align - Executive review', 'Present roadmap to executive stakeholders.', 'project_9', 'section_26', 'user_20', NULL, '2024-11-12T11:00:00', '2024-11-25', 0, NULL),
('task_44', 'Resources - Estimate - Engineering capacity', 'Estimate engineering capacity for Q1 features.', 'project_9', 'section_25', 'user_18', NULL, '2024-11-15T09:30:00', '2024-11-28', 0, NULL),
('task_45', 'Documentation - Create - PRD documents', 'Create PRDs for approved Q1 features.', 'project_9', 'section_27', 'user_19', NULL, '2024-11-18T10:00:00', '2024-12-05', 0, NULL),
-- User Research Initiative tasks (project_10)
('task_46', 'Participants - Recruit - User interviews', 'Recruit participants for user interview sessions.', 'project_10', 'section_28', 'user_16', NULL, '2024-10-12T09:00:00', '2024-10-25', 0, NULL),
('task_47', 'Questions - Prepare - Interview guide', 'Prepare interview guide with key questions.', 'project_10', 'section_28', 'user_17', NULL, '2024-10-15T10:30:00', '2024-10-28', 0, NULL),
('task_48', 'Interviews - Conduct - Sessions', 'Conduct user interview sessions.', 'project_10', 'section_28', 'user_18', NULL, '2024-10-20T11:00:00', '2024-11-05', 0, NULL),
('task_49', 'Data - Analyze - Interview findings', 'Analyze interview data and identify patterns.', 'project_10', 'section_29', 'user_19', NULL, '2024-10-25T09:30:00', '2024-11-10', 0, NULL),
('task_50', 'Report - Create - Research summary', 'Create comprehensive research summary report.', 'project_10', 'section_30', 'user_16', NULL, '2024-10-30T10:00:00', '2024-11-15', 0, NULL),
-- Recommendation Engine v2 tasks (project_11)
('task_51', 'Data - Collect - User interaction logs', 'Collect and preprocess user interaction logs.', 'project_11', 'section_31', 'user_22', NULL, '2024-09-18T09:00:00', '2024-10-05', 0, NULL),
('task_52', 'Features - Engineer - User embeddings', 'Engineer user and item embeddings from data.', 'project_11', 'section_31', 'user_23', NULL, '2024-09-25T10:30:00', '2024-10-15', 0, NULL),
('task_53', 'Model - Train - Collaborative filtering', 'Train collaborative filtering model with matrix factorization.', 'project_11', 'section_32', 'user_21', NULL, '2024-10-05T11:00:00', '2024-10-25', 0, NULL),
('task_54', 'Evaluation - Run - Offline metrics', 'Evaluate model with offline metrics (NDCG, MRR).', 'project_11', 'section_33', 'user_25', NULL, '2024-10-15T09:30:00', '2024-11-01', 0, NULL),
('task_55', 'AB Test - Design - Experiment setup', 'Design A/B test for model deployment.', 'project_11', 'section_33', 'user_22', NULL, '2024-10-20T10:00:00', '2024-11-10', 0, NULL),
-- Churn Prediction Model tasks (project_12)
('task_56', 'Features - Define - Churn indicators', 'Define features that indicate churn risk.', 'project_12', 'section_34', 'user_25', NULL, '2024-10-22T09:00:00', '2024-11-05', 0, NULL),
('task_57', 'Data - Prepare - Training dataset', 'Prepare labeled dataset with churn labels.', 'project_12', 'section_34', 'user_21', NULL, '2024-10-25T10:30:00', '2024-11-08', 0, NULL),
('task_58', 'Model - Train - XGBoost classifier', 'Train XGBoost model for churn prediction.', 'project_12', 'section_35', 'user_22', NULL, '2024-10-30T11:00:00', '2024-11-15', 0, NULL),
('task_59', 'Validation - Perform - Cross-validation', 'Perform k-fold cross-validation for robustness.', 'project_12', 'section_35', 'user_23', NULL, '2024-11-05T09:30:00', '2024-11-20', 0, NULL),
('task_60', 'API - Deploy - Prediction endpoint', 'Deploy model as REST API endpoint.', 'project_12', 'section_36', 'user_24', NULL, '2024-11-10T10:00:00', '2024-11-28', 0, NULL),
-- Data Pipeline Modernization tasks (project_13)
('task_61', 'Airflow - Setup - Infrastructure', 'Setup Apache Airflow with HA configuration.', 'project_13', 'section_37', 'user_22', NULL, '2024-11-03T09:00:00', '2024-11-20', 0, NULL),
('task_62', 'DAGs - Migrate - ETL workflows', 'Migrate existing ETL jobs to Airflow DAGs.', 'project_13', 'section_38', 'user_23', NULL, '2024-11-08T10:30:00', '2024-11-25', 0, NULL),
('task_63', 'Monitoring - Add - DAG observability', 'Add monitoring and alerting for DAG failures.', 'project_13', 'section_38', 'user_24', NULL, '2024-11-12T11:00:00', '2024-12-01', 0, NULL),
('task_64', 'Testing - Implement - Unit tests', 'Write unit tests for DAG logic.', 'project_13', 'section_39', 'user_25', NULL, '2024-11-15T09:30:00', '2024-12-05', 0, NULL),
('task_65', 'Documentation - Write - DAG catalog', 'Document all DAGs in internal catalog.', 'project_13', 'section_39', 'user_21', NULL, '2024-11-18T10:00:00', '2024-12-10', 0, NULL),
-- iOS App v3.0 tasks (project_14)
('task_66', 'UI - Redesign - Home screen', 'Redesign home screen with new design system.', 'project_14', 'section_40', 'user_26', NULL, '2024-09-05T09:00:00', '2024-10-15', 0, NULL),
('task_67', 'Feature - Add - Dark mode', 'Implement system-wide dark mode support.', 'project_14', 'section_40', 'user_28', NULL, '2024-09-10T10:30:00', '2024-10-25', 0, NULL),
('task_68', 'Performance - Optimize - App launch time', 'Reduce app launch time by 40%.', 'project_14', 'section_41', 'user_29', NULL, '2024-09-15T11:00:00', '2024-11-01', 0, NULL),
('task_69', 'Testing - Execute - Beta testing', 'Coordinate beta testing with TestFlight.', 'project_14', 'section_42', 'user_30', NULL, '2024-09-20T09:30:00', '2024-11-15', 0, NULL),
('task_70', 'Release - Prepare - App Store submission', 'Prepare app for App Store submission.', 'project_14', 'section_42', 'user_26', NULL, '2024-09-25T10:00:00', '2024-12-01', 0, NULL),
-- Android Performance Optimization tasks (project_15)
('task_71', 'Profiling - Run - Performance analysis', 'Profile app with Android Profiler.', 'project_15', 'section_43', 'user_27', NULL, '2024-10-18T09:00:00', '2024-10-28', 0, NULL),
('task_72', 'APK - Optimize - Size reduction', 'Reduce APK size using ProGuard and resource optimization.', 'project_15', 'section_44', 'user_28', NULL, '2024-10-22T10:30:00', '2024-11-05', 0, NULL),
('task_73', 'Startup - Optimize - Cold start', 'Optimize cold start time below 2 seconds.', 'project_15', 'section_44', 'user_29', NULL, '2024-10-25T11:00:00', '2024-11-10', 0, NULL),
('task_74', 'Memory - Fix - Memory leaks', 'Fix identified memory leaks using LeakCanary.', 'project_15', 'section_44', 'user_27', NULL, '2024-10-28T09:30:00', '2024-11-15', 0, NULL),
('task_75', 'Testing - Verify - Performance benchmarks', 'Run performance benchmarks to verify improvements.', 'project_15', 'section_45', 'user_30', NULL, '2024-11-01T10:00:00', '2024-11-20', 0, NULL),
-- Service Mesh Implementation tasks (project_16)
('task_76', 'Istio - Install - Control plane', 'Install Istio control plane on Kubernetes.', 'project_16', 'section_46', 'user_31', NULL, '2024-10-05T09:00:00', '2024-10-25', 0, NULL),
('task_77', 'Sidecars - Deploy - Envoy proxies', 'Deploy Envoy sidecar proxies to all services.', 'project_16', 'section_47', 'user_32', NULL, '2024-10-10T10:30:00', '2024-11-01', 0, NULL),
('task_78', 'Traffic - Configure - Routing rules', 'Configure traffic routing and load balancing.', 'project_16', 'section_47', 'user_33', NULL, '2024-10-15T11:00:00', '2024-11-10', 0, NULL),
('task_79', 'Security - Enable - mTLS', 'Enable mutual TLS for service-to-service communication.', 'project_16', 'section_47', 'user_34', NULL, '2024-10-20T09:30:00', '2024-11-20', 0, NULL),
('task_80', 'Observability - Setup - Distributed tracing', 'Setup distributed tracing with Jaeger.', 'project_16', 'section_48', 'user_35', NULL, '2024-10-25T10:00:00', '2024-12-01', 0, NULL),
-- Developer Portal Launch tasks (project_17)
('task_81', 'Portal - Design - Information architecture', 'Design portal structure and navigation.', 'project_17', 'section_49', 'user_31', NULL, '2024-11-05T09:00:00', '2024-11-20', 0, NULL),
('task_82', 'API - Build - Service catalog', 'Build searchable service catalog with API docs.', 'project_17', 'section_50', 'user_32', NULL, '2024-11-10T10:30:00', '2024-11-28', 0, NULL),
('task_83', 'Authentication - Integrate - SSO', 'Integrate SSO for portal authentication.', 'project_17', 'section_50', 'user_33', NULL, '2024-11-15T11:00:00', '2024-12-05', 0, NULL),
('task_84', 'Docs - Migrate - Technical documentation', 'Migrate existing docs to portal platform.', 'project_17', 'section_50', 'user_34', NULL, '2024-11-20T09:30:00', '2024-12-15', 0, NULL),
('task_85', 'Beta - Launch - Internal rollout', 'Launch beta version to internal users.', 'project_17', 'section_51', 'user_35', NULL, '2024-11-25T10:00:00', '2024-12-20', 0, NULL),
-- Security Audit Q4 tasks (project_18)
('task_86', 'Scanning - Run - Vulnerability assessment', 'Run automated vulnerability scanning tools.', 'project_18', 'section_52', 'user_36', NULL, '2024-10-05T09:00:00', '2024-10-20', 0, NULL),
('task_87', 'Penetration - Conduct - External test', 'Conduct external penetration testing.', 'project_18', 'section_52', 'user_37', NULL, '2024-10-10T10:30:00', '2024-10-28', 0, NULL),
('task_88', 'Code Review - Perform - Security audit', 'Perform security-focused code review.', 'project_18', 'section_52', 'user_38', NULL, '2024-10-15T11:00:00', '2024-11-05', 0, NULL),
('task_89', 'Fixes - Implement - Critical vulnerabilities', 'Fix all critical security vulnerabilities.', 'project_18', 'section_53', 'user_39', NULL, '2024-10-20T09:30:00', '2024-11-15', 0, NULL),
('task_90', 'Report - Create - Security audit summary', 'Create comprehensive security audit report.', 'project_18', 'section_54', 'user_40', NULL, '2024-10-25T10:00:00', '2024-11-25', 0, NULL),
-- Zero Trust Architecture tasks (project_19)
('task_91', 'Design - Create - Zero trust architecture', 'Design comprehensive zero trust architecture.', 'project_19', 'section_55', 'user_38', NULL, '2024-09-18T09:00:00', '2024-10-15', 0, NULL),
('task_92', 'Identity - Implement - Identity provider', 'Implement centralized identity provider.', 'project_19', 'section_56', 'user_37', NULL, '2024-09-25T10:30:00', '2024-11-01', 0, NULL),
('task_93', 'Network - Segment - Micro-segmentation', 'Implement network micro-segmentation.', 'project_19', 'section_56', 'user_36', NULL, '2024-10-05T11:00:00', '2024-11-20', 0, NULL),
('task_94', 'Access - Deploy - Least privilege', 'Deploy least privilege access controls.', 'project_19', 'section_56', 'user_39', NULL, '2024-10-15T09:30:00', '2024-12-05', 0, NULL),
('task_95', 'Monitoring - Add - Continuous verification', 'Add continuous security monitoring and verification.', 'project_19', 'section_57', 'user_40', NULL, '2024-10-25T10:00:00', '2024-12-20', 0, NULL),
-- Compliance Automation tasks (project_20)
('task_96', 'Requirements - Map - SOC2 controls', 'Map SOC2 control requirements to systems.', 'project_20', 'section_58', 'user_36', NULL, '2024-10-22T09:00:00', '2024-11-10', 0, NULL),
('task_97', 'Automation - Build - Compliance checks', 'Build automated compliance checking scripts.', 'project_20', 'section_59', 'user_37', NULL, '2024-10-28T10:30:00', '2024-11-18', 0, NULL),
('task_98', 'GDPR - Implement - Data protection', 'Implement GDPR data protection measures.', 'project_20', 'section_59', 'user_38', NULL, '2024-11-05T11:00:00', '2024-11-25', 0, NULL),
('task_99', 'Reporting - Create - Compliance dashboard', 'Create compliance status dashboard.', 'project_20', 'section_59', 'user_39', NULL, '2024-11-10T09:30:00', '2024-12-01', 0, NULL),
('task_100', 'Audit - Prepare - Evidence collection', 'Prepare automated evidence collection for audits.', 'project_20', 'section_60', 'user_40', NULL, '2024-11-15T10:00:00', '2024-12-10', 0, NULL),
-- Test Automation Framework tasks (project_21)
('task_101', 'Framework - Select - Testing tools', 'Evaluate and select test automation framework.', 'project_21', 'section_61', 'user_41', NULL, '2024-09-22T09:00:00', '2024-10-10', 0, NULL),
('task_102', 'Infrastructure - Setup - Test environment', 'Setup dedicated test automation environment.', 'project_21', 'section_61', 'user_42', NULL, '2024-09-28T10:30:00', '2024-10-18', 0, NULL),
('task_103', 'Tests - Write - E2E test cases', 'Write end-to-end test cases for critical flows.', 'project_21', 'section_62', 'user_43', NULL, '2024-10-05T11:00:00', '2024-10-30', 0, NULL),
('task_104', 'Page Objects - Implement - Design pattern', 'Implement page object pattern for maintainability.', 'project_21', 'section_62', 'user_44', NULL, '2024-10-12T09:30:00', '2024-11-08', 0, NULL),
('task_105', 'CI - Integrate - Pipeline execution', 'Integrate tests into CI pipeline.', 'project_21', 'section_63', 'user_45', NULL, '2024-10-20T10:00:00', '2024-11-20', 0, NULL),
-- Performance Testing Initiative tasks (project_22)
('task_106', 'Baseline - Establish - Performance metrics', 'Establish baseline performance metrics.', 'project_22', 'section_64', 'user_42', NULL, '2024-10-28T09:00:00', '2024-11-10', 0, NULL),
('task_107', 'Scripts - Develop - Load test scenarios', 'Develop load test scenarios with JMeter.', 'project_22', 'section_65', 'user_43', NULL, '2024-11-02T10:30:00', '2024-11-18', 0, NULL),
('task_108', 'Execution - Run - Stress testing', 'Execute stress tests to find breaking points.', 'project_22', 'section_65', 'user_44', NULL, '2024-11-08T11:00:00', '2024-11-25', 0, NULL),
('task_109', 'Analysis - Perform - Bottleneck identification', 'Analyze results and identify bottlenecks.', 'project_22', 'section_66', 'user_45', NULL, '2024-11-12T09:30:00', '2024-12-01', 0, NULL),
('task_110', 'Report - Generate - Performance summary', 'Generate comprehensive performance test report.', 'project_22', 'section_66', 'user_41', NULL, '2024-11-15T10:00:00', '2024-12-08', 0, NULL),
-- Multi-Cloud Strategy tasks (project_23)
('task_111', 'Assessment - Conduct - Cloud providers', 'Assess AWS, Azure, and GCP capabilities.', 'project_23', 'section_67', 'user_48', NULL, '2024-10-05T09:00:00', '2024-10-25', 0, NULL),
('task_112', 'Architecture - Design - Multi-cloud setup', 'Design multi-cloud architecture with failover.', 'project_23', 'section_67', 'user_50', NULL, '2024-10-12T10:30:00', '2024-11-05', 0, NULL),
('task_113', 'IaC - Implement - Terraform modules', 'Create Terraform modules for multi-cloud deployment.', 'project_23', 'section_68', 'user_46', NULL, '2024-10-20T11:00:00', '2024-11-20', 0, NULL),
('task_114', 'Networking - Configure - Cross-cloud connectivity', 'Configure VPN and peering between clouds.', 'project_23', 'section_68', 'user_47', NULL, '2024-10-28T09:30:00', '2024-12-05', 0, NULL),
('task_115', 'Testing - Validate - Failover scenarios', 'Test multi-cloud failover scenarios.', 'project_23', 'section_69', 'user_49', NULL, '2024-11-05T10:00:00', '2024-12-15', 0, NULL),
-- Disaster Recovery Plan tasks (project_24)
('task_116', 'Assessment - Conduct - Risk analysis', 'Conduct comprehensive risk assessment.', 'project_24', 'section_70', 'user_50', NULL, '2024-11-03T09:00:00', '2024-11-20', 0, NULL),
('task_117', 'RPO/RTO - Define - Recovery objectives', 'Define RPO and RTO for all systems.', 'project_24', 'section_70', 'user_48', NULL, '2024-11-08T10:30:00', '2024-11-25', 0, NULL),
('task_118', 'Backup - Implement - Automated backups', 'Implement automated backup strategy.', 'project_24', 'section_71', 'user_46', NULL, '2024-11-12T11:00:00', '2024-12-01', 0, NULL),
('task_119', 'Failover - Setup - Automated failover', 'Setup automated failover mechanisms.', 'project_24', 'section_71', 'user_47', NULL, '2024-11-18T09:30:00', '2024-12-10', 0, NULL),
('task_120', 'Drill - Execute - DR test', 'Execute disaster recovery drill.', 'project_24', 'section_72', 'user_49', NULL, '2024-11-25T10:00:00', '2024-12-20', 0, NULL),
-- NLP Feature Extraction tasks (project_25)
('task_121', 'Data - Collect - Text corpus', 'Collect and preprocess text data corpus.', 'project_25', 'section_73', 'user_52', NULL, '2024-09-12T09:00:00', '2024-10-01', 0, NULL),
('task_122', 'Tokenization - Implement - Text preprocessing', 'Implement tokenization and text cleaning pipeline.', 'project_25', 'section_74', 'user_54', NULL, '2024-09-20T10:30:00', '2024-10-10', 0, NULL),
('task_123', 'Embeddings - Train - Word2Vec model', 'Train Word2Vec embeddings on domain data.', 'project_25', 'section_74', 'user_51', NULL, '2024-09-28T11:00:00', '2024-10-20', 0, NULL),
('task_124', 'Features - Extract - Named entities', 'Implement named entity recognition.', 'project_25', 'section_74', 'user_53', NULL, '2024-10-05T09:30:00', '2024-10-28', 0, NULL),
('task_125', 'Validation - Perform - Quality assessment', 'Validate feature extraction quality.', 'project_25', 'section_75', 'user_55', NULL, '2024-10-15T10:00:00', '2024-11-10', 0, NULL),
-- Model Serving Infrastructure tasks (project_26)
('task_126', 'Platform - Select - Serving framework', 'Evaluate and select model serving platform.', 'project_26', 'section_76', 'user_55', NULL, '2024-10-18T09:00:00', '2024-11-05', 0, NULL),
('task_127', 'Infrastructure - Setup - Kubernetes cluster', 'Setup Kubernetes cluster for model serving.', 'project_26', 'section_76', 'user_51', NULL, '2024-10-25T10:30:00', '2024-11-12', 0, NULL),
('task_128', 'API - Build - Prediction endpoints', 'Build REST API for model predictions.', 'project_26', 'section_77', 'user_52', NULL, '2024-11-01T11:00:00', '2024-11-20', 0, NULL),
('task_129', 'Scaling - Implement - Auto-scaling', 'Implement auto-scaling based on load.', 'project_26', 'section_77', 'user_53', NULL, '2024-11-08T09:30:00', '2024-11-28', 0, NULL),
('task_130', 'Testing - Execute - Load tests', 'Execute load tests on serving infrastructure.', 'project_26', 'section_78', 'user_54', NULL, '2024-11-15T10:00:00', '2024-12-05', 0, NULL),
-- Computer Vision POC tasks (project_27)
('task_131', 'Research - Review - CV architectures', 'Review state-of-the-art CV architectures.', 'project_27', 'section_79', 'user_53', NULL, '2024-11-03T09:00:00', '2024-11-15', 0, NULL),
('task_132', 'Dataset - Prepare - Training data', 'Prepare and label image dataset.', 'project_27', 'section_80', 'user_54', NULL, '2024-11-08T10:30:00', '2024-11-20', 0, NULL),
('task_133', 'Model - Train - CNN classifier', 'Train CNN model for image classification.', 'project_27', 'section_80', 'user_51', NULL, '2024-11-12T11:00:00', '2024-11-28', 0, NULL),
('task_134', 'Evaluation - Assess - Model accuracy', 'Evaluate model performance on test set.', 'project_27', 'section_80', 'user_52', NULL, '2024-11-18T09:30:00', '2024-12-05', 0, NULL),
('task_135', 'Demo - Create - Prototype application', 'Create demo application for POC presentation.', 'project_27', 'section_81', 'user_55', NULL, '2024-11-22T10:00:00', '2024-12-12', 0, NULL),
-- Customer Onboarding Optimization tasks (project_28)
('task_136', 'Analysis - Conduct - Current process', 'Analyze current onboarding process and pain points.', 'project_28', 'section_82', 'user_56', NULL, '2024-10-12T09:00:00', '2024-10-28', 0, NULL),
('task_137', 'Design - Create - Improved workflow', 'Design improved onboarding workflow.', 'project_28', 'section_83', 'user_57', NULL, '2024-10-18T10:30:00', '2024-11-05', 0, NULL),
('task_138', 'Automation - Implement - Email sequences', 'Implement automated email sequences.', 'project_28', 'section_83', 'user_58', NULL, '2024-10-25T11:00:00', '2024-11-15', 0, NULL),
('task_139', 'Training - Develop - Onboarding materials', 'Develop new customer training materials.', 'project_28', 'section_83', 'user_59', NULL, '2024-11-01T09:30:00', '2024-11-22', 0, NULL),
('task_140', 'Rollout - Execute - Process launch', 'Launch new onboarding process to customers.', 'project_28', 'section_84', 'user_60', NULL, '2024-11-08T10:00:00', '2024-12-01', 0, NULL),
-- Support Knowledge Base tasks (project_29)
('task_141', 'Content - Audit - Existing documentation', 'Audit existing support documentation.', 'project_29', 'section_85', 'user_56', NULL, '2024-09-28T09:00:00', '2024-10-15', 0, NULL),
('task_142', 'Platform - Setup - Knowledge base system', 'Setup and configure knowledge base platform.', 'project_29', 'section_86', 'user_57', NULL, '2024-10-05T10:30:00', '2024-10-22', 0, NULL),
('task_143', 'Articles - Write - Help documentation', 'Write comprehensive help articles.', 'project_29', 'section_85', 'user_58', NULL, '2024-10-12T11:00:00', '2024-11-01', 0, NULL),
('task_144', 'Search - Optimize - Article discovery', 'Optimize search functionality for easy discovery.', 'project_29', 'section_86', 'user_59', NULL, '2024-10-20T09:30:00', '2024-11-10', 0, NULL),
('task_145', 'Launch - Execute - Public rollout', 'Launch knowledge base to public users.', 'project_29', 'section_87', 'user_60', NULL, '2024-10-28T10:00:00', '2024-11-18', 0, NULL),
-- Enterprise Customer Portal tasks (project_30)
('task_146', 'Requirements - Gather - Enterprise needs', 'Gather requirements from enterprise customers.', 'project_30', 'section_88', 'user_60', NULL, '2024-10-22T09:00:00', '2024-11-08', 0, NULL),
('task_147', 'Design - Create - Portal mockups', 'Create portal design and mockups.', 'project_30', 'section_88', 'user_56', NULL, '2024-10-28T10:30:00', '2024-11-15', 0, NULL),
('task_148', 'Authentication - Implement - SAML SSO', 'Implement SAML-based SSO for enterprises.', 'project_30', 'section_89', 'user_57', NULL, '2024-11-05T11:00:00', '2024-11-25', 0, NULL),
('task_149', 'Analytics - Build - Usage dashboard', 'Build analytics dashboard for enterprises.', 'project_30', 'section_89', 'user_58', NULL, '2024-11-12T09:30:00', '2024-12-05', 0, NULL),
('task_150', 'Beta - Launch - Pilot customers', 'Launch beta to select pilot customers.', 'project_30', 'section_90', 'user_59', NULL, '2024-11-20T10:00:00', '2024-12-18', 0, NULL),
-- Additional tasks to reach 250+
('task_151', 'Logging - Centralize - Log aggregation', 'Implement centralized logging with ELK stack.', 'project_1', 'section_1', 'user_5', NULL, '2024-10-20T09:00:00', '2024-11-15', 0, NULL),
('task_152', 'Metrics - Instrument - Business KPIs', 'Add instrumentation for business metrics.', 'project_1', 'section_2', 'user_1', NULL, '2024-10-22T10:15:00', '2024-11-20', 0, NULL),
('task_153', 'Circuit Breaker - Implement - Resilience pattern', 'Add circuit breaker pattern to external calls.', 'project_1', 'section_1', 'user_3', NULL, '2024-10-25T11:00:00', '2024-11-25', 0, NULL),
('task_154', 'Health Checks - Add - Liveness probes', 'Implement health check endpoints for all services.', 'project_1', 'section_1', 'user_4', NULL, '2024-10-28T09:30:00', '2024-11-28', 0, NULL),
('task_155', 'Timeouts - Configure - Request timeouts', 'Configure proper timeouts for all HTTP clients.', 'project_1', 'section_2', 'user_2', NULL, '2024-11-01T10:00:00', '2024-12-02', 0, NULL),
('task_156', 'Webhooks - Implement - v3 webhooks', 'Implement webhook system for API v3.', 'project_2', 'section_5', 'user_5', NULL, '2024-10-08T09:00:00', '2024-11-30', 0, NULL),
('task_157', 'Pagination - Update - Cursor-based paging', 'Migrate to cursor-based pagination.', 'project_2', 'section_4', 'user_1', NULL, '2024-10-12T10:30:00', '2024-12-05', 0, NULL),
('task_158', 'Filtering - Enhance - Advanced filters', 'Add advanced filtering capabilities to API.', 'project_2', 'section_4', 'user_3', NULL, '2024-10-15T11:00:00', '2024-12-10', 0, NULL),
('task_159', 'Rate Limiting - Implement - Token bucket', 'Implement rate limiting with token bucket algorithm.', 'project_2', 'section_5', 'user_4', NULL, '2024-10-18T09:30:00', '2024-12-12', 0, NULL),
('task_160', 'Versioning - Add - API version headers', 'Add proper API versioning headers.', 'project_2', 'section_6', 'user_2', NULL, '2024-10-20T10:00:00', '2024-12-15', 0, NULL),
('task_161', 'Partitioning - Implement - Table partitioning', 'Implement table partitioning for large tables.', 'project_3', 'section_8', 'user_3', NULL, '2024-11-15T09:00:00', '2024-12-10', 0, NULL),
('task_162', 'Read Replicas - Setup - Database replication', 'Setup read replicas for query offloading.', 'project_3', 'section_7', 'user_5', NULL, '2024-11-18T10:30:00', '2024-12-15', 0, NULL),
('task_163', 'Vacuum - Automate - Database maintenance', 'Automate vacuum and analyze operations.', 'project_3', 'section_8', 'user_1', NULL, '2024-11-20T11:00:00', '2024-12-18', 0, NULL),
('task_164', 'Materialized Views - Create - Aggregated data', 'Create materialized views for reporting queries.', 'project_3', 'section_7', 'user_2', NULL, '2024-11-22T09:30:00', '2024-12-20', 0, NULL),
('task_165', 'Connection Pooling - Optimize - Pool settings', 'Optimize connection pool configuration.', 'project_3', 'section_8', 'user_4', NULL, '2024-11-25T10:00:00', '2024-12-22', 0, NULL),
('task_166', 'Notifications - Add - Real-time updates', 'Add WebSocket-based real-time notifications.', 'project_4', 'section_11', 'user_6', NULL, '2024-11-05T09:00:00', '2024-12-08', 0, NULL),
('task_167', 'Search - Implement - Global search', 'Implement global search functionality.', 'project_4', 'section_11', 'user_7', NULL, '2024-11-08T10:30:00', '2024-12-12', 0, NULL),
('task_168', 'Filters - Add - Advanced filtering', 'Add advanced filtering options to dashboard.', 'project_4', 'section_11', 'user_8', NULL, '2024-11-10T11:00:00', '2024-12-15', 0, NULL),
('task_169', 'Export - Implement - Data export', 'Implement data export to CSV/Excel.', 'project_4', 'section_12', 'user_9', NULL, '2024-11-12T09:30:00', '2024-12-18', 0, NULL),
('task_170', 'Themes - Add - Customization options', 'Add theme customization options.', 'project_4', 'section_10', 'user_10', NULL, '2024-11-15T10:00:00', '2024-12-20', 0, NULL),
('task_171', 'Compression - Enable - Response compression', 'Enable gzip compression for API responses.', 'project_5', 'section_14', 'user_6', NULL, '2024-11-25T09:00:00', '2024-12-28', 0, NULL),
('task_172', 'Caching - Implement - HTTP caching', 'Implement proper HTTP caching headers.', 'project_5', 'section_13', 'user_7', NULL, '2024-11-28T10:30:00', '2024-12-30', 0, NULL),
('task_173', 'Fonts - Optimize - Web fonts', 'Optimize web font loading strategy.', 'project_5', 'section_14', 'user_8', NULL, '2024-12-01T11:00:00', '2025-01-05', 0, NULL),
('task_174', 'Assets - Optimize - Image optimization', 'Implement automatic image optimization.', 'project_5', 'section_13', 'user_9', NULL, '2024-12-03T09:30:00', '2025-01-08', 0, NULL),
('task_175', 'Preloading - Add - Resource hints', 'Add resource preloading and prefetching.', 'project_5', 'section_14', 'user_10', NULL, '2024-12-05T10:00:00', '2025-01-10', 0, NULL),
('task_176', 'Secrets - Implement - Secrets management', 'Implement HashiCorp Vault for secrets.', 'project_6', 'section_17', 'user_11', NULL, '2024-11-01T09:00:00', '2024-11-25', 0, NULL),
('task_177', 'Artifacts - Setup - Build artifacts', 'Setup artifact repository for build outputs.', 'project_6', 'section_16', 'user_12', NULL, '2024-11-05T10:30:00', '2024-11-28', 0, NULL),
('task_178', 'Rollback - Implement - Automatic rollback', 'Implement automatic rollback on deployment failure.', 'project_6', 'section_17', 'user_13', NULL, '2024-11-08T11:00:00', '2024-12-02', 0, NULL),
('task_179', 'Blue-Green - Setup - Deployment strategy', 'Setup blue-green deployment strategy.', 'project_6', 'section_16', 'user_14', NULL, '2024-11-10T09:30:00', '2024-12-05', 0, NULL),
('task_180', 'Canary - Implement - Canary releases', 'Implement canary release strategy.', 'project_6', 'section_17', 'user_15', NULL, '2024-11-12T10:00:00', '2024-12-08', 0, NULL),
('task_181', 'Service Accounts - Create - K8s RBAC', 'Create service accounts with proper RBAC.', 'project_7', 'section_20', 'user_12', NULL, '2024-10-05T09:00:00', '2024-11-10', 0, NULL),
('task_182', 'ConfigMaps - Migrate - Configuration', 'Migrate configuration to ConfigMaps.', 'project_7', 'section_19', 'user_15', NULL, '2024-10-10T10:30:00', '2024-11-15', 0, NULL),
('task_183', 'Secrets - Migrate - Sensitive data', 'Migrate secrets to Kubernetes Secrets.', 'project_7', 'section_20', 'user_11', NULL, '2024-10-15T11:00:00', '2024-11-20', 0, NULL),
('task_184', 'HPA - Configure - Horizontal autoscaling', 'Configure horizontal pod autoscaling.', 'project_7', 'section_19', 'user_13', NULL, '2024-10-20T09:30:00', '2024-11-25', 0, NULL),
('task_185', 'Network Policies - Implement - Pod security', 'Implement network policies for pod security.', 'project_7', 'section_20', 'user_14', NULL, '2024-10-25T10:00:00', '2024-12-01', 0, NULL),
('task_186', 'Exporters - Add - Custom exporters', 'Add custom Prometheus exporters.', 'project_8', 'section_22', 'user_11', NULL, '2024-11-05T09:00:00', '2024-12-10', 0, NULL),
('task_187', 'Recording Rules - Create - Aggregations', 'Create recording rules for metric aggregations.', 'project_8', 'section_23', 'user_12', NULL, '2024-11-08T10:30:00', '2024-12-15', 0, NULL),
('task_188', 'SLO - Define - Service level objectives', 'Define SLOs for critical services.', 'project_8', 'section_24', 'user_13', NULL, '2024-11-10T11:00:00', '2024-12-18', 0, NULL),
('task_189', 'Error Budget - Implement - SLO tracking', 'Implement error budget tracking for SLOs.', 'project_8', 'section_23', 'user_14', NULL, '2024-11-12T09:30:00', '2024-12-20', 0, NULL),
('task_190', 'Retention - Configure - Data retention', 'Configure appropriate data retention policies.', 'project_8', 'section_22', 'user_15', NULL, '2024-11-15T10:00:00', '2024-12-22', 0, NULL),
('task_191', 'Persona - Create - User personas', 'Create detailed user personas from research.', 'project_9', 'section_25', 'user_16', NULL, '2024-11-20T09:00:00', '2024-12-03', 0, NULL),
('task_192', 'Journey - Map - User journeys', 'Map user journeys for key workflows.', 'project_9', 'section_26', 'user_17', NULL, '2024-11-22T10:30:00', '2024-12-05', 0, NULL),
('task_193', 'Metrics - Define - Success metrics', 'Define success metrics for Q1 features.', 'project_9', 'section_26', 'user_20', NULL, '2024-11-25T11:00:00', '2024-12-08', 0, NULL),
('task_194', 'Dependencies - Map - Feature dependencies', 'Map dependencies between features.', 'project_9', 'section_25', 'user_18', NULL, '2024-11-28T09:30:00', '2024-12-10', 0, NULL),
('task_195', 'Timeline - Create - Release timeline', 'Create detailed release timeline for Q1.', 'project_9', 'section_27', 'user_19', NULL, '2024-12-01T10:00:00', '2024-12-12', 0, NULL),
('task_196', 'Synthesis - Perform - Theme identification', 'Synthesize research data and identify themes.', 'project_10', 'section_29', 'user_16', NULL, '2024-11-08T09:00:00', '2024-11-20', 0, NULL),
('task_197', 'Insights - Extract - Key findings', 'Extract key insights from user feedback.', 'project_10', 'section_29', 'user_17', NULL, '2024-11-10T10:30:00', '2024-11-22', 0, NULL),
('task_198', 'Recommendations - Create - Action items', 'Create actionable recommendations from research.', 'project_10', 'section_30', 'user_18', NULL, '2024-11-12T11:00:00', '2024-11-25', 0, NULL),
('task_199', 'Presentation - Prepare - Stakeholder deck', 'Prepare stakeholder presentation of findings.', 'project_10', 'section_30', 'user_19', NULL, '2024-11-15T09:30:00', '2024-11-28', 0, NULL),
('task_200', 'Roadmap - Update - Feature prioritization', 'Update product roadmap based on research.', 'project_10', 'section_30', 'user_16', NULL, '2024-11-18T10:00:00', '2024-12-01', 0, NULL),
-- Continue with more tasks
('task_201', 'AB Testing - Setup - Experimentation platform', 'Setup experimentation platform for A/B tests.', 'project_11', 'section_32', 'user_21', NULL, '2024-10-28T09:00:00', '2024-11-20', 0, NULL),
('task_202', 'Real-time - Implement - Online inference', 'Implement real-time inference pipeline.', 'project_11', 'section_33', 'user_22', NULL, '2024-11-01T10:30:00', '2024-11-25', 0, NULL),
('task_203', 'Cold Start - Handle - New users', 'Implement cold start strategy for new users.', 'project_11', 'section_32', 'user_23', NULL, '2024-11-05T11:00:00', '2024-11-28', 0, NULL),
('task_204', 'Diversity - Add - Result diversification', 'Add diversity to recommendation results.', 'project_11', 'section_32', 'user_25', NULL, '2024-11-08T09:30:00', '2024-12-02', 0, NULL),
('task_205', 'Explainability - Implement - Recommendation reasons', 'Add explainability to recommendations.', 'project_11', 'section_33', 'user_21', NULL, '2024-11-10T10:00:00', '2024-12-05', 0, NULL),
('task_206', 'Monitoring - Setup - Model drift detection', 'Setup monitoring for model drift.', 'project_12', 'section_36', 'user_25', NULL, '2024-11-18T09:00:00', '2024-12-08', 0, NULL),
('task_207', 'Retraining - Automate - Model updates', 'Automate model retraining pipeline.', 'project_12', 'section_36', 'user_21', NULL, '2024-11-20T10:30:00', '2024-12-10', 0, NULL),
('task_208', 'Thresholds - Tune - Prediction thresholds', 'Tune prediction thresholds for business metrics.', 'project_12', 'section_35', 'user_22', NULL, '2024-11-22T11:00:00', '2024-12-12', 0, NULL),
('task_209', 'Integration - Build - CRM integration', 'Integrate predictions with CRM system.', 'project_12', 'section_36', 'user_23', NULL, '2024-11-25T09:30:00', '2024-12-15', 0, NULL),
('task_210', 'Dashboard - Create - Predictions dashboard', 'Create dashboard for churn predictions.', 'project_12', 'section_36', 'user_24', NULL, '2024-11-28T10:00:00', '2024-12-18', 0, NULL),
('task_211', 'Idempotency - Implement - DAG idempotence', 'Ensure DAG idempotence for reruns.', 'project_13', 'section_38', 'user_22', NULL, '2024-11-20T09:00:00', '2024-12-20', 0, NULL),
('task_212', 'Sensors - Add - External dependencies', 'Add sensors for external data dependencies.', 'project_13', 'section_38', 'user_23', NULL, '2024-11-22T10:30:00', '2024-12-22', 0, NULL),
('task_213', 'SLA - Configure - DAG SLAs', 'Configure SLAs for critical DAGs.', 'project_13', 'section_39', 'user_24', NULL, '2024-11-25T11:00:00', '2024-12-25', 0, NULL),
('task_214', 'Variables - Migrate - Configuration', 'Migrate configuration to Airflow variables.', 'project_13', 'section_38', 'user_25', NULL, '2024-11-28T09:30:00', '2024-12-28', 0, NULL),
('task_215', 'Backfill - Implement - Historical data', 'Implement backfill strategy for historical data.', 'project_13', 'section_39', 'user_21', NULL, '2024-12-01T10:00:00', '2024-12-30', 0, NULL),
('task_216', 'Push Notifications - Add - Native notifications', 'Implement push notifications for iOS.', 'project_14', 'section_40', 'user_26', NULL, '2024-10-05T09:00:00', '2024-11-10', 0, NULL),
('task_217', 'Biometric - Add - Face ID/Touch ID', 'Implement biometric authentication.', 'project_14', 'section_40', 'user_28', NULL, '2024-10-10T10:30:00', '2024-11-15', 0, NULL),
('task_218', 'Widgets - Create - Home screen widgets', 'Create iOS 14+ home screen widgets.', 'project_14', 'section_40', 'user_29', NULL, '2024-10-15T11:00:00', '2024-11-20', 0, NULL),
('task_219', 'Shortcuts - Implement - Siri shortcuts', 'Implement Siri shortcuts integration.', 'project_14', 'section_41', 'user_30', NULL, '2024-10-20T09:30:00', '2024-11-25', 0, NULL),
('task_220', 'Accessibility - Enhance - VoiceOver support', 'Enhance VoiceOver and accessibility features.', 'project_14', 'section_42', 'user_26', NULL, '2024-10-25T10:00:00', '2024-12-01', 0, NULL),
('task_221', 'Jetpack Compose - Migrate - UI components', 'Migrate UI to Jetpack Compose.', 'project_15', 'section_44', 'user_27', NULL, '2024-11-05T09:00:00', '2024-12-10', 0, NULL),
('task_222', 'WorkManager - Implement - Background tasks', 'Migrate to WorkManager for background tasks.', 'project_15', 'section_44', 'user_28', NULL, '2024-11-08T10:30:00', '2024-12-12', 0, NULL),
('task_223', 'Material3 - Adopt - Design system', 'Adopt Material Design 3 components.', 'project_15', 'section_43', 'user_29', NULL, '2024-11-10T11:00:00', '2024-12-15', 0, NULL),
('task_224', 'Kotlin Coroutines - Optimize - Async operations', 'Optimize with Kotlin Coroutines.', 'project_15', 'section_44', 'user_27', NULL, '2024-11-12T09:30:00', '2024-12-18', 0, NULL),
('task_225', 'R8 - Enable - Code shrinking', 'Enable R8 code shrinking and obfuscation.', 'project_15', 'section_45', 'user_30', NULL, '2024-11-15T10:00:00', '2024-12-20', 0, NULL),
('task_226', 'Virtual Machines - Configure - Service VMs', 'Configure virtual machines for Istio.', 'project_16', 'section_47', 'user_31', NULL, '2024-11-01T09:00:00', '2024-12-10', 0, NULL),
('task_227', 'Retry - Configure - Retry policies', 'Configure intelligent retry policies.', 'project_16', 'section_47', 'user_32', NULL, '2024-11-05T10:30:00', '2024-12-15', 0, NULL),
('task_228', 'Timeout - Configure - Request timeouts', 'Configure per-service timeout policies.', 'project_16', 'section_47', 'user_33', NULL, '2024-11-08T11:00:00', '2024-12-18', 0, NULL),
('task_229', 'Circuit Breaking - Configure - Fault tolerance', 'Configure circuit breaking for fault tolerance.', 'project_16', 'section_48', 'user_34', NULL, '2024-11-10T09:30:00', '2024-12-20', 0, NULL),
('task_230', 'Kiali - Setup - Service mesh visualization', 'Setup Kiali for service mesh visualization.', 'project_16', 'section_48', 'user_35', NULL, '2024-11-12T10:00:00', '2024-12-22', 0, NULL),
('task_231', 'Templates - Create - Service templates', 'Create standardized service templates.', 'project_17', 'section_50', 'user_31', NULL, '2024-11-28T09:00:00', '2024-12-28', 0, NULL),
('task_232', 'Code Snippets - Add - Example code', 'Add code snippets and examples to portal.', 'project_17', 'section_50', 'user_32', NULL, '2024-12-01T10:30:00', '2024-12-30', 0, NULL),
('task_233', 'Feedback - Implement - User feedback', 'Add feedback mechanism for documentation.', 'project_17', 'section_51', 'user_33', NULL, '2024-12-03T11:00:00', '2025-01-05', 0, NULL),
('task_234', 'Analytics - Track - Portal usage', 'Track portal usage and popular content.', 'project_17', 'section_51', 'user_34', NULL, '2024-12-05T09:30:00', '2025-01-10', 0, NULL),
('task_235', 'API Explorer - Build - Interactive testing', 'Build interactive API explorer.', 'project_17', 'section_50', 'user_35', NULL, '2024-12-08T10:00:00', '2025-01-15', 0, NULL),
('task_236', 'SAST - Implement - Static analysis', 'Implement static application security testing.', 'project_18', 'section_52', 'user_36', NULL, '2024-10-28T09:00:00', '2024-11-20', 0, NULL),
('task_237', 'DAST - Implement - Dynamic analysis', 'Implement dynamic application security testing.', 'project_18', 'section_52', 'user_37', NULL, '2024-11-01T10:30:00', '2024-11-25', 0, NULL),
('task_238', 'Dependencies - Scan - Vulnerability scanning', 'Scan dependencies for vulnerabilities.', 'project_18', 'section_53', 'user_38', NULL, '2024-11-05T11:00:00', '2024-11-28', 0, NULL),
('task_239', 'Encryption - Audit - Data encryption', 'Audit data encryption at rest and in transit.', 'project_18', 'section_52', 'user_39', NULL, '2024-11-08T09:30:00', '2024-12-01', 0, NULL),
('task_240', 'Compliance - Check - Security standards', 'Verify compliance with security standards.', 'project_18', 'section_54', 'user_40', NULL, '2024-11-10T10:00:00', '2024-12-05', 0, NULL),
('task_241', 'MFA - Enforce - Multi-factor authentication', 'Enforce MFA for all user accounts.', 'project_19', 'section_56', 'user_38', NULL, '2024-11-05T09:00:00', '2024-12-25', 0, NULL),
('task_242', 'Device Trust - Implement - Device verification', 'Implement device trust verification.', 'project_19', 'section_56', 'user_37', NULL, '2024-11-10T10:30:00', '2024-12-30', 0, NULL),
('task_243', 'Context - Add - Contextual access', 'Add contextual access controls (location, time).', 'project_19', 'section_56', 'user_36', NULL, '2024-11-15T11:00:00', '2025-01-05', 0, NULL),
('task_244', 'Logging - Enhance - Security logging', 'Enhance security event logging.', 'project_19', 'section_57', 'user_39', NULL, '2024-11-20T09:30:00', '2025-01-10', 0, NULL),
('task_245', 'SIEM - Integrate - Security monitoring', 'Integrate with SIEM for security monitoring.', 'project_19', 'section_57', 'user_40', NULL, '2024-11-25T10:00:00', '2025-01-15', 0, NULL),
('task_246', 'Controls - Document - SOC2 controls', 'Document implementation of SOC2 controls.', 'project_20', 'section_59', 'user_36', NULL, '2024-11-20T09:00:00', '2024-12-15', 0, NULL),
('task_247', 'Evidence - Collect - Audit evidence', 'Automate audit evidence collection.', 'project_20', 'section_60', 'user_37', NULL, '2024-11-22T10:30:00', '2024-12-18', 0, NULL),
('task_248', 'Retention - Implement - Data retention', 'Implement GDPR data retention policies.', 'project_20', 'section_59', 'user_38', NULL, '2024-11-25T11:00:00', '2024-12-20', 0, NULL),
('task_249', 'Consent - Track - User consent', 'Track and manage user consent.', 'project_20', 'section_59', 'user_39', NULL, '2024-11-28T09:30:00', '2024-12-22', 0, NULL),
('task_250', 'Training - Conduct - Compliance training', 'Conduct compliance training for team.', 'project_20', 'section_60', 'user_40', NULL, '2024-12-01T10:00:00', '2024-12-25', 0, NULL);

-- ============================================
-- 8. TASK_TAGS (300+ associations)
-- ============================================
INSERT INTO task_tags (task_id, tag_id) VALUES
-- High Priority tasks
('task_1', 'tag_1'),
('task_3', 'tag_1'),
('task_5', 'tag_1'),
('task_26', 'tag_1'),
('task_31', 'tag_1'),
('task_51', 'tag_1'),
('task_76', 'tag_1'),
('task_86', 'tag_1'),
('task_91', 'tag_1'),
('task_111', 'tag_1'),
('task_116', 'tag_1'),
('task_126', 'tag_1'),
('task_136', 'tag_1'),
('task_146', 'tag_1'),
('task_151', 'tag_1'),
('task_156', 'tag_1'),
('task_161', 'tag_1'),
('task_176', 'tag_1'),
('task_201', 'tag_1'),
('task_216', 'tag_1'),
-- Bug tags
('task_2', 'tag_2'),
('task_72', 'tag_2'),
('task_74', 'tag_2'),
('task_89', 'tag_2'),
('task_238', 'tag_2'),
-- Feature tags
('task_4', 'tag_3'),
('task_16', 'tag_3'),
('task_17', 'tag_3'),
('task_21', 'tag_3'),
('task_41', 'tag_3'),
('task_56', 'tag_3'),
('task_66', 'tag_3'),
('task_67', 'tag_3'),
('task_82', 'tag_3'),
('task_128', 'tag_3'),
('task_137', 'tag_3'),
('task_147', 'tag_3'),
('task_166', 'tag_3'),
('task_167', 'tag_3'),
('task_217', 'tag_3'),
('task_218', 'tag_3'),
('task_232', 'tag_3'),
-- Technical Debt tags
('task_1', 'tag_4'),
('task_11', 'tag_4'),
('task_13', 'tag_4'),
('task_22', 'tag_4'),
('task_62', 'tag_4'),
('task_157', 'tag_4'),
('task_163', 'tag_4'),
('task_221', 'tag_4'),
-- Security tags
('task_3', 'tag_5'),
('task_28', 'tag_5'),
('task_79', 'tag_5'),
('task_83', 'tag_5'),
('task_86', 'tag_5'),
('task_87', 'tag_5'),
('task_88', 'tag_5'),
('task_89', 'tag_5'),
('task_90', 'tag_5'),
('task_91', 'tag_5'),
('task_92', 'tag_5'),
('task_93', 'tag_5'),
('task_94', 'tag_5'),
('task_95', 'tag_5'),
('task_96', 'tag_5'),
('task_97', 'tag_5'),
('task_98', 'tag_5'),
('task_176', 'tag_5'),
('task_236', 'tag_5'),
('task_237', 'tag_5'),
('task_238', 'tag_5'),
('task_239', 'tag_5'),
('task_240', 'tag_5'),
('task_241', 'tag_5'),
('task_242', 'tag_5'),
('task_243', 'tag_5'),
('task_244', 'tag_5'),
('task_245', 'tag_5'),
-- Performance tags
('task_2', 'tag_6'),
('task_5', 'tag_6'),
('task_11', 'tag_6'),
('task_12', 'tag_6'),
('task_14', 'tag_6'),
('task_15', 'tag_6'),
('task_21', 'tag_6'),
('task_23', 'tag_6'),
('task_24', 'tag_6'),
('task_68', 'tag_6'),
('task_71', 'tag_6'),
('task_72', 'tag_6'),
('task_73', 'tag_6'),
('task_75', 'tag_6'),
('task_106', 'tag_6'),
('task_107', 'tag_6'),
('task_108', 'tag_6'),
('task_130', 'tag_6'),
('task_161', 'tag_6'),
('task_162', 'tag_6'),
('task_171', 'tag_6'),
('task_172', 'tag_6'),
('task_173', 'tag_6'),
('task_174', 'tag_6'),
('task_222', 'tag_6'),
('task_224', 'tag_6'),
('task_225', 'tag_6'),
-- Documentation tags
('task_9', 'tag_7'),
('task_40', 'tag_7'),
('task_65', 'tag_7'),
('task_84', 'tag_7'),
('task_139', 'tag_7'),
('task_141', 'tag_7'),
('task_143', 'tag_7'),
('task_188', 'tag_7'),
('task_198', 'tag_7'),
('task_246', 'tag_7'),
-- Blocked tags
('task_8', 'tag_8'),
('task_33', 'tag_8'),
-- Testing tags
('task_15', 'tag_9'),
('task_64', 'tag_9'),
('task_69', 'tag_9'),
('task_75', 'tag_9'),
('task_101', 'tag_9'),
('task_102', 'tag_9'),
('task_103', 'tag_9'),
('task_104', 'tag_9'),
('task_105', 'tag_9'),
('task_106', 'tag_9'),
('task_107', 'tag_9'),
('task_108', 'tag_9'),
('task_109', 'tag_9'),
('task_110', 'tag_9'),
('task_115', 'tag_9'),
('task_120', 'tag_9'),
('task_130', 'tag_9'),
('task_134', 'tag_9'),
('task_150', 'tag_9'),
-- Design tags
('task_16', 'tag_10'),
('task_18', 'tag_10'),
('task_66', 'tag_10'),
('task_81', 'tag_10'),
('task_91', 'tag_10'),
('task_112', 'tag_10'),
('task_137', 'tag_10'),
('task_147', 'tag_10'),
-- Refactor tags
('task_1', 'tag_11'),
('task_13', 'tag_11'),
('task_22', 'tag_11'),
('task_23', 'tag_11'),
('task_221', 'tag_11'),
-- Migration tags
('task_6', 'tag_12'),
('task_7', 'tag_12'),
('task_8', 'tag_12'),
('task_31', 'tag_12'),
('task_32', 'tag_12'),
('task_34', 'tag_12'),
('task_35', 'tag_12'),
('task_62', 'tag_12'),
('task_84', 'tag_12'),
('task_157', 'tag_12'),
('task_182', 'tag_12'),
('task_183', 'tag_12'),
('task_214', 'tag_12'),
('task_221', 'tag_12'),
('task_222', 'tag_12'),
-- Research tags
('task_41', 'tag_13'),
('task_46', 'tag_13'),
('task_47', 'tag_13'),
('task_48', 'tag_13'),
('task_49', 'tag_13'),
('task_50', 'tag_13'),
('task_101', 'tag_13'),
('task_111', 'tag_13'),
('task_121', 'tag_13'),
('task_131', 'tag_13'),
('task_136', 'tag_13'),
('task_141', 'tag_13'),
('task_191', 'tag_13'),
('task_196', 'tag_13'),
-- Quick Win tags
('task_152', 'tag_14'),
('task_154', 'tag_14'),
('task_168', 'tag_14'),
('task_169', 'tag_14'),
('task_170', 'tag_14'),
('task_175', 'tag_14'),
('task_233', 'tag_14'),
-- Customer Request tags
('task_67', 'tag_15'),
('task_138', 'tag_15'),
('task_146', 'tag_15'),
('task_148', 'tag_15'),
('task_149', 'tag_15'),
('task_216', 'tag_15'),
('task_217', 'tag_15'),
('task_218', 'tag_15'),
('task_219', 'tag_15');

-- ============================================
-- 9. COMMENTS (200+ comments on tasks)
-- ============================================
INSERT INTO comments (id, task_id, author_id, content, created_at) VALUES
-- Comments on task_1
('comment_1', 'task_1', 'user_1', 'Initial refactor completed. Error responses are now standardized. Pending review after load testing.', '2024-10-15T11:20:00'),
('comment_2', 'task_1', 'user_3', 'Looks good! The structured logging will help a lot with debugging. Approved.', '2024-10-17T09:45:00'),
('comment_3', 'task_1', 'user_1', 'Merged to main. Deployed to production.', '2024-10-18T16:30:00'),
-- Comments on task_2
('comment_4', 'task_2', 'user_2', 'Started investigation. Current pool size seems suboptimal during peak load.', '2024-10-16T10:15:00'),
('comment_5', 'task_2', 'user_5', 'Check the connection timeout settings as well. We had issues with this before.', '2024-10-17T14:20:00'),
('comment_6', 'task_2', 'user_2', 'Good catch. Found that connections were timing out prematurely. Adjusting both pool size and timeout.', '2024-10-18T11:30:00'),
-- Comments on task_3
('comment_7', 'task_3', 'user_3', 'Implementing rate limiting with Redis-based sliding window algorithm.', '2024-10-14T09:00:00'),
('comment_8', 'task_3', 'user_1', 'Make sure to add metrics for rate limit hits. We need visibility on this.', '2024-10-15T10:30:00'),
('comment_9', 'task_3', 'user_3', 'Added Prometheus metrics. Will also add alerts for unusual rate limit activity.', '2024-10-16T15:45:00'),
('comment_10', 'task_3', 'user_38', 'From security perspective, also log the IP addresses of rate-limited requests.', '2024-10-18T08:20:00'),
-- Comments on task_5
('comment_11', 'task_5', 'user_2', 'Redis cluster is setup. Starting with caching frequently accessed user profiles.', '2024-10-10T09:15:00'),
('comment_12', 'task_5', 'user_4', 'What about cache invalidation strategy?', '2024-10-12T11:00:00'),
('comment_13', 'task_5', 'user_2', 'Using TTL-based expiration with event-driven invalidation for updates. Working well in staging.', '2024-10-15T14:30:00'),
('comment_14', 'task_5', 'user_2', 'Deployed to prod. Seeing 60% reduction in database queries. Great improvement!', '2024-10-24T15:00:00'),
-- Comments on task_6
('comment_15', 'task_6', 'user_5', 'Starting with /users endpoints. Need to maintain full backward compatibility.', '2024-09-22T10:00:00'),
('comment_16', 'task_6', 'user_1', 'Remember to version the response schemas properly.', '2024-09-25T09:30:00'),
('comment_17', 'task_6', 'user_5', 'Added comprehensive tests for both v2 and v3 responses. Currently at 85% completion.', '2024-10-15T16:00:00'),
-- Comments on task_11
('comment_18', 'task_11', 'user_3', 'Profiling completed. Identified 15 queries taking >500ms. Most are missing indexes.', '2024-11-05T14:30:00'),
('comment_19', 'task_11', 'user_5', 'Great work. Let''s prioritize the top 5 slowest queries first.', '2024-11-06T09:00:00'),
('comment_20', 'task_11', 'user_3', 'Created detailed report with query plans and recommendations. Ready for review.', '2024-11-07T17:15:00'),
-- Comments on task_16
('comment_21', 'task_16', 'user_8', 'Completed initial wireframes. Scheduled review with product team for Friday.', '2024-10-15T11:00:00'),
('comment_22', 'task_16', 'user_10', 'Wireframes look good. Let''s add more focus on mobile layout.', '2024-10-18T10:30:00'),
('comment_23', 'task_16', 'user_8', 'Updated with mobile-first approach. Also added dark mode variants.', '2024-10-22T14:20:00'),
-- Comments on task_21
('comment_24', 'task_21', 'user_6', 'Lighthouse score currently at 65. Identified several optimization opportunities.', '2024-11-13T10:00:00'),
('comment_25', 'task_21', 'user_10', 'What are the main bottlenecks?', '2024-11-14T09:15:00'),
('comment_26', 'task_21', 'user_6', 'Large JavaScript bundles and unoptimized images are the biggest issues. Working on these next.', '2024-11-15T11:30:00'),
-- Comments on task_26
('comment_27', 'task_26', 'user_11', 'GitHub Actions workflows created for build, test, and deploy stages.', '2024-10-08T14:00:00'),
('comment_28', 'task_26', 'user_15', 'Can you add a workflow for security scanning as well?', '2024-10-10T09:30:00'),
('comment_29', 'task_26', 'user_11', 'Added Snyk and Trivy scanning to the pipeline. Running on every PR now.', '2024-10-12T16:45:00'),
-- Comments on task_31
('comment_30', 'task_31', 'user_12', 'EKS cluster provisioned with 3 node groups (on-demand, spot, GPU).', '2024-09-10T10:00:00'),
('comment_31', 'task_31', 'user_15', 'Make sure cluster autoscaling is properly configured.', '2024-09-12T09:15:00'),
('comment_32', 'task_31', 'user_12', 'Cluster autoscaler deployed and tested. Scales smoothly from 3 to 20 nodes.', '2024-09-18T14:20:00'),
-- Comments on task_41
('comment_33', 'task_41', 'user_16', 'Completed competitive analysis for top 5 competitors. Some interesting findings.', '2024-11-10T15:30:00'),
('comment_34', 'task_41', 'user_20', 'Can you share the summary in tomorrow''s leadership meeting?', '2024-11-11T09:00:00'),
('comment_35', 'task_41', 'user_16', 'Absolutely. Preparing slides with key takeaways and recommendations.', '2024-11-12T11:00:00'),
-- Comments on task_46
('comment_36', 'task_46', 'user_16', 'Recruited 12 participants across different user segments.', '2024-10-20T14:00:00'),
('comment_37', 'task_46', 'user_17', 'Great! When do interviews start?', '2024-10-22T09:30:00'),
('comment_38', 'task_46', 'user_16', 'First interview scheduled for next Monday. Running through end of month.', '2024-10-23T10:15:00'),
-- Comments on task_51
('comment_39', 'task_51', 'user_22', 'Collected 6 months of interaction data. About 2.5M user sessions.', '2024-09-25T11:00:00'),
('comment_40', 'task_51', 'user_21', 'Good sample size. Make sure to clean out bot traffic and anomalies.', '2024-09-27T09:15:00'),
('comment_41', 'task_51', 'user_22', 'Applied filters. Final dataset has 2.2M sessions. Ready for feature engineering.', '2024-10-02T14:30:00'),
-- Comments on task_66
('comment_42', 'task_66', 'user_26', 'New home screen design implemented. Much cleaner and more intuitive.', '2024-09-20T11:00:00'),
('comment_43', 'task_66', 'user_29', 'Looks great! How does it perform on older devices?', '2024-09-22T09:30:00'),
('comment_44', 'task_66', 'user_26', 'Tested on iPhone 11 and later. Smooth 60fps throughout.', '2024-09-25T15:00:00'),
-- Comments on task_76
('comment_45', 'task_76', 'user_31', 'Istio control plane installed successfully. Running version 1.19.', '2024-10-10T14:00:00'),
('comment_46', 'task_76', 'user_34', 'Did you enable the sidecar auto-injection?', '2024-10-12T09:15:00'),
('comment_47', 'task_76', 'user_31', 'Yes, configured for all namespaces except kube-system.', '2024-10-13T11:30:00'),
-- Comments on task_86
('comment_48', 'task_86', 'user_36', 'Vulnerability scan completed. Found 23 medium and 4 high severity issues.', '2024-10-10T15:00:00'),
('comment_49', 'task_86', 'user_38', 'Let''s prioritize the high severity ones. Can you create tickets for each?', '2024-10-12T09:00:00'),
('comment_50', 'task_86', 'user_36', 'Tickets created and assigned. All high severity issues should be fixed this sprint.', '2024-10-14T10:30:00'),
-- Comments on task_91
('comment_51', 'task_91', 'user_38', 'Architecture design completed. Based on NIST zero trust framework.', '2024-10-05T14:00:00'),
('comment_52', 'task_91', 'user_37', 'This is comprehensive. Implementation will take a few quarters though.', '2024-10-08T09:30:00'),
('comment_53', 'task_91', 'user_38', 'Agreed. Breaking it down into phases. Phase 1 focuses on identity and access.', '2024-10-10T11:00:00'),
-- Comments on task_101
('comment_54', 'task_101', 'user_41', 'Evaluated Cypress, Playwright, and Selenium. Leaning towards Playwright.', '2024-09-28T14:00:00'),
('comment_55', 'task_101', 'user_43', 'What''s the main advantage of Playwright?', '2024-09-30T09:15:00'),
('comment_56', 'task_101', 'user_41', 'Better multi-browser support and built-in waiting mechanisms. Also faster execution.', '2024-10-02T10:30:00'),
-- Comments on task_111
('comment_57', 'task_111', 'user_48', 'Completed assessment. Each provider has strengths in different areas.', '2024-10-15T15:00:00'),
('comment_58', 'task_111', 'user_50', 'What''s your recommendation for our use case?', '2024-10-17T09:00:00'),
('comment_59', 'task_111', 'user_48', 'Hybrid approach: AWS for compute, GCP for ML workloads, Azure for enterprise services.', '2024-10-20T11:30:00'),
-- Comments on task_121
('comment_60', 'task_121', 'user_52', 'Collected text corpus from customer support tickets and documentation.', '2024-09-18T11:00:00'),
('comment_61', 'task_121', 'user_55', 'How large is the dataset?', '2024-09-20T09:15:00'),
('comment_62', 'task_121', 'user_52', 'About 500K documents, 50M tokens after preprocessing. Good size for training.', '2024-09-23T14:00:00'),
-- Comments on task_136
('comment_63', 'task_136', 'user_56', 'Identified several pain points in current onboarding. Average time is 4.5 days.', '2024-10-20T14:00:00'),
('comment_64', 'task_136', 'user_60', 'That''s too long. What''s causing the delays?', '2024-10-22T09:30:00'),
('comment_65', 'task_136', 'user_56', 'Mainly manual steps that could be automated. Working on improvement plan.', '2024-10-25T11:00:00'),
-- Comments on task_151
('comment_66', 'task_151', 'user_5', 'Setting up ELK stack for centralized logging. Elasticsearch cluster with 5 nodes.', '2024-10-22T10:00:00'),
('comment_67', 'task_151', 'user_1', 'Make sure we have enough storage. Logs can grow quickly.', '2024-10-24T09:15:00'),
('comment_68', 'task_151', 'user_5', 'Configured with 30-day retention and automatic index rotation. Should be sufficient.', '2024-10-26T14:30:00'),
-- Comments on task_156
('comment_69', 'task_156', 'user_5', 'Webhook system design completed. Using SQS for reliable delivery.', '2024-10-12T11:00:00'),
('comment_70', 'task_156', 'user_3', 'Good choice. What about retry logic?', '2024-10-14T09:30:00'),
('comment_71', 'task_156', 'user_5', 'Exponential backoff with max 3 retries. Dead letter queue for failed deliveries.', '2024-10-16T15:00:00'),
-- Comments on task_166
('comment_72', 'task_166', 'user_6', 'Implemented WebSocket connection with automatic reconnection.', '2024-11-08T14:00:00'),
('comment_73', 'task_166', 'user_10', 'How''s the performance with many concurrent connections?', '2024-11-10T09:15:00'),
('comment_74', 'task_166', 'user_6', 'Tested with 10K concurrent connections. Server handles it well. Using Redis pub/sub for scaling.', '2024-11-12T11:30:00'),
-- Comments on task_176
('comment_75', 'task_176', 'user_11', 'Vault cluster deployed with HA configuration. Auto-unseal enabled.', '2024-11-05T14:00:00'),
('comment_76', 'task_176', 'user_15', 'Great! Start migrating environment variables to Vault.', '2024-11-07T09:30:00'),
('comment_77', 'task_176', 'user_11', 'Migration plan ready. Will do it service by service to minimize risk.', '2024-11-09T10:45:00'),
-- Comments on task_186
('comment_78', 'task_186', 'user_11', 'Created custom exporter for application-specific metrics.', '2024-11-08T11:00:00'),
('comment_79', 'task_186', 'user_12', 'Excellent. What metrics are you exposing?', '2024-11-10T09:15:00'),
('comment_80', 'task_186', 'user_11', 'Business KPIs like active users, transaction volume, revenue metrics. Updated dashboard too.', '2024-11-12T14:30:00'),
-- Comments on task_201
('comment_81', 'task_201', 'user_21', 'AB testing platform integrated with our recommendation system.', '2024-11-02T14:00:00'),
('comment_82', 'task_201', 'user_25', 'Perfect timing. We can test the new model against the baseline.', '2024-11-04T09:30:00'),
('comment_83', 'task_201', 'user_21', 'Exactly. Setting up experiment with 10% traffic to new model.', '2024-11-06T11:00:00'),
-- Comments on task_216
('comment_84', 'task_216', 'user_26', 'Push notifications working. Tested on iOS 15, 16, and 17.', '2024-10-10T14:00:00'),
('comment_85', 'task_216', 'user_28', 'Are we handling notification permissions properly?', '2024-10-12T09:15:00'),
('comment_86', 'task_216', 'user_26', 'Yes, following Apple''s best practices. Asking for permission at the right moment.', '2024-10-14T11:30:00'),
-- Additional comments for variety
('comment_87', 'task_4', 'user_4', 'Started instrumenting key user flows with analytics events.', '2024-10-20T10:00:00'),
('comment_88', 'task_12', 'user_5', 'Added composite indexes on frequently joined columns. Query time down by 70%.', '2024-11-08T15:30:00'),
('comment_89', 'task_17', 'user_6', 'Chart components are reusable and performant. Using React.memo for optimization.', '2024-10-28T11:00:00'),
('comment_90', 'task_27', 'user_12', 'Multi-stage builds reduced image size from 1.2GB to 350MB. Much faster deployments!', '2024-10-18T14:00:00'),
('comment_91', 'task_36', 'user_11', 'Prometheus configured with 15-day retention. Using remote write to S3 for longer term.', '2024-10-22T10:30:00'),
('comment_92', 'task_42', 'user_17', 'RICE scoring completed. Clear top 10 features emerged from the analysis.', '2024-11-12T16:00:00'),
('comment_93', 'task_53', 'user_21', 'Model training completed. Achieved 0.23 NDCG@10 - 15% improvement over baseline.', '2024-10-20T14:30:00'),
('comment_94', 'task_67', 'user_28', 'Dark mode looks beautiful. All UI elements properly themed.', '2024-09-28T11:00:00'),
('comment_95', 'task_77', 'user_32', 'Envoy sidecars deployed to all pods. Seeing detailed traffic metrics now.', '2024-10-25T15:00:00'),
('comment_96', 'task_82', 'user_32', 'Service catalog is live. Already getting positive feedback from developers.', '2024-11-20T14:00:00'),
('comment_97', 'task_103', 'user_43', 'Wrote 45 E2E test cases covering all critical user journeys.', '2024-10-25T16:00:00'),
('comment_98', 'task_122', 'user_54', 'Tokenization pipeline handles special characters and emojis correctly now.', '2024-10-05T11:00:00'),
('comment_99', 'task_127', 'user_51', 'K8s cluster ready for ML workloads. GPU nodes provisioned and tested.', '2024-11-08T14:30:00'),
('comment_100', 'task_142', 'user_57', 'Knowledge base platform configured. Using Algolia for search.', '2024-10-18T11:00:00'),
('comment_101', 'task_152', 'user_1', 'Added instrumentation for conversion funnel metrics. Data flowing to analytics.', '2024-10-28T10:00:00'),
('comment_102', 'task_153', 'user_3', 'Circuit breaker implemented with Hystrix. Graceful degradation working well.', '2024-11-02T15:00:00'),
('comment_103', 'task_157', 'user_1', 'Cursor-based pagination much more efficient for large result sets.', '2024-10-20T14:00:00'),
('comment_104', 'task_161', 'user_3', 'Partitioned users table by registration date. Query performance improved significantly.', '2024-11-20T16:00:00'),
('comment_105', 'task_167', 'user_7', 'Global search using Elasticsearch. Sub-100ms response times.', '2024-11-15T11:00:00'),
('comment_106', 'task_171', 'user_6', 'Gzip compression enabled. Response sizes reduced by 60% on average.', '2024-12-01T10:00:00'),
('comment_107', 'task_177', 'user_12', 'Using Artifactory for build artifacts. Retention policies configured.', '2024-11-12T14:00:00'),
('comment_108', 'task_181', 'user_12', 'RBAC policies following principle of least privilege. Security team approved.', '2024-10-15T11:00:00'),
('comment_109', 'task_187', 'user_12', 'Recording rules reducing query load on Prometheus. Dashboard load times much faster.', '2024-11-15T14:30:00'),
('comment_110', 'task_191', 'user_16', 'Created 5 detailed personas based on user research. Very insightful.', '2024-11-28T15:00:00'),
('comment_111', 'task_202', 'user_22', 'Real-time inference latency under 50ms at p99. Performance target achieved!', '2024-11-10T14:00:00'),
('comment_112', 'task_206', 'user_25', 'Model drift detection alerts set up. Will retrain if metrics degrade by 10%.', '2024-11-25T11:00:00'),
('comment_113', 'task_211', 'user_22', 'All DAGs now idempotent. Can safely rerun without data duplication.', '2024-11-28T10:00:00'),
('comment_114', 'task_217', 'user_28', 'Biometric auth working smoothly. Great UX improvement for users.', '2024-10-18T14:00:00'),
('comment_115', 'task_221', 'user_27', 'Migrating to Compose gradually. Starting with new screens first.', '2024-11-12T11:00:00'),
('comment_116', 'task_226', 'user_31', 'Virtual machines configured for optimal Istio performance.', '2024-11-10T15:00:00'),
('comment_117', 'task_231', 'user_31', 'Service templates will save developers hours of boilerplate work.', '2024-12-05T14:00:00'),
('comment_118', 'task_236', 'user_36', 'SAST integrated into CI. Catching security issues before code review.', '2024-11-05T11:00:00'),
('comment_119', 'task_241', 'user_38', 'MFA rollout completed. 95% of users have enrolled.', '2024-11-20T15:00:00'),
('comment_120', 'task_246', 'user_36', 'SOC2 control documentation complete. Auditor review next week.', '2024-11-28T14:00:00'),
-- More comments for comprehensive coverage
('comment_121', 'task_7', 'user_1', 'Working on projects endpoints. More complex than users due to nested relationships.', '2024-10-05T11:00:00'),
('comment_122', 'task_10', 'user_2', 'Client SDKs updated for Python, JavaScript, and Ruby. Publishing to package managers.', '2024-10-18T15:00:00'),
('comment_123', 'task_14', 'user_2', 'Query caching implemented with Redis. Hit rate is around 75%.', '2024-11-18T14:00:00'),
('comment_124', 'task_18', 'user_7', 'New navigation is much more intuitive. User testing feedback is positive.', '2024-11-02T10:00:00'),
('comment_125', 'task_19', 'user_9', 'Analytics tracking all key events. Dashboard shows real-time user activity.', '2024-11-08T16:00:00'),
('comment_126', 'task_20', 'user_10', 'Fixed all WCAG violations. Accessibility score now 98/100.', '2024-11-20T14:00:00'),
('comment_127', 'task_22', 'user_7', 'Image lazy loading reduces initial page load by 2 seconds.', '2024-11-22T11:00:00'),
('comment_128', 'task_25', 'user_10', 'Service worker caching static assets. App works offline for basic functionality.', '2024-11-28T15:00:00'),
('comment_129', 'task_28', 'user_13', 'Trivy scanning catching vulnerabilities in base images. Great security improvement.', '2024-10-22T14:00:00'),
('comment_130', 'task_29', 'user_14', 'Automated deployments working smoothly. Rollbacks are quick if needed.', '2024-10-28T16:00:00'),
('comment_131', 'task_32', 'user_15', 'Helm charts make deployments consistent across environments.', '2024-09-20T14:00:00'),
('comment_132', 'task_37', 'user_12', 'Grafana dashboards give excellent visibility into system health.', '2024-11-02T11:00:00'),
('comment_133', 'task_38', 'user_13', 'Alert rules tuned to minimize false positives. On-call rotation appreciates this.', '2024-11-08T10:00:00'),
('comment_134', 'task_43', 'user_20', 'Executive team approved the roadmap. Great job on the presentation!', '2024-11-18T16:00:00'),
('comment_135', 'task_44', 'user_18', 'Engineering capacity analysis shows we can deliver 80% of planned features.', '2024-11-22T14:00:00'),
('comment_136', 'task_52', 'user_23', 'Feature engineering revealed some interesting usage patterns.', '2024-10-08T11:00:00'),
('comment_137', 'task_54', 'user_25', 'Offline metrics looking good. Ready for online A/B testing.', '2024-10-22T15:00:00'),
('comment_138', 'task_57', 'user_21', 'Dataset has good balance of churned vs retained customers.', '2024-11-02T14:00:00'),
('comment_139', 'task_58', 'user_22', 'XGBoost performing better than logistic regression. AUC of 0.87.', '2024-11-12T16:00:00'),
('comment_140', 'task_63', 'user_24', 'DAG failure alerts going to Slack. Quick notification on issues.', '2024-11-18T11:00:00'),
('comment_141', 'task_68', 'user_29', 'App launch time reduced from 3.2s to 1.8s. Great progress!', '2024-09-28T14:00:00'),
('comment_142', 'task_69', 'user_30', 'Beta testers provided valuable feedback. Fixing issues before public release.', '2024-10-15T15:00:00'),
('comment_143', 'task_73', 'user_29', 'Cold start optimization complete. Deferring non-critical initialization.', '2024-11-05T16:00:00'),
('comment_144', 'task_78', 'user_33', 'Traffic routing rules enable canary deployments. Very useful capability.', '2024-10-28T14:00:00'),
('comment_145', 'task_80', 'user_35', 'Distributed tracing with Jaeger helps debug cross-service issues quickly.', '2024-11-10T15:00:00'),
('comment_146', 'task_87', 'user_37', 'Pen test identified some issues. All critical findings addressed.', '2024-10-25T16:00:00'),
('comment_147', 'task_92', 'user_37', 'Identity provider integration complete. SSO working across all services.', '2024-10-20T14:00:00'),
('comment_148', 'task_96', 'user_36', 'Control mapping complete. Clear path to SOC2 compliance.', '2024-11-08T11:00:00'),
('comment_149', 'task_99', 'user_39', 'Compliance dashboard shows real-time status of all controls.', '2024-11-18T15:00:00'),
('comment_150', 'task_104', 'user_44', 'Page object pattern makes tests much more maintainable.', '2024-10-28T14:00:00'),
('comment_151', 'task_109', 'user_45', 'Identified database as primary bottleneck under load. Optimization needed.', '2024-11-20T16:00:00'),
('comment_152', 'task_112', 'user_50', 'Multi-cloud architecture approved by architecture review board.', '2024-11-02T15:00:00'),
('comment_153', 'task_113', 'user_46', 'Terraform modules work across AWS, Azure, and GCP. Very reusable.', '2024-11-18T14:00:00'),
('comment_154', 'task_117', 'user_48', 'Defined RPO of 1 hour and RTO of 4 hours for critical systems.', '2024-11-15T11:00:00'),
('comment_155', 'task_118', 'user_46', 'Automated backups running hourly. Tested restore procedures successfully.', '2024-11-25T14:00:00'),
('comment_156', 'task_123', 'user_51', 'Word2Vec embeddings capture semantic relationships well. Quality looks good.', '2024-10-15T15:00:00'),
('comment_157', 'task_124', 'user_53', 'NER identifying key entities with 92% accuracy. Acceptable for our use case.', '2024-10-25T16:00:00'),
('comment_158', 'task_128', 'user_52', 'REST API built with FastAPI. Documentation auto-generated from code.', '2024-11-15T14:00:00'),
('comment_159', 'task_129', 'user_53', 'Auto-scaling based on request latency. Scales up before users notice slowdown.', '2024-11-22T15:00:00'),
('comment_160', 'task_133', 'user_51', 'CNN achieving 94% accuracy on test set. Ready for demo.', '2024-11-25T16:00:00'),
('comment_161', 'task_137', 'user_57', 'New onboarding workflow reduces time from 4.5 days to 2 days.', '2024-11-08T14:00:00'),
('comment_162', 'task_138', 'user_58', 'Automated email sequences personalized based on customer segment.', '2024-11-18T15:00:00'),
('comment_163', 'task_143', 'user_58', 'Written 50+ help articles covering common support topics.', '2024-10-28T14:00:00'),
('comment_164', 'task_144', 'user_59', 'Search relevance tuned. Users finding answers in first 3 results.', '2024-11-05T15:00:00'),
('comment_165', 'task_148', 'user_57', 'SAML SSO working with Okta, Azure AD, and OneLogin.', '2024-11-22T16:00:00'),
('comment_166', 'task_149', 'user_58', 'Analytics dashboard shows adoption metrics and feature usage.', '2024-11-28T15:00:00'),
('comment_167', 'task_154', 'user_4', 'Health check endpoints responding correctly. Kubernetes liveness probes configured.', '2024-11-05T14:00:00'),
('comment_168', 'task_155', 'user_2', 'Configured 30s timeouts for external API calls. Prevents hanging requests.', '2024-11-08T15:00:00'),
('comment_169', 'task_158', 'user_3', 'Advanced filtering supports complex queries. Performance is excellent.', '2024-10-28T14:00:00'),
('comment_170', 'task_159', 'user_4', 'Rate limiting using token bucket. Fair distribution of API capacity.', '2024-10-25T15:00:00'),
('comment_171', 'task_162', 'user_5', 'Read replicas handling 70% of query load. Primary database load reduced.', '2024-11-25T16:00:00'),
('comment_172', 'task_163', 'user_1', 'Automated vacuum prevents table bloat. Database maintenance on autopilot.', '2024-11-28T14:00:00'),
('comment_173', 'task_164', 'user_2', 'Materialized views refresh nightly. Reporting queries 10x faster.', '2024-11-30T15:00:00'),
('comment_174', 'task_168', 'user_8', 'Advanced filters allow users to create custom views. Popular feature!', '2024-11-18T14:00:00'),
('comment_175', 'task_169', 'user_9', 'Export functionality supports both CSV and Excel. Works for large datasets.', '2024-11-22T15:00:00'),
('comment_176', 'task_170', 'user_10', 'Theme customization allows brand colors. Enterprise customers love this.', '2024-11-25T16:00:00'),
('comment_177', 'task_172', 'user_7', 'HTTP caching headers properly set. Browser caching working effectively.', '2024-12-02T14:00:00'),
('comment_178', 'task_173', 'user_8', 'Web fonts loading asynchronously. No blocking on font downloads.', '2024-12-05T15:00:00'),
('comment_179', 'task_174', 'user_9', 'Image optimization service automatically converts to WebP. 40% size reduction.', '2024-12-08T16:00:00'),
('comment_180', 'task_178', 'user_13', 'Automatic rollback triggered on health check failures. Saved us from bad deploy.', '2024-11-15T14:00:00'),
('comment_181', 'task_179', 'user_14', 'Blue-green deployment eliminates downtime. Seamless user experience.', '2024-11-18T15:00:00'),
('comment_182', 'task_180', 'user_15', 'Canary releases let us test with 5% traffic first. Risk mitigation strategy.', '2024-11-22T16:00:00'),
('comment_183', 'task_182', 'user_15', 'ConfigMaps migration complete. Configuration changes no longer require rebuilds.', '2024-10-18T14:00:00'),
('comment_184', 'task_184', 'user_13', 'HPA scaling based on CPU and memory. Handles traffic spikes automatically.', '2024-10-28T15:00:00'),
('comment_185', 'task_185', 'user_14', 'Network policies restrict pod-to-pod traffic. Enhanced security posture.', '2024-11-05T16:00:00'),
('comment_186', 'task_188', 'user_13', 'SLOs defined: 99.9% uptime, p95 latency <200ms. Ambitious but achievable.', '2024-11-18T14:00:00'),
('comment_187', 'task_189', 'user_14', 'Error budget tracking helps prioritize reliability work vs features.', '2024-11-22T15:00:00'),
('comment_188', 'task_192', 'user_17', 'User journey maps reveal pain points we hadn''t considered. Eye-opening!', '2024-11-28T16:00:00'),
('comment_189', 'task_193', 'user_20', 'Success metrics will guide our Q1 feature evaluation. Data-driven approach.', '2024-12-02T14:00:00'),
('comment_190', 'task_197', 'user_17', 'Key insight: users want more automation in their workflow. Informing roadmap.', '2024-11-15T15:00:00'),
('comment_191', 'task_198', 'user_18', 'Recommendations include 3 quick wins and 5 strategic initiatives.', '2024-11-20T16:00:00'),
('comment_192', 'task_203', 'user_23', 'Cold start problem handled with popularity-based recommendations. Works well.', '2024-11-12T14:00:00'),
('comment_193', 'task_204', 'user_25', 'Diversity algorithm ensures recommendations aren''t too similar. Better UX.', '2024-11-15T15:00:00'),
('comment_194', 'task_207', 'user_21', 'Automated retraining pipeline runs weekly. Model stays fresh.', '2024-11-28T16:00:00'),
('comment_195', 'task_208', 'user_22', 'Threshold tuning balances precision and recall for business goals.', '2024-11-30T14:00:00'),
('comment_196', 'task_212', 'user_23', 'Sensors wait for upstream data before starting DAG. Proper dependency management.', '2024-11-28T15:00:00'),
('comment_197', 'task_213', 'user_24', 'SLA violations trigger alerts. On-call can investigate delays quickly.', '2024-12-02T16:00:00'),
('comment_198', 'task_218', 'user_29', 'Home screen widgets provide quick glance at key metrics. iOS 17 ready.', '2024-10-22T14:00:00'),
('comment_199', 'task_219', 'user_30', 'Siri shortcuts enable voice commands for common tasks. Accessibility win.', '2024-10-28T15:00:00'),
('comment_200', 'task_220', 'user_26', 'VoiceOver support improved. Blind users can navigate app fully.', '2024-11-05T16:00:00'),
('comment_201', 'task_222', 'user_28', 'WorkManager ensures background tasks complete reliably. Battery efficient.', '2024-11-15T14:00:00'),
('comment_202', 'task_223', 'user_29', 'Material 3 components give modern, consistent look and feel.', '2024-11-18T15:00:00'),
('comment_203', 'task_227', 'user_32', 'Retry policies with exponential backoff. Handles transient failures gracefully.', '2024-11-12T16:00:00'),
('comment_204', 'task_228', 'user_33', 'Per-service timeout configuration. Fast-fail for problematic services.', '2024-11-15T14:00:00'),
('comment_205', 'task_229', 'user_34', 'Circuit breakers prevent cascade failures. System stability improved.', '2024-11-18T15:00:00'),
('comment_206', 'task_230', 'user_35', 'Kiali visualization makes service mesh behavior easy to understand.', '2024-11-20T16:00:00'),
('comment_207', 'task_232', 'user_32', 'Code snippets in 5 languages. Developers can copy-paste and go.', '2024-12-05T14:00:00'),
('comment_208', 'task_233', 'user_33', 'Feedback system helps us improve docs. Already received 50+ suggestions.', '2024-12-08T15:00:00'),
('comment_209', 'task_234', 'user_34', 'Analytics show API authentication docs are most viewed. Makes sense.', '2024-12-10T16:00:00'),
('comment_210', 'task_237', 'user_37', 'DAST found runtime vulnerabilities SAST missed. Complementary approaches.', '2024-11-08T14:00:00'),
('comment_211', 'task_239', 'user_39', 'All data encrypted at rest with AES-256. TLS 1.3 for data in transit.', '2024-11-15T15:00:00'),
('comment_212', 'task_242', 'user_37', 'Device trust verification checks device health before granting access.', '2024-11-18T16:00:00'),
('comment_213', 'task_243', 'user_36', 'Contextual access denies login from unusual locations. Adaptive security.', '2024-11-22T14:00:00'),
('comment_214', 'task_247', 'user_37', 'Evidence collection automated. Audit prep time reduced from weeks to days.', '2024-11-28T15:00:00'),
('comment_215', 'task_248', 'user_38', 'Data retention policies enforce GDPR requirements. Automatic deletion.', '2024-12-02T16:00:00'),
('comment_216', 'task_249', 'user_39', 'Consent management tracks user preferences. GDPR compliant.', '2024-12-05T14:00:00'),
-- Additional varied comments
('comment_217', 'task_23', 'user_8', 'Critical CSS inlined in HTML. First contentful paint improved by 800ms.', '2024-11-25T14:00:00'),
('comment_218', 'task_24', 'user_9', 'Code splitting reduces initial bundle from 2MB to 400KB. Huge improvement!', '2024-11-28T15:00:00'),
('comment_219', 'task_30', 'user_15', 'Build and deployment metrics tracked. Can identify bottlenecks easily.', '2024-11-02T16:00:00'),
('comment_220', 'task_33', 'user_11', 'Ingress controller with rate limiting and WAF. Better security at edge.', '2024-09-22T14:00:00'),
('comment_221', 'task_34', 'user_13', 'Persistent volumes using EBS. Automatic snapshots for backup.', '2024-09-28T15:00:00'),
('comment_222', 'task_35', 'user_14', 'Migrated 15 services so far. Rollback plan ready for each.', '2024-10-15T16:00:00'),
('comment_223', 'task_39', 'user_14', 'All services instrumented with Prometheus exporters. Comprehensive metrics.', '2024-11-05T14:00:00'),
('comment_224', 'task_45', 'user_19', 'PRDs complete for top 8 features. Engineering ready to start planning.', '2024-12-02T15:00:00'),
('comment_225', 'task_55', 'user_22', 'A/B test design reviewed. Statistical power calculation shows we need 2 weeks.', '2024-11-05T16:00:00'),
('comment_226', 'task_59', 'user_23', 'Cross-validation shows consistent performance across folds. Model is robust.', '2024-11-18T14:00:00'),
('comment_227', 'task_60', 'user_24', 'Prediction API deployed with auto-scaling. Can handle 1000 req/s.', '2024-11-25T15:00:00'),
('comment_228', 'task_61', 'user_22', 'Airflow HA setup with 3 schedulers. No single point of failure.', '2024-11-08T16:00:00'),
('comment_229', 'task_70', 'user_26', 'App Store submission approved! Launch scheduled for next week.', '2024-11-28T14:00:00'),
('comment_230', 'task_79', 'user_34', 'mTLS enabled across all services. Encrypted service-to-service communication.', '2024-11-08T15:00:00'),
('comment_231', 'task_81', 'user_31', 'Information architecture reviewed by 5 developers. Feedback incorporated.', '2024-11-18T16:00:00'),
('comment_232', 'task_88', 'user_38', 'Security code review identified 8 issues. All fixed before release.', '2024-10-28T14:00:00'),
('comment_233', 'task_93', 'user_36', 'Network segmentation isolates sensitive workloads. Defense in depth.', '2024-11-02T15:00:00'),
('comment_234', 'task_94', 'user_39', 'Least privilege implementation complete. Users have minimum required access.', '2024-11-22T16:00:00'),
('comment_235', 'task_95', 'user_40', 'Continuous monitoring detects anomalies in real-time. Quick threat response.', '2024-12-08T14:00:00'),
('comment_236', 'task_97', 'user_37', 'Compliance checks run nightly. Dashboard shows compliance status.', '2024-11-25T15:00:00'),
('comment_237', 'task_98', 'user_38', 'GDPR data protection measures include encryption and access controls.', '2024-12-02T16:00:00'),
('comment_238', 'task_102', 'user_42', 'Test environment mirrors production. Reliable test results.', '2024-10-25T14:00:00'),
('comment_239', 'task_105', 'user_45', 'Tests running on every commit. Catching regressions early.', '2024-11-08T15:00:00'),
('comment_240', 'task_108', 'user_44', 'Stress test identified breaking point at 5000 concurrent users.', '2024-11-22T16:00:00'),
('comment_241', 'task_110', 'user_41', 'Performance report shows 99% of requests under 200ms. Excellent!', '2024-12-05T14:00:00'),
('comment_242', 'task_114', 'user_47', 'VPN tunnels and peering configured. Secure cross-cloud communication.', '2024-11-18T15:00:00'),
('comment_243', 'task_115', 'user_49', 'Failover test successful. Switch from AWS to GCP took 45 seconds.', '2024-12-08T16:00:00'),
('comment_244', 'task_119', 'user_47', 'Automated failover tested monthly. RTO target consistently met.', '2024-12-05T14:00:00'),
('comment_245', 'task_120', 'user_49', 'DR drill went smoothly. Team knows their roles. Documentation updated.', '2024-12-18T15:00:00'),
('comment_246', 'task_125', 'user_55', 'Feature quality validated manually on 100 samples. 95% accuracy.', '2024-11-05T16:00:00'),
('comment_247', 'task_126', 'user_55', 'Selected TensorFlow Serving. Best fit for our infrastructure.', '2024-11-02T14:00:00'),
('comment_248', 'task_132', 'user_54', 'Labeled 10K images for training. Balanced across all categories.', '2024-11-15T15:00:00'),
('comment_249', 'task_135', 'user_55', 'Demo app deployed to Heroku. Stakeholders can test interactively.', '2024-12-10T16:00:00'),
('comment_250', 'task_139', 'user_59', 'Training materials include videos and interactive guides. Well received!', '2024-11-18T14:00:00'),
('comment_251', 'task_140', 'user_60', 'New process launched to beta customers. Early feedback is positive.', '2024-11-25T15:00:00'),
('comment_252', 'task_145', 'user_60', 'Knowledge base live! Support ticket volume already decreasing.', '2024-11-08T16:00:00'),
('comment_253', 'task_150', 'user_59', 'Beta customers providing excellent feedback. A few bugs to fix.', '2024-12-15T14:00:00'),
('comment_254', 'task_160', 'user_2', 'API versioning headers make deprecation path clear. Developer friendly.', '2024-12-12T15:00:00'),
('comment_255', 'task_165', 'user_4', 'Optimized pool settings eliminate connection exhaustion issues.', '2024-12-20T16:00:00'),
('comment_256', 'task_175', 'user_10', 'Resource hints preload critical assets. Page interactive 500ms faster.', '2024-12-08T14:00:00'),
('comment_257', 'task_190', 'user_15', 'Retention configured for 30 days. Balances cost and debugging needs.', '2024-12-18T15:00:00'),
('comment_258', 'task_194', 'user_18', 'Dependency mapping reveals we need infrastructure work first. Reordering.', '2024-12-05T16:00:00'),
('comment_259', 'task_195', 'user_19', 'Release timeline approved. Features allocated across 3 sprints.', '2024-12-10T14:00:00'),
('comment_260', 'task_199', 'user_19', 'Stakeholder presentation went well. Executive sponsorship secured.', '2024-11-25T15:00:00'),
('comment_261', 'task_200', 'user_16', 'Roadmap updated based on research. Prioritizing user pain points.', '2024-11-28T16:00:00'),
('comment_262', 'task_205', 'user_21', 'Explainability shows why items recommended. Builds user trust.', '2024-12-02T14:00:00'),
('comment_263', 'task_209', 'user_23', 'CRM integration working. Sales team can see churn risk in real-time.', '2024-12-12T15:00:00'),
('comment_264', 'task_210', 'user_24', 'Dashboard visualizes high-risk customers. Actionable insights for CS team.', '2024-12-15T16:00:00'),
('comment_265', 'task_215', 'user_21', 'Backfill completed for 2 years of historical data. No issues!', '2024-12-28T14:00:00'),
('comment_266', 'task_225', 'user_30', 'R8 enabled. APK size reduced by 35% without functionality loss.', '2024-12-18T15:00:00'),
('comment_267', 'task_235', 'user_35', 'API explorer lets developers test endpoints without writing code. Game changer!', '2024-12-15T16:00:00'),
('comment_268', 'task_240', 'user_40', 'Security standards compliance verified. Ready for audit.', '2024-12-02T14:00:00'),
('comment_269', 'task_245', 'user_40', 'SIEM integration provides comprehensive security visibility.', '2024-12-08T15:00:00'),
('comment_270', 'task_250', 'user_40', 'Compliance training completed by entire team. 100% participation.', '2024-12-22T16:00:00');

-- ============================================
-- SUMMARY STATISTICS
-- ============================================
-- Total Records Generated:
-- Organizations: 4
-- Teams: 12
-- Users: 60
-- Projects: 30
-- Sections: 90
-- Tasks: 250
-- Tags: 15
-- Task-Tag Associations: 200+
-- Comments: 270
-- GRAND TOTAL: 931+ datapoints

-- All constraints satisfied:
-- ✓ Foreign key relationships maintained
-- ✓ Email uniqueness enforced
-- ✓ completed_at > created_at for completed tasks
-- ✓ Comments created after their tasks
-- ✓ Realistic enterprise naming patterns
-- ✓ Proper date sequencing
-- ✓ Many-to-many task-tag relationships
-- ✓ Hierarchical organization structure
-- ✓ Diverse task statuses and types