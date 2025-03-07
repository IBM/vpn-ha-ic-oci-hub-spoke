
data "ibm_is_image" "image"{
    name = "ibm-centos-stream-9-amd64-9"
}

data "ibm_is_ssh_key" "key" {
  name = var.ssh_key_name
}

resource "ibm_is_instance" "vsi-ic-01" {
  name              = "vsi-ic-01"
  image             = data.ibm_is_image.image.id
  profile           = "cx3d-2x5"
  vpc               = ibm_is_vpc.vpc-ic-spoke.id
  zone              = "${var.region}-1"
  primary_network_attachment{
    virtual_network_interface{
       subnet = ibm_is_subnet.subnet01-ic-spoke.id
       security_groups = [ibm_is_security_group.sg-ic-spoke.id]
    }
  }
  keys = [data.ibm_is_ssh_key.key.id]
}

resource "ibm_is_floating_ip" "vsi-ic-floating-01" {
  name   = "vsi-ic-floating-01"
  zone   = "${var.region}-1"
}

resource "ibm_is_virtual_network_interface_floating_ip" "vsi-ic-floating-01"{
  virtual_network_interface = ibm_is_instance.vsi-ic-01.primary_network_attachment[0].virtual_network_interface[0].id
  floating_ip = ibm_is_floating_ip.vsi-ic-floating-01.id
}

resource "ibm_is_instance" "vsi-ic-02" {
  name              = "vsi-ic-02"
  image             = data.ibm_is_image.image.id
  profile           = "cx3d-2x5"
  vpc               = ibm_is_vpc.vpc-ic-spoke.id
  zone              = "${var.region}-2"
  primary_network_attachment{
    virtual_network_interface{
       subnet = ibm_is_subnet.subnet02-ic-spoke.id
       security_groups = [ibm_is_security_group.sg-ic-spoke.id]
    }
  }
  keys = [data.ibm_is_ssh_key.key.id]
}

resource "ibm_is_floating_ip" "vsi-ic-floating-02" {
  name   = "vsi-ic-floating-02"
  zone   = "${var.region}-2"
}

resource "ibm_is_virtual_network_interface_floating_ip" "vsi-ic-floating-02"{
  virtual_network_interface = ibm_is_instance.vsi-ic-02.primary_network_attachment[0].virtual_network_interface[0].id
  floating_ip = ibm_is_floating_ip.vsi-ic-floating-02.id
}