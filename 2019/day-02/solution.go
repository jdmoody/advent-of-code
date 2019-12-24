package main

import (
	"io/ioutil"
	"strconv"
	"strings"

	"github.com/jdmoody/advent-of-code/2019/intcode"
)

func getOpcodes() []int {
	input, _ := ioutil.ReadFile("./input.txt")
	var stringOpcodes []string = strings.Split(string(input), ",")
	var opcodes []int

	for _, stringCode := range stringOpcodes {
		code, _ := strconv.Atoi(stringCode)
		opcodes = append(opcodes, code)
	}

	return opcodes
}

func main() {
	var opcodes = getOpcodes()
	opcodes[1] = 12
	opcodes[2] = 2

	var computer intcode.Computer = intcode.New(opcodes, map[int]intcode.Instruction{
		1: func(computer *intcode.Computer) bool {
			var a = computer.ReadNext()
			var b = computer.ReadNext()
			var resultAddr = computer.ReadNext()

			computer.Set(resultAddr, computer.Get(a)+computer.Get(b))

			return true
		},
		2: func(computer *intcode.Computer) bool {
			var a = computer.ReadNext()
			var b = computer.ReadNext()
			var resultAddr = computer.ReadNext()

			computer.Set(resultAddr, computer.Get(a)*computer.Get(b))

			return true
		},
		99: func(computer *intcode.Computer) bool {
			return false
		},
	})

	computer.Run()
	println(computer.Get(0))

Loop:
	for noun := 0; noun < 100; noun++ {
		for verb := 0; verb < 100; verb++ {
			var ops = getOpcodes()
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
