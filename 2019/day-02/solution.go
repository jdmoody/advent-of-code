package main

import (
	"github.com/jdmoody/advent-of-code/2019/intcode"
)

func main() {
	var opcodes = intcode.GetOpcodes("day-02")
	opcodes[1] = 12
	opcodes[2] = 2

	var computer intcode.Computer = intcode.New(opcodes)

	computer.Run()
	println(computer.Get(0))

Loop:
	for noun := 0; noun < 100; noun++ {
		for verb := 0; verb < 100; verb++ {
			var ops = intcode.GetOpcodes("day-02")
			ops[1] = noun
			ops[2] = verb
			computer.Reset(ops)

			computer.Run()

			if computer.Get(0) == 19690720 {
				println(100*noun + verb)
				break Loop
			}
		}
	}
}
