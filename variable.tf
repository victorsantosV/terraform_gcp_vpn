variable "credentials_google_project" {
  default = "rational-camera-352019"
}
variable "credentials_google_region" {
  default = "us-central1"
}
variable "credentials_google_zone" {
  default = "us-central1-a"
}

# ====== VPN config ============= #
variable "google_compute_vpn_tunnel_name" {
  default = "tunnel1"
}
variable "google_compute_vpn_tunnel_peerIp" {
  default = "15.0.0.120"
}
variable "google_compute_vpn_tunnel_shared_secret" {
  default = "a-secret-message"
}

# ================ VPN Network ================ #
variable "google_compute_vpn_gateway_name" {
  default = "vpn1"
}
variable "google_compute_network_name" {
  default = "network1"
}
variable "google_compute_address" {
  default = "vpn-static-ip"
}

variable "google_compute_route_name" {
  default = "route1"
}
variable "google_compute_route_dest_range" {
  default = "15.0.0.0/24"
}