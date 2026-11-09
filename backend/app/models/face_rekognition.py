from typing import List
from pydantic import BaseModel

class BoundingBox(BaseModel):
    Width: float
    Height: float
    Left: float
    Top: float

class Landmark(BaseModel):
    Type: str
    X: float
    Y: float

class Pose(BaseModel):
    Roll: float
    Yaw: float
    Pitch: float

class Quality(BaseModel):
    Brightness: float
    Sharpness: float

class Face(BaseModel):
    BoundingBox: BoundingBox
    Confidence: float
    Landmarks: List[Landmark]
    Pose: Pose
    Quality: Quality

class FaceMatch(BaseModel):
    Similarity: float
    Face: Face

class SourceImageFace(BaseModel):
    BoundingBox: BoundingBox
    Confidence: float

class ResponseMetadata(BaseModel):
    RequestId: str
    HTTPStatusCode: int
    HTTPHeaders: dict
    RetryAttempts: int

class FaceRecognitionResponse(BaseModel):
    SourceImageFace: SourceImageFace
    FaceMatches: List[FaceMatch]
    UnmatchedFaces: List[Face]
    ResponseMetadata: ResponseMetadata