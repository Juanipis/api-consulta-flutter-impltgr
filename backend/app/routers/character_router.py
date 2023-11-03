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

@router.get("/get_character_images")
async def get_character_images(character_uuid: str):
    result = character_logic.get_character_images(character_uuid)
    if not result:
        raise HTTPException(status_code=400, detail="No se pudo obtener las imágenes del personaje")
    return {
        'character_images': result
    }

@router.post("/insert_new_character_image")
async def insert_new_character_image(character_uuid: str, character_image: UploadFile = File(...)):
    character_image_bytes = await character_image.read()
    result = character_logic.compare_and_insert_character(character_uuid, character_image_bytes)
    if not result:
        raise HTTPException(status_code=400, detail="Las caras no coinciden")
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
    