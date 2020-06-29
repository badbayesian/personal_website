package main

import (
	"bufio"
	"fmt"
	"math/rand"
	"os"
	"strconv"
	"strings"
	"sync"
)

const usage = "Usage: Driver <extra> <interval> <threads>\n" +
	"\textra = extra credit case\n" +
	"\tinterval = the number of iterations to perform\n" +
	"\tthreads = the number of threads (i.e., goroutines to spawn)\n"

type Driver struct {
	Direction int
	Extra     bool
	Rounds    int
}

// Driver logic on how to turn at intersectio
func (driver Driver) Turn() int {
	if driver.Extra == true {
		switch driver.Direction {
		case 0:
			driver.Direction = [3]int{1, 0, 3}[rand.Intn(3)]
		case 1:
			driver.Direction = [3]int{0, 2, 1}[rand.Intn(3)]
		case 2:
			driver.Direction = [3]int{2, 1, 3}[rand.Intn(3)]
		case 3:
			driver.Direction = [3]int{0, 3, 2}[rand.Intn(3)]
		}
	} else {
		switch driver.Direction {
		case 0, 2:
			driver.Direction = [2]int{1, 3}[rand.Intn(2)]
		case 1, 3:
			driver.Direction = [2]int{0, 2}[rand.Intn(2)]
		}
	}
	return driver.Direction
}

// Driver for turns the driver will take
func (driver Driver) Drive() int {
	for i := 0; i < driver.Rounds; i++ {
		driver.Direction = driver.Turn()
	}
	return driver.Direction
}

// Driver for markov Street experiment
func markovStreet(extra bool, work *float64, markovStreetResults *float64,
	cores *sync.WaitGroup) {
	count := 0
	for i := 0; i < int(*work); i++ {
		driver := Driver{
			Direction: 0,
			Extra:     extra,
			Rounds:    10}
		final_direction := driver.Drive()
		if final_direction == 0 {
			count++
		}

	}
	*markovStreetResults = float64(count)
	cores.Done()
}

func main() {
	var cores sync.WaitGroup

	fmt.Print(usage)

	scanner := bufio.NewScanner(os.Stdin)
	if scanner.Scan() {
		input := strings.Split(scanner.Text(), " ")
		extra, _ := strconv.Atoi(input[0])
		interval, _ := strconv.Atoi(input[1])
		threads, _ := strconv.Atoi(input[2])
		workPerThread := float64(interval) / float64(threads)
		resultsPerThread := make([]float64, threads)

		cores.Add(threads)
		for t := 0; t < threads; t++ {
			go markovStreet(extra == 1, &workPerThread,
				&resultsPerThread[t], &cores)
		}
		cores.Wait()

		total := 0.0
		for t := 0; t < threads; t++ {
			total += resultsPerThread[t]
		}
		fmt.Println(total / float64(interval))
	}
}
