package main

import (
	"io/ioutil"
	"strconv"
	"strings"

	"github.com/jdmoody/advent-of-code/intcode_computer"
)

func main() {
	input, _ := ioutil.ReadFile("./input.txt")
	var stringOpcodes []string = strings.Split(string(input), ",")
	var opcodes []int

	for _, stringCode := range stringOpcodes {
		code, _ := strconv.Atoi(stringCode)
		opcodes = append(opcodes, code)
	}
	opcodes[1] = 12
	opcodes[2] = 2

	type Operation int

	const (
		Add Operation = iota
		Multiply
	)

	var op Operation
	var a int
	var b int

Loop:
	for i, code := range opcodes {
		var c, _ = strconv.Atoi(code)

		switch i % 4 {
		case 0:
			switch code {
			case "99":
				break Loop
			case "1":
				op = Add
			case "2":
				op = Multiply
			default:
				println("ERROR")
			}
		case 1:
			a, _ = strconv.Atoi(opcodes[c])
		case 2:
			b, _ = strconv.Atoi(opcodes[c])
		case 3:
			switch op {
			case Add:
				opcodes[c] = strconv.Itoa(a + b)
			case Multiply:
				opcodes[c] = strconv.Itoa(a * b)
			}
		}
	}

	println(opcodes[0])
}
