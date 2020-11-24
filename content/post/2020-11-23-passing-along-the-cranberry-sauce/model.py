import numpy as np


def simulation(n: int):
    visited = np.zeros(n, dtype=bool)
    visited[0] = True
    pos, last_pos = 0, 0
    while not all(visited):
        direction = np.random.choice((-1, 1))
        last_pos = (pos + direction) % n
        pos = last_pos
        visited[last_pos] = True
    return last_pos


def main():
    n = 20
    rounds = 10000
    count = np.zeros(n, dtype=int)
    for _ in range(rounds):
        count[simulation(n)] += 1

    freq = [i / rounds for i in count]
    print(freq.index(max(freq)), freq)


if __name__ == "__main__":
    main()
