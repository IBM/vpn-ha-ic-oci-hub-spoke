resource "ibm_is_ipsec_policy" "ic-ipsec-policy" {
  name                     = "ic-ipsec-policy"
  authentication_algorithm = "sha256"
  encryption_algorithm     = "aes128"
  pfs                      = "group_14"
}

resource "ibm_is_vpn_gateway" "vpn" {
  name   = "vpn-gateway-ic-01"
  subnet = ibm_is_subnet.subnet01-ic.id
  mode   = "policy"
}

resource "ibm_is_vpn_gateway_connection" "vpn-tunnel-01" {
  name          = "tunnel-01"
  vpn_gateway   = ibm_is_vpn_gateway.vpn.id
  preshared_key = var.secret
  peer {
      address  = oci_core_ipsec_connection_tunnel_management.ipsec-01-tunnel-01.vpn_ip
      cidrs    = ["10.1.0.0/18"]
  }
  local {
      cidrs   = ["10.3.0.0/18"]
  }
  ipsec_policy = ibm_is_ipsec_policy.ic-ipsec-policy.id
}

resource "ibm_is_vpn_gateway_connection" "vpn-tunnel-02" {
  name          = "tunnel-02"
  vpn_gateway   = ibm_is_vpn_gateway.vpn.id
  preshared_key = var.secret
  peer {
      address  = oci_core_ipsec_connection_tunnel_management.ipsec-01-tunnel-02.vpn_ip
      cidrs    = ["10.1.0.0/16"]   
  }
  local {
      cidrs   = ["10.3.0.0/16"]
  }
  ipsec_policy = ibm_is_ipsec_policy.ic-ipsec-policy.id
}

//VPN02
resource "ibm_is_vpn_gateway" "vpn-02" {
  name   = "vpn-gateway-ic-02"
  subnet = ibm_is_subnet.subnet02-ic.id
  mode   = "policy"
}

resource "ibm_is_vpn_gateway_connection" "vpn-02-tunnel-01" {
  name          = "tunnel-01"
  vpn_gateway   = ibm_is_vpn_gateway.vpn-02.id
  preshared_key = var.secret
  peer {
      address  = oci_core_ipsec_connection_tunnel_management.ipsec-02-tunnel-01.vpn_ip
      cidrs    = ["10.1.0.0/18"]
  }
  local {
      cidrs   = ["10.3.0.0/18"]
  }
  ipsec_policy = ibm_is_ipsec_policy.ic-ipsec-policy.id
}

resource "ibm_is_vpn_gateway_connection" "vpn-02-tunnel-02" {
  name          = "tunnel-02"
  vpn_gateway   = ibm_is_vpn_gateway.vpn-02.id
  preshared_key = var.secret
  peer {
      address  = oci_core_ipsec_connection_tunnel_management.ipsec-02-tunnel-02.vpn_ip
      cidrs    = ["10.1.0.0/16"]   
  }
  local {
      cidrs   = ["10.3.0.0/16"]
  }
  ipsec_policy = ibm_is_ipsec_policy.ic-ipsec-policy.id
}