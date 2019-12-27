package main

import (
	"io/ioutil"
	"strings"
)

type mass struct {
	parent   string
	children map[string]bool
}
type orbitMap map[string]*mass

func buildOrbits(orbitsList []string) orbitMap {
	root := orbitMap{}

	for _, orbit := range orbitsList {
		masses := strings.Split(orbit, ")")
		parent := masses[0]
		child := masses[1]

		_, parentFound := root[parent]
		if !parentFound {
			root[parent] = &mass{
				parent:   "",
				children: map[string]bool{},
			}
		}
		root[parent].children[child] = true

		_, childFound := root[child]
		if !childFound {
			root[child] = &mass{
				parent:   "",
				children: map[string]bool{},
			}
		}
		root[child].parent = parent
	}

	return root
}

func countOrbits(orbits orbitMap, mass string, initCount int) int {
	count := initCount

	for orbiter := range orbits[mass].children {
		count += countOrbits(orbits, orbiter, initCount+1)
	}

	return count
}

func findMinTransfers(orbits orbitMap) int {
	youPath := map[string]int{}
	youParent := orbits["YOU"].parent
	youSteps := 0
	for youParent != "" {
		youPath[youParent] = youSteps

		youParent = orbits[youParent].parent
		youSteps++
	}

	sanParent := orbits["SAN"].parent
	sanSteps := 0
	for sanParent != "" {
		youSteps, found := youPath[sanParent]

		if found {
			return youSteps + sanSteps
		}

		sanParent = orbits[sanParent].parent
		sanSteps++
	}

	return 0
}

func main() {
	input, _ := ioutil.ReadFile("./input.txt")
	orbitsList := strings.Split(string(input), "\n")

	orbits := buildOrbits(orbitsList)
	println("Total Orbits: ", countOrbits(orbits, "COM", 0))
	println("Minimum Transfers: ", findMinTransfers(orbits))
}
