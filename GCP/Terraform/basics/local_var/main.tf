locals {
  content_question = "How much do you pay?"
}

resource "local_file" "learning_tf" {
    filename = "terraform.txt"
    content = "${local.content_question}"
}

output "learning_tf" {
    value = local_file.learning_tf.content
  
}