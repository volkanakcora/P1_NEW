resource "google_storage_bucket" "busket-from-terraform" {
    name = "busket-from-terraform"
    location = "US"
    storage_class = "STANDARD"
    uniform_bucket_level_access = true
}