resource "ibm_is_vpc" "vpc-ic" {
  name = "vpc-ic-hub"
  address_prefix_management = "manual"
}

resource "ibm_is_vpc_address_prefix" "vpc-ic-address-01" {
  name = "vpc-ic-address-01"
  zone = "${var.region}-1"
  vpc  = ibm_is_vpc.vpc-ic.id
  cidr = "10.2.10.0/24"
}

resource "ibm_is_vpc_address_prefix" "vpc-ic-address-02" {
  name = "vpc-ic-address-02"
  zone = "${var.region}-1"
  vpc  = ibm_is_vpc.vpc-ic.id
  cidr = "10.2.1.0/24"
}

resource "ibm_is_vpc_address_prefix" "vpc-ic-address-03" {
  name = "vpc-ic-address-03"
  zone = "${var.region}-2"
  vpc  = ibm_is_vpc.vpc-ic.id
  cidr = "10.2.20.0/24"
}

resource "ibm_is_vpc_address_prefix" "vpc-ic-address-04" {
  name = "vpc-ic-address-04"
  zone = "${var.region}-2"
  vpc  = ibm_is_vpc.vpc-ic.id
  cidr = "10.2.2.0/24"
}

resource "ibm_is_subnet" "subnet01-ic" {
  name            = "subnet01-ic"
  vpc             = ibm_is_vpc.vpc-ic.id
  zone            = "${var.region}-1"
  ipv4_cidr_block = "10.2.1.0/24"
  depends_on = [ibm_is_vpc_address_prefix.vpc-ic-address-02]
}

resource "ibm_is_subnet" "subnet02-ic" {
  name            = "subnet02-ic"
  vpc             = ibm_is_vpc.vpc-ic.id
  zone            = "${var.region}-2"
  ipv4_cidr_block = "10.2.2.0/24"
  depends_on = [ibm_is_vpc_address_prefix.vpc-ic-address-04]
}

resource "ibm_is_vpc" "vpc-ic-spoke" {
  name = "vpc-ic-spoke"
  address_prefix_management = "manual"
}

resource "ibm_is_vpc_address_prefix" "vpc-ic-address-spoke-01" {
  name = "vpc-ic-address-spoke-01"
  zone = "${var.region}-1"
  vpc  = ibm_is_vpc.vpc-ic-spoke.id
  cidr = "10.3.1.0/24"
}

resource "ibm_is_vpc_address_prefix" "vpc-ic-address-spoke-02" {
  name = "vpc-ic-address-spoke-02"
  zone = "${var.region}-2"
  vpc  = ibm_is_vpc.vpc-ic-spoke.id
  cidr = "10.3.2.0/24"
}

resource "ibm_is_subnet" "subnet01-ic-spoke" {
  name            = "subnet01-ic-spoke"
  vpc             = ibm_is_vpc.vpc-ic-spoke.id
  zone            = "${var.region}-1"
  ipv4_cidr_block = "10.3.1.0/24"
  depends_on = [ibm_is_vpc_address_prefix.vpc-ic-address-spoke-01]
}

resource "ibm_is_subnet" "subnet02-ic-spoke" {
  name            = "subnet02-ic-spoke"
  vpc             = ibm_is_vpc.vpc-ic-spoke.id
  zone            = "${var.region}-2"
  ipv4_cidr_block = "10.3.2.0/24"
  depends_on = [ibm_is_vpc_address_prefix.vpc-ic-address-spoke-02]
}

resource "ibm_is_vpc_routing_table" "rt-ingress" {
  vpc                              = ibm_is_vpc.vpc-ic.id
  name                             = "rt-ingress"
  route_transit_gateway_ingress    = true
  advertise_routes_to              = ["transit_gateway"]
  accept_routes_from_resource_type = ["vpn_server", "vpn_gateway"]
}
