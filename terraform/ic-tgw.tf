resource "ibm_tg_gateway" "twg"{
    name="tgw01"
    location="${var.region}"
    global=true
}  

resource "ibm_tg_connection" "vpc_hub_conn" {
    gateway      = ibm_tg_gateway.twg.id
    network_type = "vpc"
    name         = "vpc-ic-hub"
    network_id   = ibm_is_vpc.vpc-ic.resource_crn
}

resource "ibm_tg_connection" "vpc_spoke_conn" {
    gateway      = ibm_tg_gateway.twg.id
    network_type = "vpc"
    name         = "vpc-ic-spoke"
    network_id   = ibm_is_vpc.vpc-ic-spoke.resource_crn
}