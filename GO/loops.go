var condition bool

for condition {
    // here is the body of the loop
}

for true {
    // here is the body of an infinite loop
}

for {
    // here is the body of an infinite loop
}

var a, b int

for a < b {
    // here is the body of the loop
}


// Using loops

var i int           // initializing the i variable as a counter

for i < 10 {        // initializing a loop with the condition i < 10
    // some code
    i++             // incrementing the counter at the end of the body
}                                   

for i := 0; i < 10; i++ { 
    // some code
}

var i = 10    // Declaring the i variable in the outer scope

for i := 0; i < 1; i++ {  // Declaring the i variable in the inner(loop) scope
    fmt.Print(i)          // Will print 0, not 10
}



// Flow of control

var sum int           // step 1
var i int             // step 2
                      
for ; i < 50; i++ {   // step 3, 4, 8; you can have a sparse loop declaration
    if sum > 100 {    // step 5  
        break         // step 5
    }
    if i % 2 == 0 {   // step 6                
        continue      // step 6
    }                 
    sum += i          // step 7
}                     // step 9
                      // step 10