// The Hello, World! program
// To begin working with I/O, let's introduce a simple Go program.

// Every .go file has this generic layout:

// Package clause

// Import declarations (optional)

// Actual code

// To compile and run your project, you need at least one .go file belonging to the main package with the main function. This function is an entry point for your application. We will use only one .go file in this topic — the main.go file.

// We'll start with the famous Hello, World! program:


package main

import fmt

func main() {
    fmt.Print("Hello, World!")
}

// Print functions can also take several arguments and display them with space separation:
var boolean = true
var integer = 1023493
var str = "my string"
var float = 12.4
var character = 'A'

fmt.Println(boolean, integer, str, float, character)

// Output:
// true 1023493 my string 12.4 65


// # Reading the input

// So far, we have only worked with sending data to the stdout. Now, let's see how we can obtain data from the standard input or stdin. The fmt.Scan function will help us with that

var name string

fmt.Scan(&name)   // Reading a string from the stdin into the name variable
fmt.Println(name) // Writing to the stdout the name you've entered 
                  // in the previous step

// Be aware of how the Scan function works with different types of variables:

var foo int    // foo is 0
var str string // string is ""

fmt.Scan(&foo) // If you enter a string character, the scan function
               // will leave the variable foo unchanged

fmt.Scan(&str) // If you enter an integer, it will be taken as a string
               // and assigned to the variable str

// Often we will need to read several values at once. In this case, we define variables and then pass 
// their pointers to Scan, separating them by a comma. In the example below, if we enter Alex 21, it'll first break the string into Alex and 21. 
// Then, it will assign the former to the name variable and the latter to the age variable. You can play around with it, entering different strings:

var name string
var age string

fmt.Scan(&name, &age) // Reading from the stdin into the name and age variables

fmt.Println(name)     // Writing to the stdout the value of the name variable    
fmt.Println(age)      // Writing to the stdout the value of the age variable     

