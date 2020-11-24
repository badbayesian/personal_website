package main

import (
	"fmt"
	"math/rand"
	"sync"
	"time"
)

func all(bools []bool) bool {
	for _, v := range bools {
		if !v {
			return false
		}
	}
	return true
}

func simulation(n int) int {
	visited := make([]bool, n)
	visited[0] = true
	pos, lastPos := 0, 0
	for !all(visited) {
		direction := (rand.Intn(2) * 2) - 1
		lastPos = (((pos + direction) % n) + n) % n
		pos = lastPos
		visited[lastPos] = true
	}
	return lastPos
}

func ixMax(values []float64) int {
	ix := 0
	val := -1.0
	for i, v := range values {
		if v > val {
			ix, val = i, v
		}
	}
	return ix
}

func main() {
	rand.Seed(time.Now().Unix())
	var cores = sync.WaitGroup
	threads := 4
	n := 20
	rounds := 1000000
	count := make([]int, n)

	for i := 0; i < rounds; i++ {
		count[simulation(n)]++
	}
	freq := make([]float64, n)
	for i, num := range count {
		freq[i] = float64(num) / float64(rounds)
	}
	fmt.Println(ixMax(freq), freq)
}
