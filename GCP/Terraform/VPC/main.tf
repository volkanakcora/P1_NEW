resource "google_compute_network" "auto-vpc-tf" {
    name = "auto-vpc_tf"
    auto_create_subnetworks = true
}

resource "google_compute_network" "custom-vpc-tf" {
    name = "custom-vpc-tf"
    auto_create_subnetworks = false 
}

resource "google_compute_subnetwork" "asia-southeast1-subnet" {
    name = "asia-southeast1-subnet"
    network = google_compute_network.custom-vpc-tf.id
    region = "asia-southeast1"
    ip_cidr_range = "10.1.0.0/24"
    private_ip_google_access = true
}

output "auto" {
    value = google_compute_network.auto-vpc-tf.id
}

output "custom" {
    value = google_compute_network.custom-vpc-tf.id
}
