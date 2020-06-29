import random
import numpy as np


class driver:
    def __init__(self, extra=False, rounds=10):
        self.direction = 0
        self.extra = extra
        self.rounds = rounds

    def turn(self):
        if not self.extra:
            if self.direction in [0, 2]:
                self.direction = np.random.choice([1, 3])
            else:
                self.direction = np.random.choice([0, 2])
        else:
            if self.direction == 0:
                self.direction = np.random.choice([0, 1, 3])
            elif self.direction == 1:
                self.direction = np.random.choice([0, 2, 1])
            elif self.direction == 2:
                self.direction = np.random.choice([2, 1, 3])
            else:
                self.direction = np.random.choice([0, 3, 2])

    def drive(self):
        for i in range(self.rounds):
            self.turn()
        return self.direction


def markov_streets(experiments=1000, extra=True, as_is_North=True):
    directions = [driver(extra=extra).drive() for _ in range(experiments)]
    counts = dict(zip(list(directions),
                      [list(directions).count(i) for i in list(directions)]))
    if as_is_North:
        return counts[0]/experiments
    else:
        return counts


if __name__ == "__main__":
    print(markov_streets())
