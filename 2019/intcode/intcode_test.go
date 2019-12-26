package intcode

import (
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestBasicParameterMode(t *testing.T) {
	assert := assert.New(t)

	computer := New([]int{1002, 4, 3, 4, 33})
	computer.Run()

	assert.Equal(99, computer.Get(4))
}
