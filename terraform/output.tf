output vsi-ic-01{
    value = ibm_is_floating_ip.vsi-ic-floating-01.address
}

output vsi-ic-02{
    value = ibm_is_floating_ip.vsi-ic-floating-02.address
}

output instance-oci{
    value = oci_core_instance.instance-oci.public_ip
}