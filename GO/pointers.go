var p *string
var s = "my string"

p = &s



var p = new(string)
var s = "my string"

*p = s



var s = "some string variable" // var s of the type string
var p = &s                     // var p is a pointer to a string

fmt.Println(s) // Printing the value
fmt.Println(p) // Printing the address where the value is stored



var p = new(string)
fmt.Println(p)  // Will print some memory address, for eg. 0xc000040240
                // This address can be different in your case

fmt.Printf("%#v", *p) // Will print the actual value: "" an empty string


// advanced usage:
var s = "yes, it is possible"
var p1 = &s
var p2 = &p1

fmt.Println(*p2 == p1) // Will print true
fmt.Println(**p2 == s) // Will print true