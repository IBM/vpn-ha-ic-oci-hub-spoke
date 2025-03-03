data "oci_core_image" "oracle_linux" {
    image_id = var.oci_image
}

data "oci_identity_availability_domain" "ad_1" {
  compartment_id = var.compartment_ocid
  ad_number = 1
}

resource "oci_core_vcn" "vnc-oci-01" {
  compartment_id = var.compartment_ocid
  cidr_block     = "10.1.0.0/16"
  display_name   = "vnc-oci-01"
  dns_label      = "vcnoci01"
}

resource "oci_core_subnet" "subnet-oci-01" {
  compartment_id       = var.compartment_ocid
  vcn_id               = oci_core_vcn.vnc-oci-01.id
  cidr_block           = "10.1.1.0/24"
  display_name         = "subnet-oci-01"
  dns_label            = "subnet01"
  prohibit_public_ip_on_vnic = false
}

resource "oci_core_internet_gateway" "igw-oci-01" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.vnc-oci-01.id
  display_name   = "igw-oci-01"
  enabled     = true
}

resource "oci_core_default_route_table" "default-rt" {
  manage_default_resource_id = oci_core_vcn.vnc-oci-01.default_route_table_id
  route_rules {
    destination       = "0.0.0.0/0"
    network_entity_id = oci_core_internet_gateway.igw-oci-01.id   
  }
  route_rules {
    destination      = "10.3.0.0/16"
    network_entity_id = oci_core_drg.drg-01.id
  }
}

resource "oci_core_instance" "instance-oci" {
  compartment_id     = var.compartment_ocid
  availability_domain = data.oci_identity_availability_domain.ad_1.name
  shape              = "VM.Standard3.Flex"

  create_vnic_details {
    subnet_id          = oci_core_subnet.subnet-oci-01.id
    assign_public_ip   = true
    display_name       = "instance-vnic-oci-01"
    hostname_label     = "instance-oci"
    nsg_ids            = [oci_core_network_security_group.nsg_open_all.id]
  }

  metadata = {
    ssh_authorized_keys = file(var.ssh_file_oci)
  }

  source_details {
    source_type          = "image"
    source_id            = data.oci_core_image.oracle_linux.id
    boot_volume_size_in_gbs = 50
  }

  shape_config {
    ocpus = 1
    vcpus = 2
    memory_in_gbs = 4
  }

  display_name = "instance-oci"
}

resource "oci_core_security_list" "sec-list" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.vnc-oci-01.id
  display_name   = "sec-list-01"

  ingress_security_rules {
    protocol = "all"
    source   = "0.0.0.0/0"
  }

  egress_security_rules {
    protocol = "all"
    destination   = "0.0.0.0/0"
  }
}