resource "random_integer" "rand_int" {
  min = 50
  max = 200

  lifecycle {
    create_before_destroy = true
  }
}

output "name1" {
  value = random_integer.rand_int.result
}
