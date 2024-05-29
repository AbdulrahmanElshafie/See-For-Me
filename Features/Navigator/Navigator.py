from Components.Components import *


class Navigator:
    def __init__(self):
        self.model = YOLO("yolov9c.pt")
        self.trackedObjs = {}

    def track(self, objs):

        for obj in objs:
            x1, y1, x2, y2, id = obj[:5]
            w = x2 - x1
            h = y2 - y1
            x_mid = int((x1 + x2) / 2)
            y_mid = int((y1 + y2) / 2)

            if self.trackedObjs.get(id) is None:
                self.trackedObjs[id] = TrackedObj((x_mid, y_mid), id, w, h)
            else:
                self.trackedObjs[id].set_init_pos()
                self.trackedObjs[id].set_crnt_pos((x_mid, y_mid))

                self.trackedObjs[id].update_error()
                self.trackedObjs[id].getVelocity()

    def navigate(self, objs):
        safe_zone = 3
        self.track(objs)
        safe, violating_objs = user.check_user_safety(objs, safe_zone)

        if not safe:
            best_angle = user.find_safe_route(violating_objs)
            instruction = user.give_instruction(best_angle)
            instruction_read = text_to_speech("move " + instruction)
            return instruction_read
