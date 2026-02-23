from sqlalchemy import create_engine

def get_connection():
    return create_engine('mysql+pymysql://postgres:123@127.0.0.1:3306/recipe_manager_db')