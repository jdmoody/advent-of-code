package main

import (
	"github.com/jdmoody/advent-of-code/2019/intcode"
)

func debugPrint(p ...interface{}) {
	if false {
		println(p)
	}
}

func startAmp(phase int, signal int, computer *intcode.Computer) {
	opcodes := intcode.GetOpcodes("day-07")
	computer.Reset(opcodes, phase, signal)
	computer.Run()
}

type phases [5]int

func runAmps(phases phases, computer *intcode.Computer) int {
	signal := 0
	for amp := 0; amp < len(phases); amp++ {
		startAmp(phases[amp], signal, computer)
		signal = computer.GetOutput()
	}

	return signal
}

func perm(p phases, f func(phases), i int) {
	if i > len(p) {
		f(p)
		return
	}
	perm(p, f, i+1)
	for j := i + 1; j < len(p); j++ {
		p[i], p[j] = p[j], p[i]
		perm(p, f, i+1)
		p[i], p[j] = p[j], p[i]
	}
}

func main() {
	computer := intcode.New([]int{})

	maxSignal := -1
	perm([5]int{0, 1, 2, 3, 4}, func(phases phases) {
		output := runAmps(phases, &computer)

		if output > maxSignal {
			maxSignal = output
		}
	}, 0)

	println("Max Signal: ", maxSignal)
}
