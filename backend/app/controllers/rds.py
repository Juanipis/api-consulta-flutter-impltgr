from typing import Dict, List
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
    drop_table: bool = False

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
        logger.info("Starting RDS table")
        
        logger.info("Creating extension uuid-ossp")
        self.cursor.execute("""
            CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
        """)
        
        logger.info("Checking if table characters exists")
        self.cursor.execute("""
            SELECT EXISTS (
                SELECT FROM information_schema.tables 
                WHERE table_schema = 'public' 
                AND table_name = 'characters'
            );
        """)
        
        if not self.cursor.fetchone()[0]:
            logger.info("Creating table characters")
            self.cursor.execute(
                """
                CREATE TABLE IF NOT EXISTS characters (
                    id UUID NOT NULL DEFAULT uuid_generate_v4(),
                    images_route varchar(255) NOT NULL,
                    PRIMARY KEY (id, images_route)
                )
                """
            )
        else:
            logger.info("Table characters already exists")
            if self.credentials.drop_table:
                logger.info("Dropping table students")
                self.cursor.execute("""
                    DELETE FROM characters;
                """)
                self.conn.commit()
    
    def insert_character_image(self, character_uuid:UUID, image_route:str) -> bool:
        self.cursor.execute(
            """
            INSERT INTO characters (id, images_route)
            VALUES (%s, %s)
            """,
            (character_uuid, image_route)
        )
        self.conn.commit()
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
    
    def get_character_images(self, character_uuid:UUID) -> Character:
        self.cursor.execute(
            """
            SELECT images_route FROM characters
            WHERE id = %s
            """,
            (character_uuid,)
        )
        #Now save the results in a list
        images_list = []
        for image in self.cursor.fetchall():
            images_list.append(image[0])
        
        return Character(id=character_uuid, images_route=images_list)
    
    def check_character_exist(self, character_uuid:UUID) -> bool:
        self.cursor.execute(
            """
            SELECT * FROM characters
            WHERE id = %s
            """,
            (str(character_uuid),)
        )
        
        if self.cursor.fetchone():
            return True
        else:
            return False
        
    def get_all_characters(self) :
        self.cursor.execute(
            """
            SELECT * FROM characters
            """
        )
        
        raw_characters =  self.cursor.fetchall()
        if not raw_characters:
            return None
        
        characters_dict: Dict[UUID, Character] = {}
        
        for char_id, image_route in raw_characters:
            # Convertir el id a un objeto UUID
            char_id = UUID(char_id)
            
            if char_id in characters_dict:
                # Si el personaje ya existe, añadimos la ruta de la imagen
                characters_dict[char_id].images_route.append(image_route)
            else:
                # Si el personaje no existe, lo creamos y añadimos la primera ruta de imagen
                characters_dict[char_id] = Character(id=char_id, images_route=[image_route])
                
        # Convertimos el diccionario a una lista de personajes
        character_list = list(characters_dict.values())
        return character_list

    def close_connection(self):
        logger.info("Closing RDS connection")
        self.cursor.close()
        self.conn.close()

rds_controller = RDSController()