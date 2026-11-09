from typing import Tuple
from fastapi import HTTPException
from app.controllers.rekognition_controller import recokgnition_controller
from app.models.face_rekognition import FaceRecognitionResponse
from logzero import logger

class RecokgnitionLogic:
    def compare_faces(self, source_image:bytes, target_image:bytes) -> Tuple[bool, float, int, FaceRecognitionResponse]:
        logger.info('Checking if we have images')
        if not source_image or not target_image:
            raise HTTPException(status_code=400, detail="No se enviaron las imágenes")
        
        logger.info('Comparing faceses with recokginition')
        result = recokgnition_controller.compare_faces(source_image, target_image)
        if not result:
            raise HTTPException(status_code=400, detail="No se pudo realizar la comparación")
        logger.info('Recokgnition done')
        if not result.FaceMatches:
            logger.info('Faces dosent match')
            return False, 0, 0, result
        
        for index, face in enumerate(result.FaceMatches):
            if face.Similarity > 80:
                logger.info('Faces match')
                return True, face.Similarity, index, result

recokgnition_logic = RecokgnitionLogic()