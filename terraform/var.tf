variable ssh_key_name{
    type = string
    default = "jorge-ssh-key"
}

variable "compartment_ocid" {
    default = "ocid1.tenancy.oc1..aaaaaaaae2bux2az3wqspk5zgjx46u4vczrlh4xsumswh4xf6klkh5355ixq"
}

variable "oci_image"{
    default = "ocid1.image.oc1.eu-madrid-1.aaaaaaaamujhajjl2cabmpk5ekpkxplzgagoyesn6dnmplkffzelrsyeimva"
}

variable "secret"{
    default = "12345678"
}

variable ssh_file_oci{
    default = "~/.ssh/id_rsa.pub"
}

variable region{
    default = "eu-es"
}