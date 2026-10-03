/* This script will create all necessary tables to import the 
 * JIRA raw data
 * */

DROP TABLE IF EXISTS release_issues;
DROP TABLE IF EXISTS releases;
DROP TABLE IF EXISTS issue_status_history;
DROP TABLE IF EXISTS issues;
DROP TABLE IF EXISTS sprints;
DROP TABLE IF EXISTS epics;
DROP TABLE IF EXISTS projects;
DROP TABLE IF EXISTS team_members;
DROP TABLE IF EXISTS teams;

CREATE TABLE teams (
  team_id        INT PRIMARY KEY,
  team_name      VARCHAR(120) NOT NULL,
  specialization VARCHAR(40) NOT NULL,
  team_type      VARCHAR(30) NOT NULL
);

CREATE TABLE team_members (
  member_id  INT PRIMARY KEY,
  team_id    INT NOT NULL,
  role       VARCHAR(60) NOT NULL,
  seniority  VARCHAR(20) NOT NULL,
  CONSTRAINT fk_members_team FOREIGN KEY (team_id) REFERENCES teams(team_id)
);

CREATE TABLE projects (
  project_id     INT PRIMARY KEY,
  project_key    VARCHAR(20) NOT NULL,
  project_name   VARCHAR(120) NOT NULL,
  owner_team_id  INT,
  CONSTRAINT fk_projects_owner_team FOREIGN KEY (owner_team_id) REFERENCES teams(team_id)
);

CREATE TABLE epics (
  epic_id    INT PRIMARY KEY,
  project_id INT NOT NULL,
  team_id    INT NOT NULL,
  epic_key   VARCHAR(30) NOT NULL,
  epic_name  VARCHAR(200) NOT NULL,
  CONSTRAINT fk_epics_project FOREIGN KEY (project_id) REFERENCES projects(project_id),
  CONSTRAINT fk_epics_team    FOREIGN KEY (team_id) REFERENCES teams(team_id)
);

CREATE TABLE sprints (
  sprint_id   INT PRIMARY KEY,
  project_id  INT NOT NULL,
  sprint_name VARCHAR(80) NOT NULL,
  start_date  DATE NOT NULL,
  end_date    DATE NOT NULL,
  CONSTRAINT fk_sprints_project FOREIGN KEY (project_id) REFERENCES projects(project_id)
);

CREATE TABLE issues (
  issue_id       INT PRIMARY KEY,
  issue_key      VARCHAR(30) NOT NULL,
  project_id     INT NOT NULL,
  team_id        INT NOT NULL,
  epic_id        INT NOT NULL,
  assignee_id    INT NOT NULL,
  issue_type     VARCHAR(15) NOT NULL,
  priority       VARCHAR(5) NOT NULL,
  summary        VARCHAR(255) NOT NULL,
  created_at     TIMESTAMP NOT NULL,
  resolved_at    TIMESTAMP NULL,
  story_points   INT NOT NULL,
  current_status VARCHAR(40) NOT NULL,
  sprint_id      INT NOT NULL,
  CONSTRAINT fk_issues_project  FOREIGN KEY (project_id) REFERENCES projects(project_id),
  CONSTRAINT fk_issues_team     FOREIGN KEY (team_id) REFERENCES teams(team_id),
  CONSTRAINT fk_issues_epic     FOREIGN KEY (epic_id) REFERENCES epics(epic_id),
  CONSTRAINT fk_issues_assignee FOREIGN KEY (assignee_id) REFERENCES team_members(member_id),
  CONSTRAINT fk_issues_sprint   FOREIGN KEY (sprint_id) REFERENCES sprints(sprint_id)
);

CREATE INDEX idx_issues_project_created ON issues(project_id, created_at);
CREATE INDEX idx_issues_team_status ON issues(team_id, current_status);

CREATE TABLE issue_status_history (
  issue_id    INT NOT NULL,
  status      VARCHAR(40) NOT NULL,
  changed_at  TIMESTAMP NOT NULL,
  CONSTRAINT fk_hist_issue FOREIGN KEY (issue_id) REFERENCES issues(issue_id)
);

CREATE INDEX idx_hist_issue_changed ON issue_status_history(issue_id, changed_at);

CREATE TABLE releases (
  release_id    INT PRIMARY KEY,
  project_id    INT NOT NULL,
  release_name  VARCHAR(120) NOT NULL,
  release_date  DATE NOT NULL,
  CONSTRAINT fk_releases_project FOREIGN KEY (project_id) REFERENCES projects(project_id)
);

CREATE TABLE release_issues (
  release_id  INT NOT NULL,
  issue_id    INT NOT NULL,
  PRIMARY KEY (release_id, issue_id),
  CONSTRAINT fk_relissues_release FOREIGN KEY (release_id) REFERENCES releases(release_id),
  CONSTRAINT fk_relissues_issue   FOREIGN KEY (issue_id) REFERENCES issues(issue_id)
);

