package intcode

import (
	"bytes"
	"fmt"
	"io/ioutil"
	"math"
	"strconv"
	"strings"
)

type instruction func(computer *Computer) bool
type instructions map[int]instruction

var inst = map[int]instruction{
	1: func(computer *Computer) bool {
		var a = computer.getParam()
		var b = computer.getParam()
		var resultAddr = computer.readNext()

		computer.set(resultAddr, a+b)

		return true
	},
	2: func(computer *Computer) bool {
		var a = computer.getParam()
		var b = computer.getParam()
		var resultAddr = computer.readNext()

		computer.set(resultAddr, a*b)

		return true
	},

	// input
	3: func(computer *Computer) bool {
		var val int
		// println("Enter integer: ")
		if len(computer.inputs) > 0 {
			val = computer.inputs[0]
			// println(val)
			computer.inputs = computer.inputs[1:]
		} else {
			fmt.Scan(&val)
		}

		addr := computer.readNext()
		computer.set(addr, val)

		return true
	},

	// output
	4: func(computer *Computer) bool {
		addr := computer.getParam()
		fmt.Fprintln(&computer.output, addr)

		return true
	},

	// jump-if-true
	5: func(computer *Computer) bool {
		param := computer.getParam()

		val := computer.getParam()
		if param != 0 {
			computer.instructionPointer = val
		}

		return true
	},

	// jump-if-false
	6: func(computer *Computer) bool {
		param := computer.getParam()

		val := computer.getParam()
		if param == 0 {
			computer.instructionPointer = val
		}

		return true
	},

	// less than
	7: func(computer *Computer) bool {
		a := computer.getParam()
		b := computer.getParam()
		loc := computer.readNext()

		if a < b {
			computer.memory[loc] = 1
		} else {
			computer.memory[loc] = 0
		}

		return true
	},

	// equals
	8: func(computer *Computer) bool {
		a := computer.getParam()
		b := computer.getParam()
		loc := computer.readNext()

		if a == b {
			computer.memory[loc] = 1
		} else {
			computer.memory[loc] = 0
		}

		return true
	},
	99: func(computer *Computer) bool {
		return false
	},
}

type computerMode int

const (
	position computerMode = iota
	immediate
)

// Computer - An intcode computer consisting of an array of integers and a list of instructions
type Computer struct {
	instructionPointer int
	instructions       instructions
	memory             []int
	modes              []computerMode
	inputs             []int
	output             bytes.Buffer
}

// Run - Runs the IntcodeComputer returns true if successfully halted, otherwise returns false
func (computer *Computer) Run() bool {
	for {
		fullCode := computer.readNext()
		opcode := fullCode % 100

		computer.modes = []computerMode{}
		for paramLen := 1; paramLen < int(math.Log10(float64(fullCode))); paramLen++ {
			mode := computerMode(fullCode / int(math.Pow10(paramLen+1)) % 10)
			computer.modes = append(computer.modes, mode)
		}

		instruction, found := computer.instructions[opcode]

		if !found {
			println("Instruction Not Found: ", opcode)
			return false
		}

		// Run the instruction and halt if necessary
		var halt = !instruction(computer)
		if halt {
			return true
		}
	}
}

// Get - Returns the value of a memory address
func (computer *Computer) Get(address int) int {
	return computer.memory[address]
}

// GetOutput - Returns the current output buffer value
func (computer *Computer) GetOutput() int {
	var val int

	fmt.Sscan(computer.output.String(), &val)

	return val
}

// Reset - Resets the memory
func (computer *Computer) Reset(newMemory []int, inputs ...int) {
	computer.instructionPointer = 0
	computer.memory = newMemory
	computer.inputs = inputs
	computer.output = *bytes.NewBuffer([]byte{})
}

// readNext - Returns the next value in memory
func (computer *Computer) readNext() int {
	val := computer.memory[computer.instructionPointer]
	computer.instructionPointer++

	return val
}

// getParam - Returns a parameter based on the mode
func (computer *Computer) getParam() int {
	val := computer.readNext()

	var mode computerMode
	if len(computer.modes) > 0 {
		mode, computer.modes = computer.modes[0], computer.modes[1:]
	} else {
		mode = position
	}

	switch mode {
	case immediate:
		return val
	// default to position mode
	default:
		return computer.memory[val]
	}
}

// set - Sets the value of a memory address
func (computer *Computer) set(address int, value int) {
	computer.memory[address] = value
}

// New - Creates a new intcode Computer
func New(memory []int, inputs ...int) Computer {
	return Computer{
		instructionPointer: 0,
		instructions:       inst,
		memory:             memory,
		modes:              []computerMode{},
		inputs:             inputs,
		output:             *bytes.NewBuffer([]byte{}),
	}
}

// GetOpcodes - Retrieves opcodes from a file
func GetOpcodes(day string) []int {
	input, _ := ioutil.ReadFile("../" + day + "/input.txt")
	var stringOpcodes []string = strings.Split(string(input), ",")
	var opcodes []int

	for _, stringCode := range stringOpcodes {
		code, _ := strconv.Atoi(stringCode)
		opcodes = append(opcodes, code)
	}

	return opcodes
}
