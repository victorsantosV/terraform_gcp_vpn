terraform {
  required_providers{
   google = {
        source="hashicorp/google"
        version="3.5.0"
      }
   }
}

provider "google" {
 credentials = file("test.json")
 project = "${var.credentials_google_project}"
 region = "${var.credentials_google_region}"
 zone = "${var.credentials_google_zone}"
}

resource "google_compute_vpn_tunnel" "tunnel1" {
  name          = "${var.google_compute_vpn_tunnel_name}"
  peer_ip       = "${var.google_compute_vpn_tunnel_peerIp}"
  shared_secret = "${var.google_compute_vpn_tunnel_shared_secret}"

  target_vpn_gateway = google_compute_vpn_gateway.target_gateway.id

  depends_on = [
    google_compute_forwarding_rule.fr_esp,
    google_compute_forwarding_rule.fr_udp500,
    google_compute_forwarding_rule.fr_udp4500,
  ]
}

resource "google_compute_vpn_gateway" "target_gateway" {
  name    = "${var.google_compute_vpn_gateway_name}"
  network = google_compute_network.network1.id
}

resource "google_compute_network" "network1" {
  name = "${var.google_compute_network_name}"
}

resource "google_compute_address" "vpn_static_ip" {
  name = "${var.google_compute_address}"
}

resource "google_compute_forwarding_rule" "fr_esp" {
  name        = "${env.google_compute_forwarding_rule_name_fr}"
  ip_protocol = "ESP"
  ip_address  = google_compute_address.vpn_static_ip.address
  target      = google_compute_vpn_gateway.target_gateway.id
}

resource "google_compute_forwarding_rule" "fr_udp500" {
  name        = "fr-udp500"
  ip_protocol = "UDP"
  port_range  = "500"
  ip_address  = google_compute_address.vpn_static_ip.address
  target      = google_compute_vpn_gateway.target_gateway.id
}

resource "google_compute_forwarding_rule" "fr_udp4500" {
  name        = "fr-udp4500"
  ip_protocol = "UDP"
  port_range  = "4500"
  ip_address  = google_compute_address.vpn_static_ip.address
  target      = google_compute_vpn_gateway.target_gateway.id
}

resource "google_compute_route" "route1" {
  name       = "${var.google_compute_route_name}"
  network    = google_compute_network.network1.name
  dest_range = "${var.google_compute_route_dest_range}"
  priority   = 1000

  next_hop_vpn_tunnel = google_compute_vpn_tunnel.tunnel1.id
}