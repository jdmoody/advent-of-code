package main

import (
	"io/ioutil"
	"strconv"
	"strings"
)

func calcFuel(mass int) int {
	if mass < 7 {
		return 0
	}

	fuel := (mass / 3) - 2
	return fuel + calcFuel(fuel)
}

func main() {
	input, _ := ioutil.ReadFile("./input.txt")
	masses := strings.Split(string(input), "\n")

	totalFuel := 0
	for _, m := range masses {
		mass, _ := strconv.Atoi(m)
		totalFuel += calcFuel(mass)
	}
	println(totalFuel)
}
