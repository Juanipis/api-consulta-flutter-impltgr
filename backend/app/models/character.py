from typing import List
from pydantic import BaseModel
from uuid import UUID

class Character(BaseModel):
    id: UUID
    images_route: List[str] = []