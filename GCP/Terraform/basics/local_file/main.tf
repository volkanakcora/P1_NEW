resource "local_file" "example_resource" {
    filename = "volkan.txt"
    content = "Master terraform with GCP"
    file_permission = "0700"
}