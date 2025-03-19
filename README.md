> [!WARNING]
> IBM Legacy Public Repository Disclosure: All content in this repository including code has been provided by IBM under the associated open source software license and IBM is under no obligation to provide enhancements, updates, or support. IBM developers produced this code as an open source project (not as an IBM product), and IBM makes no assertions as to the level of quality nor security, and will not be maintaining this code going forward

# Introduction
This repository demonstrates how to connect OCI and IBM Cloud through a VPN in a high-availability (HA) scenario using a hub-and-spoke architecture on the IBM Cloud side, in an Active-Active setup. This way, all our machines in the Spoke VPCs on IBM Cloud will route traffic through a single point to access resources in OCI by sending the traffic to the Hub VPC. This approach prevents each Spoke from being individually responsible for connectivity.

We will also provide a sample Terraform code to facilitate a quick and easy deployment. This example is designed for learning purposes and serves as a helpful introduction to deploying the solution. However, we recommend not using it directly in production environments.

We encourage you to visit the following blog where we delve into the technical aspects of the solution **TODO - LINK BLOG**

# Proposed architecture. Active-Active

![alt text](images/main.png)

For each cloud provider, two VPN gateways must be provisioned. On IBM Cloud, one VPN Gateway must be deployed per zone. Each VPN gateway is zone-resilient, as it consists of two appliances (Active/Passive) within the zone. Additionally, each VPN gateway can manage multiple tunnels. On OCI, VPN IPsec connections are regional, meaning each tunnel will be deployed in every zone and managed by the appliance in that zone. Consequently, we will configure one policy-based VPN gateway per zone on IBM Cloud, provisioning two tunnels that connect to the two OCI VPN IPsec tunnels deployed in each zone. The Transit Gateway is capable of maintaining traffic within the same zone between spokes and the hub, provided that the same range and prefix per zone are advertised to it via the ingress routing table.


# Terraform
> [!WARNING]
> The following sample Terraform code facilitates a quick and easy initial deployment. However, we recommend not using it directly in production environments, as it is not supported. If you choose to use it, please review and adapt it to fit your specific requirements.

Let's deploy the components described in the proposed arquitecture section. In overall, the following resources will be deployed.

**On IBM Cloud**
* 1 VPC transit (```10.2.0.0/16```)
* 1 VPC spoke (```10.3.0.0/16```)
* 1 TGW
* 1 Routing table ingress
* 2 VPN Gateway on IBM Cloud. 1 per zone
    * 2 tunnels per VPN Gateway
* 1 VSI VPC in each zone on transit VPC

**On OCI**
* 1 Virtual cloud network (range ```10.1.0.0/16```)
* 2 Site-to-Site VPN
    * 1 tunnel per appliance
* 1 Oracle Linux instance
* 1 Dynamic routing gateway

Download code from repository
```bash
git clone https://github.com/IBM/vpn-ha-ic-oci-hub-spoke
cd vpn-ha-ic-oci-hub-spoke/terraform
```
Add ibmcloud cli environment variables
```bash
export IC_REGION=$IBM_REGION
export IC_API_KEY=$IBM_API_KEY
```
Initialite session on OCI
```bash
oci session authenticate
```
Get compartment_ocid
```bash
export compartment_ocid=$(cat ~/.oci/config | grep tenancy | head -1 | cut -d '=' -f 2 | sed 's/^ *//g')
```
Set the SSH key name. It must already exist. If not, create it.
```bash
export ssh_key_name="SSH_KEY_NAME"
```
Provision it
```bash
terraform init
terraform plan -var "compartment_ocid=$compartment_ocid" -var "ssh_key_name=$ssh_key_name" -out plan.out
terraform apply plan.out
```
Get OCI Instance private ip
```bash
ssh opc@$(terraform output instance-oci | sed "s/\"//g") ip addr show
```
Log into IC VSI in zone 1 and ping it
```bash
ssh root@$(terraform output vsi-ic-01 | sed "s/\"//g")
ping 10.1.1.109
```
Log into IC VSI in zone 2 and ping it
```bash
ssh root@$(terraform output vsi-ic-02 | sed "s/\"//g")
ping 10.1.1.109
```

# References
* https://cloud.ibm.com/docs/vpc?topic=vpc-vpn-overview
* https://docs.oracle.com/en-us/iaas/Content/Network/Tasks/overviewIPsec.htm
* **TODO - LINK BLOG**