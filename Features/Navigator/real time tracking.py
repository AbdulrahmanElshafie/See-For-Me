from ultralytics import YOLO
import numpy as np

# load pre-trained yolov8
model = YOLO('yolov8m.pt')

# run inference on source
results = model.track(source=0, show=True, stream=True)

# get boxes at each result
# get (x,y), the width and the height for each box
for result in results:
    boxes = result.boxes
    xywhn = boxes.xywhn
    xywhn = xywhn.numpy()
    print(xywhn)





