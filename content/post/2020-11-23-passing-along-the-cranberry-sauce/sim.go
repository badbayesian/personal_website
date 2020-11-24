package main

import (
	"flag"
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

func main() {
	rand.Seed(time.Now().Unix())

	var size = flag.Int("size", 20, "")
	var rounds = flag.Int("rounds", 10000, "")
	var threads = flag.Int("threads", 4, "Number of threads")
	flag.Parse()

	var cores sync.WaitGroup
	count := make([][]int, *threads)
	for i := 0; i < *threads; i++ {
		count[i] = make([]int, *size)
	}

	cores.Add(*threads)
	for t := 0; t < *threads; t++ {
		go func(t int) {
			for i := 0; i < *rounds; i++ {
				count[t][simulation(*size)]++
			}
			cores.Done()
		}(t)
	}
	cores.Wait()

	freq := make([]float64, *size)
	for _, num := range count {
		for i, val := range num {
			freq[i] += float64(val)
		}
	}
	for i := range freq {
		freq[i] /= float64(*rounds * *threads)
	}
	fmt.Println(freq)
}
