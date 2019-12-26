package main

func isValid(i int) bool {
	secondPrevDigit := -1
	prevDigit := -1
	hasPair := false

	smallestDigit := 10

	for n := i; n > 0; n /= 10 {
		digit := n % 10
		nextDigit := (n / 10) % 10

		if digit == prevDigit && prevDigit != secondPrevDigit && nextDigit != digit {
			hasPair = true
		}
		secondPrevDigit = prevDigit
		prevDigit = digit

		if digit > smallestDigit {
			return false
		}
		smallestDigit = digit
	}

	return hasPair
}

func main() {
	passwords := 0
	for i := 134792; i <= 675810; i++ {
		if isValid(i) {
			passwords++
		}
	}

	println(passwords)
}
