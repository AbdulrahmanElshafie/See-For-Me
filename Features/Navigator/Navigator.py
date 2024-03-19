from Components.Components import *

class Navigator:
    def __init__(self):
        self.model = YOLO('yolov8m.pt')

        # run inference on source

    def track(self):
        results = self.model.track(source=0, show=True, stream=True)

        # get boxes at each result
        # get (x,y), the width and the height for each box
        for result in results:
            boxes = result.boxes
            xywhn = boxes.xywhn
            xywhn = xywhn.numpy()
            print(xywhn)