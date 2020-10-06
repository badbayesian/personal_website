package main

import "sync"

type GraphMap struct {
	lock     *sync.RWMutex
	edges    map[string]map[string]int32
	vertices map[string]int32
}

type Graph struct {
}
