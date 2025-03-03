/////VPN1
resource "oci_core_drg" "drg-01" {
  compartment_id = var.compartment_ocid
  display_name   = "drg-01"
}

resource "oci_core_drg_route_distribution" "drg_route_distribution" {
    distribution_type = "IMPORT"
    drg_id = oci_core_drg.drg-01.id
    display_name = "drg_route_distribution-01"
}

resource "oci_core_drg_route_distribution_statement" "drg_route_distribution_statement" {
    drg_route_distribution_id = oci_core_drg_route_distribution.drg_route_distribution.id
    action = "ACCEPT"
    match_criteria {
      match_type = "MATCH_ALL"
      //drg_attachment_id = oci_core_drg_attachment.drg_attachment.id
    }
    priority = 1
}

resource "oci_core_drg_route_table" "drg_route_table-01" {
    drg_id = oci_core_drg.drg-01.id
    is_ecmp_enabled = true
    display_name = "drg-rt-01"
    import_drg_route_distribution_id=oci_core_drg_route_distribution.drg_route_distribution.id
}

resource "oci_core_drg_attachment" "drg_attachment" {
  drg_id         = oci_core_drg.drg-01.id
  vcn_id         = oci_core_vcn.vnc-oci-01.id
  drg_route_table_id = oci_core_drg_route_table.drg_route_table-01.id
}

resource "oci_core_cpe" "cpe-01" {
  compartment_id = var.compartment_ocid
  ip_address     = ibm_is_vpn_gateway.vpn.public_ip_address
  display_name   = "cpe-01"
}

resource "oci_core_ipsec" "ipsec-01" {
  compartment_id = var.compartment_ocid
  cpe_id         = oci_core_cpe.cpe-01.id
  drg_id         = oci_core_drg.drg-01.id
  display_name   = "vpn-oci-01"
  static_routes = ["10.3.0.0/16"]
}

data "oci_core_ipsec_connection_tunnels" "tunnels-ipsec-01" {
    ipsec_id = oci_core_ipsec.ipsec-01.id
}

resource "oci_core_ipsec_connection_tunnel_management" "ipsec-01-tunnel-01" {
    ipsec_id = oci_core_ipsec.ipsec-01.id
    tunnel_id = data.oci_core_ipsec_connection_tunnels.tunnels-ipsec-01.ip_sec_connection_tunnels[0].id
    routing = "POLICY"
    display_name = "tunnel-01"
    shared_secret = var.secret
    ike_version = "V2"
    encryption_domain_config {
        cpe_traffic_selector = ["10.3.0.0/18"]
        oracle_traffic_selector = ["10.1.0.0/18"]
    }
}

resource "oci_core_ipsec_connection_tunnel_management" "ipsec-01-tunnel-02" {
    ipsec_id = oci_core_ipsec.ipsec-01.id
    tunnel_id = data.oci_core_ipsec_connection_tunnels.tunnels-ipsec-01.ip_sec_connection_tunnels[1].id
    routing = "POLICY"
    display_name = "tunnel-02"
    shared_secret = var.secret
    ike_version = "V2"
    encryption_domain_config {
        cpe_traffic_selector = ["10.3.0.0/16"]
        oracle_traffic_selector = ["10.1.0.0/16"]
    }
}

/////VPN2
resource "oci_core_cpe" "cpe-02" {
  compartment_id = var.compartment_ocid
  ip_address     = ibm_is_vpn_gateway.vpn-02.public_ip_address
  display_name   = "cpe-02"
}

resource "oci_core_ipsec" "ipsec-02" {
  compartment_id = var.compartment_ocid
  cpe_id         = oci_core_cpe.cpe-02.id
  drg_id         = oci_core_drg.drg-01.id
  display_name   = "vpn-oci-02"
  static_routes = ["10.3.0.0/16"]
}

data "oci_core_ipsec_connection_tunnels" "tunnels-ipsec-02" {
    ipsec_id = oci_core_ipsec.ipsec-02.id
}

resource "oci_core_ipsec_connection_tunnel_management" "ipsec-02-tunnel-01" {
    ipsec_id = oci_core_ipsec.ipsec-02.id
    tunnel_id = data.oci_core_ipsec_connection_tunnels.tunnels-ipsec-02.ip_sec_connection_tunnels[0].id
    routing = "POLICY"
    display_name = "tunnel-01"
    shared_secret = var.secret
    ike_version = "V2"
    encryption_domain_config {
        cpe_traffic_selector = ["10.3.0.0/18"]
        oracle_traffic_selector = ["10.1.0.0/18"]
    }
}

resource "oci_core_ipsec_connection_tunnel_management" "ipsec-02-tunnel-02" {
    ipsec_id = oci_core_ipsec.ipsec-02.id
    tunnel_id = data.oci_core_ipsec_connection_tunnels.tunnels-ipsec-02.ip_sec_connection_tunnels[1].id
    routing = "POLICY"
    display_name = "tunnel-02"
    shared_secret = var.secret
    ike_version = "V2"
    encryption_domain_config {
        cpe_traffic_selector = ["10.3.0.0/16"]
        oracle_traffic_selector = ["10.1.0.0/16"]
    }
}