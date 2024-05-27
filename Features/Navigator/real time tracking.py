from ultralytics import YOLO
import numpy as np
import cv2
from Features.Navigator.TrackedObj import TrackedObj

# load pre-trained yolov9
model = YOLO("D:\College\Fourth year\Graduation Project\See For Me\yolov9c.pt")
# model = YOLO("D:\College\Fourth year\Graduation Project\See For Me\yolov9e.pt")
source = 'D:\College\Fourth year\Graduation Project\See For Me\/vid.mp4'
objs = {}


# cap = cv2.VideoCapture(source)
# fps = cap.get(cv2.CAP_PROP_FPS)
# width = int(cap.get(cv2.CAP_PROP_FRAME_WIDTH))
# height = int(cap.get(cv2.CAP_PROP_FRAME_HEIGHT))
# size = (width, height)
# output = cv2.VideoWriter('results.mp4', -1, 15, size)

# while cap.isOpened():
#
#     # Capture frame-by-frame
#     ret, frame = cap.read()
#     if ret:
#         results = model.track(source=frame, show=False, stream=True)
#         for result in results:
#             data = result.boxes.data.numpy()
#             # print(data)
#             for d in data:
#                 x1, y1, x2, y2, id = d[:5]
#                 w = x2 - x1
#                 h = y2 - y1
#                 x_mid = int((x1 + x2) / 2)
#                 y_mid = int((y1 + y2) / 2)
#
#                 # original position
#                 cv2.rectangle(frame, (int(x1), int(y1)), (int(x2), int(y2)), (0, 0, 255), 3)
#                 cv2.circle(frame, (x_mid, y_mid), radius=5, color=(0, 0, 255), thickness=3)
#                 cv2.putText(frame, str(id), (int(x_mid), int(y_mid - 10)),
#                             cv2.FONT_HERSHEY_SIMPLEX, 0.9, (0, 0, 255), 3)
#
#                 if objs.get(id) is None:
#                     objs[id] = TrackedObj((x_mid, y_mid), id, w, h)
#
#                 else:
#                     objs[id].set_init_pos()
#                     objs[id].set_crnt_pos((x_mid, y_mid))
#
#                     objs[id].getVelocity()
#
#                     obj_pred_pos = objs[id].calc_pred_pos(3)
#                     objs[id].set_pred_pos(obj_pred_pos)
#
#                     objs[id].update_error()
#
#                     cv2.rectangle(frame, (int(obj_pred_pos[0] - w / 2), int(obj_pred_pos[1] - h / 2)),
#                                   (int(obj_pred_pos[0] + w / 2), int(obj_pred_pos[1] + h / 2)), (0, 255, 0), 2)
#
#                     cv2.circle(frame, (int(objs[id].pred_pos[0]), int(objs[id].pred_pos[1])), radius=2,
#                                color=(0, 255, 0), thickness=2)
#                     cv2.putText(frame, str(id), (int(objs[id].pred_pos[0]), int(objs[id].pred_pos[1] - 10)),
#                                 cv2.FONT_HERSHEY_SIMPLEX, 0.9, (0, 255, 0), 2)
#
#         output.write(frame)
#         # cv2.imshow("Frame", frame)
#
#         # Press Q on keyboard to exit
#         if cv2.waitKey(25) & 0xFF == ord('q'):
#             break
#
#     else:
#         break
# cv2.destroyAllWindows()
# output.release()
# cap.release()

results = model.track(source=source, show=True, stream=True)
for result in results:
    result.save('output.mp4')

    data = result.boxes.data.numpy()
    # print(data)
    for d in data:
        x1, y1, x2, y2, id = d[:5]
        w = x2 - x1
        h = y2 - y1
        x_mid = int((x1 + x2) / 2)
        y_mid = int((y1 + y2) / 2)

        if objs.get(id) is None:
            objs[id] = TrackedObj((x_mid, y_mid), id, w, h)
        else:
            objs[id].set_init_pos()
            objs[id].set_crnt_pos((x_mid, y_mid))
            print(f"For obj {id}, predicted pos {objs[id].pred_pos}, actual pos {objs[id].crnt_pos}")
            objs[id].getVelocity()

            obj_pred_pos = objs[id].calc_pred_pos()
            objs[id].set_pred_pos(obj_pred_pos)

            objs[id].update_error()
