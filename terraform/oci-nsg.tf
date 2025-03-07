resource "oci_core_network_security_group" "nsg_open_all" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.vnc-oci-01.id
  display_name   = "nsg-open-all"
}

resource "oci_core_network_security_group_security_rule" "nsg_ingress_all" {
  network_security_group_id = oci_core_network_security_group.nsg_open_all.id
  direction       = "INGRESS"
  protocol        = "all" 
  source_type     = "CIDR_BLOCK"
  source          = "0.0.0.0/0"
  stateless       = false
}

resource "oci_core_network_security_group_security_rule" "nsg_egress_all" {
  network_security_group_id = oci_core_network_security_group.nsg_open_all.id
  direction        = "EGRESS"
  protocol         = "all"
  destination_type = "CIDR_BLOCK"
  destination      = "0.0.0.0/0" 
  stateless        = false
}