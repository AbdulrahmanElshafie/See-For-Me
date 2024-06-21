from Components.Components import *
from Components.Features import *

class TrackedObj:
    def __init__(self, init_pos, id, w, h):
        self.width = w
        self.height = h

        self.init_pos = init_pos
        self.crnt_pos = init_pos
        self.pred_pos = init_pos

        self.velocity = 0
        self.distance = 0
        self.direction = 0
        self.direction_e = 0
        self.distance_e = 0

        self.lr_distance = 0.1
        self.lr_direction = 0.8

        self.id = id

    # get object's velocity and add the error rate to it
    def getVelocity(self):
        self.distance = get_distance(self.crnt_pos, self.init_pos) + self.lr_distance * self.distance_e

        self.velocity = np.round(self.distance, 3)

    # predict object's next position
    def calc_pred_pos(self, t=1):
        # get object's direction and add direction error rate
        self.direction = self.get_direction(self.init_pos, self.crnt_pos) + self.lr_direction * self.direction_e

        new_x = self.crnt_pos[0] + self.velocity * t * np.cos(self.direction)  # calculate new x
        new_y = self.crnt_pos[1] + self.velocity * t * np.sin(self.direction)  # calculate new y

        return new_x, new_y

    # update error in velocity and direction
    def update_error(self):
        # difference between predicted location and actual one
        self.distance_e = np.round(get_distance(self.crnt_pos, self.pred_pos), 3)

        # difference between predicted diection and actual one
        self.direction_e = self.get_direction(self.crnt_pos, self.init_pos) - self.get_direction(self.pred_pos,
                                                                                                 self.init_pos)

        # self.distance_e =  np.round(self.distance_e, 3)
        # self.direction_e =  np.round(self.direction_e, 3)

    # update current position
    def set_crnt_pos(self, crnt_pos):
        self.crnt_pos = np.round(crnt_pos, 3)

    # update init/prev position
    def set_init_pos(self):
        self.init_pos = self.crnt_pos

    # set predicted position
    def set_pred_pos(self, pred_pos):
        self.pred_pos = pred_pos

    # get the movement direction
    def get_direction(self, pos1, pos2):
        return np.arctan2(pos2[1] - pos1[1], pos2[0] - pos1[0]) * 180. / np.pi
