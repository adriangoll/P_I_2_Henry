from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from config import DATABASE_URL

engine = create_engine(DATABASE_URL, echo=False)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

def get_connection():
    """Retorna una conexión activa a la BD"""
    return engine.connect()

def get_session():
    """Retorna una sesión SQLAlchemy"""
    return SessionLocal()