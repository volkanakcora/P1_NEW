package main

import "fmt"

func main() {  

	var number int

    fmt.Print("Enter your number: ")  // Writing a request message to the stdout
    fmt.Scan(&number)
	 // Reading from the stdin into the age variable
    fmt.Println("") 

	if number % 2 == 0 { // checks if the number is even
        fmt.Println("The number", number, "is even")
    } else {
		fmt.Println("The number", number, "is odd")
		}
}