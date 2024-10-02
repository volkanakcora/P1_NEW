resource "local_file" "example_resource" {
  filename        = "volkan.txt"
  content         = "Master terraform with GCP"
  file_permission = "0700"
}

resource "local_file" "learning_tf" {
  filename        = "terraform  .txt"
  content         = "Learning the GCP"
  file_permission = "0700"
}
