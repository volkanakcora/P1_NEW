package main

import "fmt"

func main() {
    var score int // Your test score goes here.

	fmt.Print("Enter your score")
	fmt.Scan(&score)

    if score > 90 {
        fmt.Println("Your grade is A. Congratulations!")
    } else if score > 80 {
        fmt.Println("Your grade is B. Good enough.")
    } else if score > 70 {
        fmt.Println("Your grade is C. Could've done better!")
    } else if score > 60 {
        fmt.Println("Your grade is D. Study more next time!")
    } else {
        fmt.Println("Your grade is F. Terrible! you failed the test!")
    }
}
