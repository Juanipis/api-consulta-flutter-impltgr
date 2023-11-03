from contextlib import asynccontextmanager
from fastapi import FastAPI
from app.routers.rekognition_router import router as rekognition_router
from app.routers.character_router import router as character_router
from app.controllers.rds import rds_controller
from app.controllers.s3 import s3_controller



app = FastAPI()
app.include_router(rekognition_router, prefix="/rekognition", tags=["rekognition"])
app.include_router(character_router, prefix="/character", tags=["character"])
@app.get("/")
def read_root():
    return {"Hello": "World"}
