from logzero import logger
from app.controllers.rekognition_controller import recokgnition_controller

def __init__(self):
    with open('test_images/compare_faces/juanipis.jpg', 'rb') as source_image:
        with open('test_images/compare_faces/susiuribe03.jpg', 'rb') as target_image:
            response = recokgnition_controller.compare_faces(source_image.read(), target_image.read())
            logger.info(response)