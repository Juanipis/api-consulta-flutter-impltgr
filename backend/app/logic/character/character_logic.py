import uuid
from uuid import UUID
from app.controllers.rds import rds_controller
from app.controllers.s3 import s3_controller
from app.models.character import Character
from app.logic.rekognition.recokgnition_logic import recokgnition_logic
from app.models.face_rekognition import FaceRecognitionResponse
from logzero import logger

class CharacterLogic:
    def insert_character(self, character_uuid:UUID, character_image:bytes) -> bool:
        if rds_controller.check_character_exist(character_uuid):
            return False
        path = character_uuid+'/original.jpg'
        s3_controller.insert_file(character_image,path)
        rds_controller.insert_character_image(character_uuid,path)
        return True
    
    def get_character_images(self, character_uuid:UUID) -> Character:
        return rds_controller.get_character_images(character_uuid)
    
    def insert_new_character_image(self, character_uuid:UUID, character_image:bytes, recokgnition_response: FaceRecognitionResponse) -> bool:
        if not rds_controller.check_character_exist(character_uuid):
            return False
        #generate an uuid for the new image
        new_image_uuid =  str(uuid.uuid4())
        character_uuid = str(character_uuid)
        new_path = character_uuid+'/'+new_image_uuid
        s3_controller.insert_file(character_image,character_uuid+'/'+new_image_uuid+'.jpg')
        s3_controller.insert_json(recokgnition_response.model_dump_json(),new_path+'.json')
        rds_controller.insert_character_image(character_uuid,new_path+'.jpg')
        return True
    
    def compare_and_insert_character(self, character_uuid:UUID, character_image:bytes) -> bool:
        logger.info('Checkingh if character exist')
        if not rds_controller.check_character_exist(character_uuid):
            return False
        
        logger.info('Getting original image from s3')
        original_image = s3_controller.get_file(character_uuid+'/original.jpg')
        
        logger.info('Comparing faces')
        face_equal, _, _, result = recokgnition_logic.compare_faces(original_image,character_image)
        
        if not face_equal:
            logger.info('Images are not equal')
            return False
        
        logger.info('Image equals, inserting')
        self.insert_new_character_image(character_uuid,character_image, result)
        return True
    
    def get_all_characters(self) :
        return rds_controller.get_all_characters()
character_logic = CharacterLogic()