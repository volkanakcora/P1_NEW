resource "random_integer" "random_int" {
    min = 0
    max = 100
}

output "result1" {
    value = random_integer.random_int.result
  
}

resource "local_file" "learning_tf" {
  filename        = "terraform  .txt"
  content         = random_integer.random_int.result
  file_permission = "0700"
}

resource "random_string" "random_string" {
    length = 5
    lower = false
    special = false
}

resource "random_password" "pass" {
    length = 10
    special = true
}

resource "local_file" "password" {
    filename = "password.txt"
    content = random_password.pass.result
}