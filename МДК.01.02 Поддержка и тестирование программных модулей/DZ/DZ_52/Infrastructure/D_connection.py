from sqlalchemy import create_engine

def get_engine():
    return create_engine('mysql+mysqlconnector://root:@localhost:3306/task_manager_db')