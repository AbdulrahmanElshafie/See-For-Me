from Components.Components import *
from Features.Navigator.TrackedObj import TrackedObj


class User:
    def __init__(self, init_pos):
        self.crnt_pos = init_pos

        self.velocity = 0.7

    def set_crnt_pos(self, crnt_pos):
        self.crnt_pos = np.round(crnt_pos, 3)

    # Take one step
    def calc_next_step(self, direction, t):
        new_x = self.crnt_pos[0] + self.velocity * t * np.cos(direction)
        new_y = self.crnt_pos[1] - self.velocity * t * np.sin(direction)

        return new_x, new_y

    # Check the safety of the user
    def check_safety(self, objs: [TrackedObj], pos2, safe_measure):
        safe = True
        violating_objs = []
        for ob in range(len(objs)):

            # if the distance between user's position and objects' position is <= safe measurement
            # then the user is not safe, otherwise he's safe
            # obj_pred_pos = np.array(objs[ob].pred_pos)
            obj_pred_pos = np.array(objs[ob].calc_pred_pos(2))
            if get_distance(obj_pred_pos, pos2) <= safe_measure and obj_pred_pos[1] <= self.crnt_pos[1]:
                safe = False
                violating_objs.append(objs[ob])  # safe objs that puts user in danger

        return safe, violating_objs

    # Find a safe path for the user
    def find_safe_route(self, objs):
        safe_distance = 1  # safe distance between predicted object next position and a user possible position
        objs_max_distance = 0
        best_pos = self.crnt_pos  # best position, shouldn't move if didn't find a safe route, will be updated when
        # finding one

        max_min_distance = 0
        # check the circle around the user
        for i in range(10, 170, 1):
            safe_pos = True
            new_pos = np.array(self.calc_next_step(i, 2))  # get a new position suggestion

            min_distance = 1e6
            # check each object
            for ob in objs:

                # if the distance between suggestions and prediction is less than safe measurement
                # then safe distance then the suggestion is not safe
                # see where the object will go
                safe, _ = self.check_safety([ob], new_pos, safe_distance)

                #  or not self.check_in_obj_path(new_pos, ob.init_pos, obj_pred_pos)
                # or not (new_pos[0] > 6.5 and new_pos[0] < 11.5)
                if not safe:
                    safe_pos = False
                    break

                obj_pred_pos = ob.calc_pred_pos(2)
                distance = get_distance(obj_pred_pos, new_pos)

                if distance < min_distance:
                    min_distance = distance

            # if suggestion is safe set pos as best position
            if safe_pos and min_distance > max_min_distance:
                max_min_distance = min_distance
                best_pos = np.array(self.calc_next_step(i, 1))

        # take the safest option available
        self.crnt_pos = best_pos
