data "local_file" "data1" {
    filename = "example.txt"
}

output "name1" {
    value = data.local_file.data1.content
}