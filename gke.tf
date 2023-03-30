module "gke" {
  depends_on = [
    google_compute_network.sandbox-net,
    google_project_service.service,
    google_compute_router_nat.nat
  ]
  source  = "terraform-google-modules/kubernetes-engine/google"
  version = "~> 21"

  project_id                 = var.project
  name                       = "arbyt-int"
  region                     = var.region
  network                    = google_compute_network.sandbox-net.name
  subnetwork                 = google_compute_subnetwork.sandbox-subnet.name
  ip_range_pods              = var.app_cluster_gke_subnet_pods
  ip_range_services          = var.app_cluster_gke_subnet_services
  http_load_balancing        = true
  horizontal_pod_autoscaling = true
  network_policy             = false
  remove_default_node_pool   = true

  node_pools = [
    {
      name                        = "arbyt-int-node-pool"
      machine_type                = "e2-medium"
      node_locations              = "${var.region}-a,${var.region}-b,${var.region}-c"
      min_count                   = 1
      max_count                   = 1
      local_ssd_count             = 0
      disk_size_gb                = 100
      disk_type                   = "pd-standard"
      image_type                  = "COS_CONTAINERD"
      auto_repair                 = true
      auto_upgrade                = true
      preemptible                 = false
      initial_node_count          = 1
      enable_secure_boot          = true
      enable_integrity_monitoring = true
    },
  ]

  node_pools_oauth_scopes = {
    all = [
      "https://www.googleapis.com/auth/cloud-platform",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}