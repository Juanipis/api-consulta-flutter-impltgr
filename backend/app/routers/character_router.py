import base64
from typing import Dict, List, Union
import uuid
from app.logic.character.character_logic import character_logic
from fastapi import APIRouter, File, UploadFile, HTTPException

router = APIRouter()

@router.post("/insert_character")
async def insert_character(character_uuid: str, character_image: UploadFile = File(...)):
    character_image_bytes = await character_image.read()
    result = character_logic.insert_character(character_uuid, character_image_bytes)
    if not result:
        raise HTTPException(status_code=400, detail="No se pudo insertar el personaje")
    return {
        'inserted': result
    }

@router.get("/get_character_images_names")
async def get_character_images(character_uuid: str):
    result = character_logic.get_character_images(character_uuid)
    if not result:
        raise HTTPException(status_code=400, detail="No se pudo obtener las imágenes del personaje")
    return {
        'character_images': result
    }

@router.get("/get_character_images_bytes/{character_uuid}", response_model=Dict[str, Union[str, Dict[str, str]]])
async def get_character_images(character_uuid: str):
    check_uuid(character_uuid)
    result = character_logic.get_character_images_bytes(character_uuid)
    if not result:
        raise HTTPException(status_code=400, detail="No se pudo obtener las imágenes del personaje")
    # Codificamos cada imagen en base64 y la devolvemos como un diccionario
    images = {name: base64.b64encode(img).decode() for name, img in result.items()}
    return {"character_uuid": character_uuid, "data": images}


@router.post("/insert_new_character_image")
async def insert_new_character_image(character_uuid: str, character_image: UploadFile = File(...)):
    character_image_bytes = await character_image.read()
    result = character_logic.compare_and_insert_character(character_uuid, character_image_bytes)
    return {
        'inserted': result
    }

@router.get("/get_all_characters")
async def get_all_characters():
    result = character_logic.get_all_characters()
    if not result:
        raise HTTPException(status_code=400, detail="No se pudo obtener los personajes")
    # result is a list of characters, return a list of jsons

    return {
        'characters': result
    }

@router.get("/get_all_characters_uuids")
async def get_all_characters_uuid() -> Dict[str,List[uuid.UUID]]:
    result = character_logic.get_all_characters_uuid()
    if not result:
        return {'uuid_list':[]}
    return {'uuid_list':result}

# router to clean the database and the rds bucket
@router.delete("/clean_database")
async def clean_database():
    result = character_logic.clean_database()
    if not result:
        raise HTTPException(status_code=400, detail="No se pudo limpiar la base de datos")
    return {
        'cleaned': result
    }

def check_uuid(character_uuid):
    try:
        uuid.UUID(character_uuid)
    except ValueError:
        raise HTTPException(status_code=400, detail="El uuid no es válido")