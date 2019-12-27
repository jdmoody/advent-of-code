package main

import (
	"github.com/jdmoody/advent-of-code/2019/intcode"
)

func main() {
	opcodes := intcode.GetOpcodes("day-05")

	var computer intcode.Computer = intcode.New(opcodes, 5)

	computer.Run()
}
