package main

import (
	"io/ioutil"
	"strconv"
	"strings"
)

func travel(pos [2]int, direction rune) [2]int {
	switch direction {
	case 'D':
		return [2]int{pos[0], pos[1] - 1}
	case 'L':
		return [2]int{pos[0] - 1, pos[1]}
	case 'R':
		return [2]int{pos[0] + 1, pos[1]}
	case 'U':
		return [2]int{pos[0], pos[1] + 1}
	default:
		return pos
	}
}

func abs(x int) int {
	if x < 0 {
		return -x
	}
	return x
}

func main() {
	input, _ := ioutil.ReadFile("./input.txt")

	wires := strings.Split(string(input), "\n")
	firstWire := strings.Split(string(wires[0]), ",")
	secondWire := strings.Split(string(wires[1]), ",")

	var wireMap = map[[2]int]int{}

	steps := 0
	pos := [2]int{0, 0}
	for _, segment := range firstWire {
		direction := []rune(segment)[0]
		fullLength, _ := strconv.Atoi(segment[1:])

		for length := 0; length < fullLength; length++ {
			steps++
			pos = travel(pos, direction)
			wireMap[pos] = steps
		}
	}

	steps = 0
	pos = [2]int{0, 0}
	closestDist := -1
	fewestSteps := -1
	for _, segment := range secondWire {
		direction := []rune(segment)[0]
		fullLength, _ := strconv.Atoi(segment[1:])

		for length := 0; length < fullLength; length++ {
			steps++
			pos = travel(pos, direction)

			prevSteps, intersected := wireMap[pos]
			if !intersected {
				continue
			}

			newDist := abs(pos[0]) + abs(pos[1])
			if closestDist == -1 || closestDist > newDist {
				closestDist = newDist
			}

			newSteps := steps + prevSteps
			if fewestSteps == -1 || fewestSteps > newSteps {
				fewestSteps = newSteps
			}
		}
	}

	println(closestDist)
	println(fewestSteps)
}
