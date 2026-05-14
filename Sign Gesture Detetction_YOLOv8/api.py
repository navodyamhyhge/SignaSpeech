from fastapi import FastAPI, File, UploadFile
from ultralytics import YOLO
import numpy as np
import cv2

app = FastAPI()

model = YOLO("runs/detect/train-2/weights/best.pt")

@app.post("/predict")
async def predict(file: UploadFile = File(...)):
    contents = await file.read()
    nparr = np.frombuffer(contents, np.uint8)
    img = cv2.imdecode(nparr, cv2.IMREAD_COLOR)

    results = model(img)

    for r in results:
        if len(r.boxes) > 0:
            cls = int(r.boxes.cls[0])
            label = model.names[cls]
            return {"prediction": label}

    return {"prediction": "No detection"}