//HUB
resource "ibm_is_security_group" "sg-ic" {
  name = "sg-ic"
  vpc  = ibm_is_vpc.vpc-ic.id
}

resource "ibm_is_security_group_rule" "sg_client_rule01" {
  group     = ibm_is_security_group.sg-ic.id
  direction = "inbound"
  remote    = "0.0.0.0/0"
}

resource "ibm_is_security_group_rule" "sg_client_rule02" {
  group     = ibm_is_security_group.sg-ic.id
  direction = "outbound"
  remote    = "0.0.0.0/0"
}

//Spoke
resource "ibm_is_security_group" "sg-ic-spoke" {
  name = "sg-ic"
  vpc  = ibm_is_vpc.vpc-ic-spoke.id
}

resource "ibm_is_security_group_rule" "sg_client_spoke_rule01" {
  group     = ibm_is_security_group.sg-ic-spoke.id
  direction = "inbound"
  remote    = "0.0.0.0/0"
}

resource "ibm_is_security_group_rule" "sg_client_spoke_rule02" {
  group     = ibm_is_security_group.sg-ic-spoke.id
  direction = "outbound"
  remote    = "0.0.0.0/0"
}