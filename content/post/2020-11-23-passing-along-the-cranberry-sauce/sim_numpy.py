"""Numpy version of cranberry sauce passing"""
import argparse
from typing import List
import numpy as np


def simulation(size: int) -> int:
    """Simulate one round of cranberry sauce passing."""
    visited = np.zeros(size, dtype=bool)
    visited_count = 1
    visited[0] = True
    pos, last_pos = 0, 0
    while visited_count != size:
        direction = np.random.randint(2, dtype=int) * 2 - 1
        last_pos = (pos + direction) % size
        pos = last_pos
        if not visited[last_pos]:
            visited_count += 1
            visited[last_pos] = True
    return last_pos


def main(size: int, rounds: int) -> List[float]:
    """Rounds driver."""
    count = np.zeros(size, dtype=int)
    for _ in range(rounds):
        count[simulation(size)] += 1

    return [i / rounds for i in count]


if __name__ == "__main__":
    arg = argparse.ArgumentParser()
    arg.add_argument("-size", type=int, required=True)
    arg.add_argument("-rounds", type=int, required=True)
    arg.add_argument("-v", type=bool, default=False)
    args = arg.parse_args()
    results = main(size=args.size, rounds=args.rounds)
    if args.v:
        print(results)
