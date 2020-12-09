"""Numpy version of cranberry sauce passing"""
import argparse
from typing import List
import numpy as np
from numba import njit, bool_, int64, prange


@njit(parallel=True)
def simulation(size: int, prealloc_size: int) -> int:
    """Simulate one round of cranberry sauce passing."""
    visited = np.zeros(size, dtype=bool_)
    visited_count = 1
    visited[0] = True
    pos, last_pos = 0, 0
    i = 0
    direction = [np.random.randint(2) * 2 - 1 for _ in range(prealloc_size)]
    while visited_count != size:
        if i < size:
            last_pos = (pos + direction[i]) % size
        else:
            i = 0
            direction = [np.random.randint(2) * 2 - 1 for _ in range(prealloc_size)]
            last_pos = (pos + direction[i]) % size
        i += 1
        pos = last_pos
        if not visited[last_pos]:
            visited_count += 1
            visited[last_pos] = True
    return last_pos


@njit(parallel=True)
def main(size: int, rounds: int, threads: int, prealloc_size: int) -> List[float]:
    """Parallel and rounds driver."""
    count = np.zeros(size, dtype=int64)
    if threads == 1:
        for _ in range(rounds):
            count[simulation(size, prealloc_size)] += 1
    else:
        count2d = np.zeros((threads, size), dtype=int64)
        for i in prange(threads):
            for _ in range(rounds):
                count2d[i, simulation(size, prealloc_size)] += 1
        count = np.sum(count2d, axis=0)

    freq = [i / (rounds * threads) for i in count]
    return freq


if __name__ == "__main__":
    arg = argparse.ArgumentParser()
    arg.add_argument("-size", type=int, required=True)
    arg.add_argument("-rounds", type=int, required=True)
    arg.add_argument("-threads", type=int, required=True)
    arg.add_argument("-prealloc_size", type=int, required=True)
    arg.add_argument("-v", type=bool, default=False)
    args = arg.parse_args()
    results = main(
        size=args.size,
        rounds=args.rounds,
        threads=args.threads,
        prealloc_size=args.prealloc_size,
    )
    if args.v:
        print(results)
