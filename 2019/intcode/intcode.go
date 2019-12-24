package intcode

// Instruction - Returns true if the computer should continue, false if it should halt
type Instruction func(computer *Computer) bool
type instructions map[int]Instruction

// Computer - An intcode computer consisting of an array of integers and a list of instructions
type Computer struct {
	instructionPointer int
	instructions       instructions
	memory             []int
}

// Run - Runs the IntcodeComputer returns true if successfully halted, otherwise returns false
func (computer *Computer) Run() bool {
	for {
		var code = computer.ReadNext()
		instruction, found := computer.instructions[code]

		if !found {
			println("Instruction Not Found: ", code)
			return false
		}

		// Increment the instructionPointer based on how many arguments were used
		var halt = !instruction(computer)
		if halt {
			return true
		}
	}
}

// ReadNext - Returns the next value in the memory
func (computer *Computer) ReadNext() int {
	var next = computer.memory[computer.instructionPointer]
	computer.instructionPointer++

	return next
}

// Get - Returns the value of a memory address
func (computer *Computer) Get(address int) int {
	return computer.memory[address]
}

// Set - Sets the value of a memory address
func (computer *Computer) Set(address int, value int) {
	computer.memory[address] = value
}

// Reset - Resets the memory
func (computer *Computer) Reset(newMemory []int) {
	computer.instructionPointer = 0
	computer.memory = newMemory
}

// New - Creates a new intcode Computer
func New(memory []int, instructions instructions) Computer {
	return Computer{
		instructionPointer: 0,
		instructions:       instructions,
		memory:             memory,
	}
}
