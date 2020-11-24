"""Numba version of cranberry sauce passing"""
import argparse
import numpy as np


def simulation(size: int):
    """Simulate one round of cranberry sauce passing."""
    visited = np.zeros(size, dtype=bool)
    visited[0] = True
    pos, last_pos = 0, 0
    while not np.all(visited):
        direction = np.random.randint(2) * 2 - 1
        last_pos = (pos + direction) % size
        pos = last_pos
        visited[last_pos] = True
    return last_pos


def main(size: int, rounds: int):
    """Rounds driver."""
    count = np.zeros(size, dtype=int)
    for _ in range(rounds):
        count[simulation(size)] += 1
    return count


if __name__ == "__main__":
    arg = argparse.ArgumentParser()
    arg.add_argument("-size", type=int, required=True)
    arg.add_argument("-rounds", type=int, required=True)
    args = arg.parse_args()
    print(main(size=args.size, rounds=args.rounds))
