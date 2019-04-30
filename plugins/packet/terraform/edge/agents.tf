resource "packet_ssh_key" "edge_key" {
  name       = "edgekey"
  public_key = "${file("plugins/packet/creds/id_ecdsa.pub")}"
}

resource "packet_device" "agent_arm" {
  hostname          = "agent-arm"
  plan              = "c2.large.arm"
  operating_system  = "ubuntu_16_04"
  billing_cycle     = "hourly"
  project_id        = "${var.project_id}"
  facility          = "dfw2"
  depends_on       = ["packet_ssh_key.edge_key"]
}

resource "packet_device" "agent_x86" {
  hostname          = "agent-x86"
  plan              = "t1.small.x86"
  operating_system  = "ubuntu_16_04"
  billing_cycle     = "hourly"
  project_id        = "${var.project_id}"
  facility          = "${var.facility}"
  depends_on       = ["packet_ssh_key.edge_key"]
}