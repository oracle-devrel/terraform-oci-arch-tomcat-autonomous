# terraform-oci-arch-tomcat-autonomous

[![License: UPL](https://img.shields.io/badge/license-UPL-green)](https://img.shields.io/badge/license-UPL-green) [![Quality gate](https://sonarcloud.io/api/project_badges/quality_gate?project=oracle-devrel_terraform-oci-arch-tomcat-autonomous)](https://sonarcloud.io/dashboard?id=oracle-devrel_terraform-oci-arch-tomcat-autonomous)

## Introduction
Apache Tomcat® is an open source Java application server. It implements the Java Servlet, JavaServer Pages, Java Expression Language and Java WebSocket technologies.

## Prerequisites

- Permission to `manage` the following types of resources in your Oracle Cloud Infrastructure tenancy: `vcns`, `internet-gateways`, `route-tables`, `network-security-groups`, `subnets`, `autonomous-database-family`, and `instances`.

- Quota to create the following resources: 1 VCN, 3 subnets, 1 Internet Gateway, 1 NAT Gateway, 2 route rules, 1 ATP instance, and 3 compute instances (bastion host + 2 Tomcat servers).

If you don't have the required permissions and quota, contact your tenancy administrator. See [Policy Reference](https://docs.cloud.oracle.com/en-us/iaas/Content/Identity/Reference/policyreference.htm), [Service Limits](https://docs.cloud.oracle.com/en-us/iaas/Content/General/Concepts/servicelimits.htm), [Compartment Quotas](https://docs.cloud.oracle.com/iaas/Content/General/Concepts/resourcequotas.htm).

## Deploy Using Oracle Resource Manager

1. Click [![Deploy to Oracle Cloud](https://oci-resourcemanager-plugin.plugins.oci.oraclecloud.com/latest/deploy-to-oracle-cloud.svg)](https://cloud.oracle.com/resourcemanager/stacks/create?region=home&zipUrl=https://github.com/oracle-devrel/terraform-oci-arch-tomcat-autonomous/releases/latest/download/terraform-oci-arch-tomcat-autonomous-stack-latest.zip)

    If you aren't already signed in, when prompted, enter the tenancy and user credentials.

2. Review and accept the terms and conditions.

3. Select the region where you want to deploy the stack.

4. Follow the on-screen prompts and instructions to create the stack.

5. After creating the stack, click **Terraform Actions**, and select **Plan**.

6. Wait for the job to be completed, and review the plan.

    To make any changes, return to the Stack Details page, click **Edit Stack**, and make the required changes. Then, run the **Plan** action again.

7. If no further changes are necessary, return to the Stack Details page, click **Terraform Actions**, and select **Apply**. 

## Deploy Using the Terraform CLI

### Clone the Module

Now, you'll want a local copy of this repo. You can make that with the commands:

```
    git clone https://github.com/oracle-quickstart/oci-arch-tomcat-autonomous.git
    cd oci-arch-tomcat-autonomous
    ls
```

### Prerequisites
First off, you'll need to do some pre-deploy setup.  That's all detailed [here](https://github.com/cloud-partners/oci-prerequisites).

Create a `terraform.tfvars` file, and specify the following variables:

```
# Authentication
tenancy_ocid         = "<tenancy_ocid>"
user_ocid            = "<user_ocid>"
fingerprint          = "<finger_print>"
private_key_path     = "<pem_private_key_path>"

# Region
region = "<oci_region>"

# Compartment
compartment_ocid = "<compartment_ocid>"

# ATP instance Password 
atp_password = "<atp_password>"

# Number of Tomcat nodes (optional)
numberOfNodes = 2

# Customer SSH Public Key (optional)
ssh_public_key = "<ssh_public_key>"
````

### Create the Resources
Run the following commands:

    terraform init
    terraform plan
    terraform apply


### Testing your Deployment
After the deployment is finished, you can test that your Tomcat was deployed correctly and can access the tomcat demo application with ATP. Pick up the value of the todoapp_url:

````
todoapp_url = http://129.159.65.38/todoapp/list
`````

Then copy it into Web browser. Here is the example of the succesfull outcome:

![](./images/todoapp.png)

As the load balancer alternates between the 2 Tomcat nodes, the session data should persist.

### Destroy the Deployment
When you no longer need the deployment, you can run this command to destroy the resources:

    terraform destroy

## URLs
For details of the architecture, see [_Deploy Apache Tomcat on Arm-based Ampere A1 compute connected to an autonomous database_](https://docs.oracle.com/en/solutions/deploy-tomcat-adb)

## Contributing
This project is open source.  Please submit your contributions by forking this repository and submitting a pull request!  Oracle appreciates any contributions that are made by the open source community.

### Attribution & Credits
Initially, this project was created and distributed in [GitHub Oracle QuickStart space](https://github.com/oracle-quickstart/oci-arch-tomcat-autonomous). For that reason, we would like to thank all the involved contributors enlisted below:
- Lukasz Feldman (https://github.com/lfeldman)
- Orlando Gentil (https://github.com/oegentil)
- Emmanuel Leroy (https://github.com/streamnsight) 
- Flavio Pereira (https://github.com/flavio-santino)

## License
Copyright (c) 2021 Oracle and/or its affiliates.

Licensed under the Universal Permissive License (UPL), Version 1.0.

See [LICENSE](LICENSE) for more details.
