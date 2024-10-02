resource "random_integer" "random_int" {
  min = 100
  max = 1000
}

resource "local_file" "local_res_imp" {
  filename = "implicit.txt"
  content  = "This is random number from random integer ${random_integer.random_int.id}"
}

#Explicit

resource "random_string" "rand_str" {
  length = 25
}

resource "local_file" "loca_Res_Exp" {
    filename = "explicit.txt"
    content = "this is random id ${random_string.rand_str.id}"
    depends_on = [ 
        random_string.rand_str
     ]
  
}