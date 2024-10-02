// Declaring a variable
// You can use the var keyword, followed by the variable name and type to declare a variable in Go:


var variableName variableType

var i int     // 0
var f float64 // 0 
var b bool    // false 
var s string  // ""


var firstNum int = 1
var secondNum int = 2
var sum int = firstNum + secondNum
var secondNum = 20 // Skipping the type
//You can also use := in statements. It is a declare and assign construction:

thirdNum := 30

// Note that the := operator is exclusively used to declare and assign new variables. It means that you cannot use it to reassign values to existing variables alone; doing so will lead to a compile-time error:
fourthNum := 30
fourthNum = 31  // OK — Assign a new value `31` to `fourthNum` 
fourthNum := 32 // compile-time error! This variable is already declared

//However, if you add a new variable, there will be no error:
fourthNum, fifthNum := 32, 33 // no compile-time error


// Declaring multiple variables
// You can declare multiple variables in a single statement. For example:
var isEnabled, hasValues, isOrdered bool

var (
    isEnabled bool
    hasValues bool
    isOrdered bool
    firstNum  int
    hello     string
)

// Constants
// Constants are similar to variables, except that the value of a constant cannot be changed after it is 
// declared. You can use the const keyword to declare a constant in Go:
const PI float64 = 3.14159265358979323846
const hubble int = 77

// You can declare a block of constants at once without having to specify a keyword before each constant:
const ( 
    hello = "Hello" 
    e = 2.718
)

//Constants have several advantages over variables. They make your code more readable and ensure that a specific value in the code remains unchanged

const HoursPerDay = 24
HoursPerDay = 25 // Cannot be assigned to `HoursPerDay`

// Iota
// The iota keyword is a predeclared constant. It is used to generate a sequence of integer
// The iota keyword is a handy auto-increment that generates constants. It constructs a set of related but distinct constants starting from 0.

const (
    A = iota  // 0
    B = iota  // 1
    C = iota  // 2
)

// This step can be simplified as follows:

const (
	A = iota
	B
	C
)

//It is also possible to skip values of iota via the _ = iota syntax; however, take notice that only the underscore _ character will skip the value. For example, suppose you wanted to skip the 0 and 2 values:
const (
    _ = iota // Skip 0
    A        // 1
    _        // Skip 2
    B        // 3
    C        // 4
)

// A simple use case for iota would be if you wanted to define a constant for each day of the week. In this case, you want them all to be constants with different values. However, it doesn't matter what exact value each constant has as long as Monday is different from Tuesday, which is different from Wednesday, and so on. You can write it the following way:

	const (
		Monday    = iota + 1 // Start from 1 instead of 0
		Tuesday              // 2
		Wednesday            // 3
		Thursday             // 4
		Friday               // 5
		Saturday             // 6
		Sunday               // 7
	)