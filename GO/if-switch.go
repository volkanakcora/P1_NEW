package main

import "fmt"

func main() {
    var selection string  // Your selection goes here.

	fmt.Print("Enter your selection")
	fmt.Scanln(&selection)
	fmt.Println(selection)

    switch selection {
    case "new":
        fmt.Println("Starting a new game!")
        
    case "load":
        fmt.Println("Loading a saved game.")
        
    case "exit":
        fmt.Println("Exit the game.")
        
    default:
        fmt.Println("Invalid selection. Try again.")
    }
}

package main

import "fmt"

func main() {
    var number int = ... // Your number goes here.

    switch { // Equivalent to `switch true`
    case number % 2 == 0:
        fmt.Println("The number", number, "is even")
    case number % 2 != 0:
        fmt.Println("The number", number, "is odd")
    }
}