import boto3
from botocore.exceptions import ClientError
from pydantic_settings import BaseSettings
from app.models.face_rekognition import FaceRecognitionResponse
from logzero import logger

class RekognitionCredentials(BaseSettings):
    aws_access_key_id: str
    aws_secret_access_key: str
    s3_region: str = 'us-west-1'

class Rekognition:
    def __init__(self) -> None:
        self.credentials = RekognitionCredentials()
        self.client = boto3.client('rekognition', region_name=self.credentials.s3_region,
                                    aws_access_key_id=self.credentials.aws_access_key_id,
                                    aws_secret_access_key=self.credentials.aws_secret_access_key)
    
    def compare_faces(self, source_image:bytes, target_image:bytes) -> FaceRecognitionResponse:
        try:
            logger.info('Sending requiest to recokgnition')
            response = self.client.compare_faces(
                SourceImage={
                    'Bytes': source_image
                },
                TargetImage={
                    'Bytes': target_image
                },
                SimilarityThreshold=80,
                QualityFilter='AUTO'
            )
            logger.info('Response to recokgnition done')
            
            if response and response['ResponseMetadata']['HTTPStatusCode'] == 200:
                logger.info('Response correct')
                logger.info(response)
                return FaceRecognitionResponse(**response)
            
            
        except ClientError as e:
            logger.error(e)
            return None
        

recokgnition_controller = Rekognition()

