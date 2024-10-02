variable "fname" {
  type        = string
  default     = "example.txt"
  description = "This path to the file that will be created"
}

variable "cont" {
  type    = string
  default = "Master Terraform with GCP"
}

variable "f_perms" {
  type    = string
  default = "0777"
}

variable "input_zones" {
  type    = list(any)
  default = ["us-west-1a", "us-west-1c", "us-west-1d", "us-west-1e"]
}

variable "integrer" {
    type = number
    default = 2024
}

variable "iambool" {
    type = bool
    default = false
}

variable "list" {
    type = list(string)
    default = [ "aws", "gcp"]
}