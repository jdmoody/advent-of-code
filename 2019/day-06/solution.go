package main

import (
	"io/ioutil"
	"strings"
)

type orbitMap map[string]map[string]bool

func buildOrbits(orbitsList []string) orbitMap {
	root := orbitMap{}

	for _, orbit := range orbitsList {
		masses := strings.Split(orbit, ")")
		center := masses[0]
		orbiter := masses[1]

		_, found := root[center]

		if !found {
			root[center] = map[string]bool{}
		}
		root[center][orbiter] = true
	}

	return root
}

func countOrbits(orbits orbitMap, mass string, initCount int) int {
	count := initCount

	for orbiter := range orbits[mass] {
		count += countOrbits(orbits, orbiter, initCount+1)
	}

	return count
}

func main() {
	input, _ := ioutil.ReadFile("./input.txt")
	orbitsList := strings.Split(string(input), "\n")

	orbits := buildOrbits(orbitsList)

	println(countOrbits(orbits, "COM", 0))
}
