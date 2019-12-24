package intcodecomputer

import (
	"reflect"
)

// Returns true if the computer should continue, false if it should halt
type instruction func(memory []int, args ...int) bool
type instructions map[int]instruction

// IntcodeComputer - A computer consisting of an array of integers and a list of instructions
type IntcodeComputer struct {
	instructionPointer int
	instructions       instructions
	memory             []int
}

// Run - Runs the IntcodeComputer returns true if successfully halts, otherwise returns false
func (computer *IntcodeComputer) Run() bool {
	for _, code := range computer.memory {
		instruction, found := computer.instructions[code]

		if !found {
			println("Instruction Not Found: ", code)
			return false
		}

		// Figure out how many arguments the current instruction takes
		instructionRef := reflect.ValueOf(instruction)
		numArgs := instructionRef.Type().NumIn()

		// Increment the instructionPointer based on how many arguments were used
		computer.instructionPointer += numArgs

		// Get the arguments from the memory and run the instruction
		var args = computer.memory[computer.instructionPointer : computer.instructionPointer+numArgs-1]
		var halt = !instruction(computer.memory, args...)
		if halt {
			return true
		}
	}

	println("Expected computer to halt before running through entire memory")
	return false
}

// New - Creates a new IntcodeComputer
func New(memory []int, instructions instructions) IntcodeComputer {
	return IntcodeComputer{
		instructionPointer: 0,
		instructions:       instructions,
		memory:             memory,
	}
}
