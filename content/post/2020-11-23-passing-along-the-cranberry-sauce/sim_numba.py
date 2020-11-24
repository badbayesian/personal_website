"""Numba version of cranberry sauce passing"""
import argparse
from typing import List
import numpy as np
from numba import njit, bool_, int64, prange


@njit(parallel=True)
def simulation(size: int) -> int:
    """Simulate one round of cranberry sauce passing."""
    visited = np.zeros(size, dtype=bool_)
    visited[0] = True
    pos, last_pos = 0, 0
    while not np.all(visited):
        direction = np.random.randint(2) * 2 - 1
        last_pos = (pos + direction) % size
        pos = last_pos
        visited[last_pos] = True
    return last_pos


@njit(parallel=True)
def main(size: int, rounds: int, threads: int) -> List[float]:
    """Parallel and rounds driver."""
    count = np.zeros(size, dtype=int64)
    if threads == 1:
        for _ in range(rounds):
            count[simulation(size)] += 1
    else:
        count2d = np.zeros((threads, size), dtype=int64)
        for i in prange(threads):
            for _ in range(rounds):
                count2d[i, simulation(size)] += 1
        count = np.sum(count2d, axis=0)

    freq = [i / (rounds * threads) for i in count]
    return freq


if __name__ == "__main__":
    arg = argparse.ArgumentParser()
    arg.add_argument("-size", type=int, required=True)
    arg.add_argument("-rounds", type=int, required=True)
    arg.add_argument("-threads", type=int, required=True)
    args = arg.parse_args()
    results = main(size=args.size, rounds=args.rounds, threads=args.threads)
    print(results)
