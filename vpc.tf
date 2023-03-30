resource "google_project_service" "service" {
  count   = length(var.project_services)
  project = var.project
  service = element(var.project_services, count.index)

  // Do not disable the service on destroy. On destroy, we are going to
  // destroy the project, but we need the APIs available to destroy the
  // underlying resources.
  disable_on_destroy = false
}

resource "google_compute_network" "sandbox-net" {
  name                    = "sandbox-net"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "sandbox-subnet" {
  name                     = "sandbox-subnetwork"
  ip_cidr_range            = var.internal_vms_range
  private_ip_google_access = true
  region                   = var.region
  network                  = google_compute_network.sandbox-net.id
  secondary_ip_range {
    range_name    = "pods"
    ip_cidr_range = "192.168.0.0/18"
  }
  secondary_ip_range {
    range_name    = "services"
    ip_cidr_range = "192.168.64.0/18"
  }
}

// Create an external NAT IP
resource "google_compute_address" "nat" {
  name    = format("%s-nat-ip", var.cluster_name)
  project = var.project
  region  = var.region

  depends_on = [
    google_project_service.service,
  ]
}

// Create a cloud router for use by the Cloud NAT
resource "google_compute_router" "router" {
  name    = format("%s-cloud-router", var.cluster_name)
  project = var.project
  region  = var.region
  network = google_compute_network.sandbox-net.self_link

  bgp {
    asn = 64514
  }
}

// Create a NAT router so the nodes can reach DockerHub, etc
resource "google_compute_router_nat" "nat" {
  name    = format("%s-cloud-nat", var.cluster_name)
  project = var.project
  router  = google_compute_router.router.name
  region  = var.region

  nat_ip_allocate_option = "MANUAL_ONLY"

  nat_ips = [google_compute_address.nat.self_link]

  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  subnetwork {
    name                    = google_compute_subnetwork.sandbox-subnet.self_link
    source_ip_ranges_to_nat = ["PRIMARY_IP_RANGE", "LIST_OF_SECONDARY_IP_RANGES"]

    secondary_ip_range_names = [
      google_compute_subnetwork.sandbox-subnet.secondary_ip_range.0.range_name,
      google_compute_subnetwork.sandbox-subnet.secondary_ip_range.1.range_name,
    ]
  }
}