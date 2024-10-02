package main

import "fmt"

func main() {
    var name string
    var age int

    fmt.Print("Enter your name: ") // Writing a request message to the stdout 
    fmt.Scan(&name)                // Reading from the stdin into the name variable
    fmt.Println("")                // Going to the next line by writing /n to the stdout 

    fmt.Print("Enter your age: ")  // Writing a request message to the stdout
    fmt.Scan(&age)                 // Reading from the stdin into the age variable
    fmt.Println("")                // Going to the next line by writing /n to the stdout

    fmt.Print(name, age)           // Writing to the stdout the values of name and
                                   // age variables that you have entered 
}