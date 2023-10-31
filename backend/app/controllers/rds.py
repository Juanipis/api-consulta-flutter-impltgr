from typing import List
from uuid import UUID
from pydantic_settings import BaseSettings
import psycopg2
from app.models.character import Character
from logzero import logger

class RDSCredentiasl(BaseSettings):
    rds_host: str
    rds_port: int
    rds_user: str
    rds_password: str
    rds_region: str = 'us-east-1'
    rds_db_name: str

class RDSController:
    def __init__(self, rds_credentials=RDSCredentiasl()):
        self.credentials = rds_credentials
        self.conn = psycopg2.connect(
            host=self.credentials.rds_host,
            port=self.credentials.rds_port,
            user=self.credentials.rds_user,
            password=self.credentials.rds_password,
            dbname=self.credentials.rds_db_name
        )
        self.cursor = self.conn.cursor()
        self.start_table()

    def start_table(self):
        self.cursor.execute(
            """
            CREATE TABLE IF NOT EXISTS characters (
                id UUID NOT NULL,
                images_route varchar(255) NOT NULL,
                PRIMARY KEY (id, images_route)
            )
            """
        )
    
    def insert_character_image(self, character_uuid:UUID, image_route:str) -> bool:
        self.cursor.execute(
            """
            INSERT INTO characters (id, images_route)
            VALUES (%s, %s)
            """,
            (character_uuid, image_route)
        )
        
        self.cursor.execute(
            """
            SELECT * FROM characters
            WHERE id = %s AND images_route = %s
            """,
            (character_uuid, image_route)
        )
        
        if self.cursor.fetchone():
            return True
        else:
            return False
        
    
    def get_character_images(self, character_uuid:UUID) -> List[str]:
        self.cursor.execute(
            """
            SELECT images_route FROM characters
            WHERE id = %s
            """,
            (character_uuid,)
        )
        if self.cursor.fetchone():
            return Character(id=character_uuid, images_route=self.cursor.fetchall())
        else:
            return Character(id=character_uuid, images_route=[])

rds_controller = RDSController()