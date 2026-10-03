-- LOAD DATA LOCAL INFILE quick loader (MySQL 8+)
-- Enable:
--   SET GLOBAL local_infile = 1;
-- And ensure your client allows LOCAL INFILE.

LOAD DATA LOCAL INFILE 'teams.csv'
INTO TABLE teams
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'team_members.csv'
INTO TABLE team_members
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'projects.csv'
INTO TABLE projects
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'epics.csv'
INTO TABLE epics
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'sprints.csv'
INTO TABLE sprints
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'issues.csv'
INTO TABLE issues
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(issue_id, issue_key, project_id, team_id, epic_id, assignee_id, issue_type, priority, summary, created_at, resolved_at, story_points, current_status, sprint_id);

LOAD DATA LOCAL INFILE 'issue_status_history.csv'
INTO TABLE issue_status_history
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(issue_id, status, changed_at);

LOAD DATA LOCAL INFILE 'releases.csv'
INTO TABLE releases
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'release_issues.csv'
INTO TABLE release_issues
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;
