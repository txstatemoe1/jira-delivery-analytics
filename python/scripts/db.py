import os
from dotenv import load_dotenv
from sqlalchemy import create_engine

# Load environment variables from the .env file
load_dotenv()

# Get the database engine
def get_engine(database_name):
    user = os.getenv("DB_USER")
    password = os.getenv("DB_PASSWORD")
    host = os.getenv("DB_HOST")
    port = os.getenv("DB_PORT")

# Validate required environment variables
    required_vars = {
        "DB_USER": user,
        "DB_PASSWORD": password,
        "DB_HOST": host,
        "DB_PORT": port,
    }

# Check for missing environment variables
    missing_vars = [
        name for name, value in required_vars.items() 
        if not value
    ]

    if missing_vars:
        raise ValueError(
            f"Missing required environment variables: {', '.join(missing_vars)}"
        )

    if not database_name:
        raise ValueError("Database name cannot be empty.")

# Create the connection string and return the engine
    connection_string = (
        f"postgresql+psycopg://{user}:{password}"
        f"@{host}:{port}/{database_name}"
    )
    
    return create_engine(connection_string)