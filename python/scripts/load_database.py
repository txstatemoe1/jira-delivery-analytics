import pandas as pd
from db import get_engine
from sqlalchemy import text
import sys

## converstion function
def convert_dates(df, name):

    date_columns = {
        'issues': ['created_at','resolved_at'],
        'issue_status_history': ['changed_at'],
        'sprints': ['start_date','end_date'],
        'releases': ['release_date']
    }   

    if name in date_columns:
        for date_col in date_columns[name]:
            df[date_col] = pd.to_datetime(
                df[date_col],
                errors='coerce'
                )

    return df

## Reconcile Load Counts
def reconcile_load(connection, tables, export):
    reconciliation = []

    for name in tables:
        table_data = pd.read_csv(export + name + '.csv')
        csv_count = table_data.shape[0]
        
        result = connection.execute(
            text(f"SELECT COUNT(*) FROM {name}")
        )
        db_count = result.scalar()
        
        count_delta = csv_count - db_count
       
        row = {
            'TABLE': name ,
            'CSV ROW COUNT': csv_count ,
            'DB ROW COUNT': db_count , 
            'DIFFERENCE': count_delta , 
            'STATUS': 'PASSED' if count_delta == 0 else 'FAILED'
        }

        reconciliation.append(row)

    df = pd.DataFrame(reconciliation)
    print(df)

## main function
#load engine
engine = get_engine('jira_analytics')

##list of table names to import data into
table_names = [
    'teams',
    'team_members',
    'projects',
    'epics',
    'sprints',
    'issues',
    'issue_status_history',
    'releases',
    'release_issues'
]

export_path = 'data/processed/'

#create connection to database
with engine.begin() as conn:
    print("-----Database Connected Successfully-----")

    # reset database tables for clean import
    with open('sql/schema/02_create_tables.sql', 'r') as file:
        create_tables_sql = file.read()

    conn.execute(text(create_tables_sql))
    print('--Table Structure Created--')

    ##load database tables
    for name in table_names:
        try:
            ##import file
            df = pd.read_csv(export_path + name + '.csv')

            ## convert date columns to date
            df = convert_dates(df, name)

            ##execute SQL    
            df.to_sql(
                name, 
                conn, 
                if_exists='append', 
                index=False
            )

            print('... Successfully Loaded ' + name)

        except Exception as e:
            print ('... Error Loading Data ' + export_path + name + '.csv')
            print(e.__cause__.orig)
            sys.exit(1)

    # Call reconciliation function to verify row counts
    reconcile_load(conn, table_names, export_path)   