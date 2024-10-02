resource "local_file" "example_resource" {
    filename = var.fname
    content = var.cont
    file_permission = var.f_perms
}

resource "random_shuffle" "random_shuffle" {
    input = var.input_zones
}

output "result_zones_output" {
    value = random_shuffle.random_shuffle.result
}