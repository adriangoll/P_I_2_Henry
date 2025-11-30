import os
from dotenv import load_dotenv

load_dotenv()

DB_HOST = os.getenv("POSTGRES_HOST", "localhost")
DB_PORT = os.getenv("POSTGRES_PORT", "5432")
DB_NAME = os.getenv("POSTGRES_DB", "ecommerce_raw")
DB_USER = os.getenv("POSTGRES_USER", "ecommerce_user")
DB_PASSWORD = os.getenv("POSTGRES_PASSWORD", "ecommerce_password")

DATABASE_URL = f"postgresql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}"

DATA_PATH = "../data/raw"