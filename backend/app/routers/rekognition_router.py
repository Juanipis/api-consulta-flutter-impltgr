from app.logic.rekognition.recokgnition_logic import recokgnition_logic
from fastapi import APIRouter, File, UploadFile, HTTPException

router = APIRouter()

@router.post("/compare_faces")
async def compare_faces(source_image: UploadFile = File(...), target_image: UploadFile = File(...)):
    if not source_image or not target_image:
        raise HTTPException(status_code=400, detail="No se enviaron las imágenes")
    
    source_image_bytes = await source_image.read()
    target_image_bytes = await target_image.read()
    
    face_equal, face_similarity, face_index, result = recokgnition_logic.compare_faces(source_image_bytes, target_image_bytes)
    if not result:
        raise HTTPException(status_code=400, detail="No se pudo realizar la comparación")
    
    return {
        'face_equal': face_equal,
        'face_Similarity': face_similarity,
        'face_index': face_index,
        'result': result.model_dump_json()
    }
