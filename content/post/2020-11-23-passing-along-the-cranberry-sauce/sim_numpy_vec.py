"""Numpy version of cranberry sauce passing"""
import argparse
from typing import List
import numpy as np


def simulation(size: int, prealloc_size: int) -> int:
    """Simulate one round of cranberry sauce passing."""
    visited = np.zeros(size, dtype=bool)
    visited_count = 1
    visited[0] = True
    pos, last_pos = 0, 0
    i = 0
    direction = np.random.randint(2, size=prealloc_size, dtype=int) * 2 - 1
    while visited_count != size:
        try:
            last_pos = (pos + direction[i]) % size
        except IndexError:
            i = 0
            direction = np.random.randint(2, size=prealloc_size, dtype=int) * 2 - 1
            last_pos = (pos + direction[i]) % size
        i += 1
        pos = last_pos
        if not visited[last_pos]:
            visited_count += 1
            visited[last_pos] = True
    return last_pos


def main(size: int, rounds: int, prealloc_size: int) -> List[float]:
    """Rounds driver."""
    count = np.zeros(size, dtype=int)
    for _ in range(rounds):
        count[simulation(size, prealloc_size)] += 1

    return [i / rounds for i in count]


if __name__ == "__main__":
    arg = argparse.ArgumentParser()
    arg.add_argument("-size", type=int, required=True)
    arg.add_argument("-rounds", type=int, required=True)
    arg.add_argument("-prealloc", type=int, require=True)
    arg.add_argument("-v", type=bool, default=False)
    args = arg.parse_args()
    results = main(size=args.size, rounds=args.rounds, prealloc_size=args.prealloc_size)
    if args.v:
        print(results)
