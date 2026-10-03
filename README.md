# Jira Delivery Analytics

## Overview

This project uses sample Jira data to analyze software delivery and Agile team performance.

The dataset includes issues, sprints, teams, epics, releases, and issue status history. I used Python and pandas to profile and clean the source data, then loaded the processed data into PostgreSQL for analysis.

The database load is automated with Python. Each run recreates the tables, loads the processed CSV files in the correct order, and compares the number of records in each CSV against the number loaded into PostgreSQL.

The next stages of the project will focus on SQL analysis and building a Power BI dashboard around delivery metrics.

## Data Flow

Raw CSV files -> Python/pandas -> Processed CSV files -> PostgreSQL -> SQL analysis -> Power BI

The Python portion of the project handles data profiling, cleanup, database loading, and row-count reconciliation.

## Tools

- Python
- pandas
- PostgreSQL
- SQLAlchemy
- psycopg
- Jupyter Notebook
- DBeaver
- Power BI
- Git / GitHub

## Project Structure

The project is split into three main areas:

- `data/`
  - `raw/` contains the original Kaggle files and is not stored in Git.
  - `processed/` contains the files created after profiling and cleanup.

- `python/`
  - `notebooks/` contains the Jupyter notebook used for data profiling and preparation.
  - `scripts/` contains the database connection and automated database loader.

- `sql/`
  - `schema/` contains the scripts used to create the PostgreSQL database and tables.
  - `source/` contains the original MySQL scripts included with the dataset.
  - `analysis/` will contain the SQL used for analysis.
  - `data_quality/` will contain additional database validation queries.

Other files in the project include:

- `requirements.txt` - Python dependencies
- `.gitignore` - files and folders that should not be committed
- `README.md` - project documentation

## Data Source

The data comes from the **Sample Jira Data for Agile Analysis** dataset by Chad Wambles on Kaggle:

https://www.kaggle.com/datasets/chadwambles/sample-jira-data-for-agile-analysis

The original files are not included in this repository. The `data/raw/` folder is excluded through `.gitignore`.

To reproduce the project starting with the original data:

1. Download the dataset from Kaggle.
2. Place the CSV files in `data/raw/`.
3. Run `python/notebooks/01_data_profiling.ipynb`.

The notebook profiles and validates the source data and exports the resulting files to `data/processed/`.

The processed files are included in the repository, so the raw dataset is only needed if you want to rerun the data preparation step.

## Setup

### 1. Clone the Repository

Clone the repository and open the project folder in VS Code.

### 2. Create a Virtual Environment

From the project root:

```powershell
python -m venv .venv
```

Activate the virtual environment:

```powershell
.venv\Scripts\activate
```

### 3. Install Python Dependencies

Install the required packages:

```powershell
pip install -r requirements.txt
```

### 4. Configure PostgreSQL Connection

Create a `.env` file in the project root with your PostgreSQL connection information:

```text
DB_USER=your_username
DB_PASSWORD=your_password
DB_HOST=localhost
DB_PORT=5432
```

The `.env` file is excluded from Git so database credentials are not stored in the repository.

### 5. Create the Database

Run:

`sql/schema/01_create_database.sql`

This creates the `jira_analytics` PostgreSQL database.

The database only needs to be created once.

### 6. Prepare the Data

The processed CSV files are already included in `data/processed/`, so this step can be skipped if you only want to load the database and run the analysis.

To reproduce the data preparation process from the original Kaggle files:

1. Download the source dataset.
2. Place the CSV files in `data/raw/`.
3. Run `python/notebooks/01_data_profiling.ipynb`.

The notebook exports the processed files to `data/processed/`.

### 7. Load the Database

From the project root, run:

```powershell
python python/scripts/load_database.py
```

The loader will:

- Connect to the `jira_analytics` database.
- Drop and recreate the project tables.
- Read the processed CSV files.
- Convert date and timestamp columns to the correct data types.
- Load the tables in the correct order to maintain foreign key relationships.
- Compare the CSV row counts against the PostgreSQL row counts.
- Display a reconciliation summary showing whether each table passed or failed.

A successful load should show a reconciliation where the difference for every table is `0` and the status is `PASSED`.

