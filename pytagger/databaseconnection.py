import sqlite3
from sqlite3 import Connection

DATABASE_NAME = 'tangotagger_v1.db'

class DatabaseConnection:
    _instance = None

    def __new__(cls):
        if cls._instance is None:
            cls._instance = super(DatabaseConnection, cls).__new__(cls)
            cls._instance._initialize_connection()
        return cls._instance

    def _initialize_connection(self):
        self.connection = sqlite3.connect(DATABASE_NAME)
        self._run_pragma_commands() 

    def get_connection(self) -> Connection:
        return self.connection

    def close_connection(self):
        if self.connection:
            self.connection.close()
            self.__class__._instance = None

    def _run_pragma_commands(self):
        cursor = self.connection.cursor()
        pragmas = [
            "pragma journal_mode = WAL;",
            "pragma synchronous = normal;",
            "pragma temp_store = memory;",
            "pragma mmap_size = 30000000000;",
            "pragma page_size = 32768;",
            "pragma vacuum;",
            "pragma optimize;"
        ]
        for pragma in pragmas:
            cursor.execute(pragma)
        self.connection.commit()