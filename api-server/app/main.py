from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from app.s3_utils import write_to_s3
import os


app = FastAPI()


class RequestBody(BaseModel):
    content: str


@app.post("/write-to-s3")
async def write_to_s3_endpoint(data: RequestBody):
    bucket_name = os.getenv("S3_BUCKET")
    if not bucket_name:
        raise HTTPException(status_code=500, detail="S3_BUCKET environment variable not set")
    try:
        result = write_to_s3(bucket_name, data.content)
        return {"message": "Data written to S3", "s3_path": result["s3_path"]}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
