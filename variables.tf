## Copyright (c) 2022 Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

variable "release" {
  description = "Reference Architecture Release (OCI Architecture Center)"
  default     = "1.6"
}

variable "tenancy_ocid" {}
variable "region" {}
variable "compartment_ocid" {}
variable "fingerprint" {}
variable "user_ocid" {}
variable "private_key_path" {}

variable "availability_domain_name" {
  default = ""
}

variable "availability_domain_number" {
  default = 0
}
variable "atp_password" {}

variable "ssh_public_key" {
  default = ""
}

variable "use_bastion_service" {
  default = false
}

variable "tomcat_atp_vcn_cidr_block" {
  default = "10.0.0.0/16"
}

variable "tomcat_atp_vcn_display_name" {
  default = "tomcat_atp_vcn"
}

variable "tomcat_atp_vcn_subnet_lb_cidr_block" {
  default = "10.0.1.0/24"
}

variable "tomcat_atp_vcn_subnet_lb_display_name" {
  default = "tomcat_atp_vcn_subnet_lb"
}

variable "tomcat_atp_vcn_subnet_bastion_cidr_block" {
  default = "10.0.2.0/24"
}

variable "tomcat_atp_vcn_subnet_bastion_display_name" {
  default = "tomcat_atp_vcn_subnet_bastion"
}

variable "tomcat_atp_vcn_subnet_app_cidr_block" {
  default = "10.0.10.0/24"
}

variable "tomcat_atp_vcn_subnet_app_display_name" {
  default = "tomcat_atp_vcn_subnet_app"
}

variable "tomcat_atp_vcn_subnet_fss_cidr_block" {
  default = "10.0.20.0/24"
}

variable "tomcat_atp_vcn_subnet_fss_display_name" {
  default = "tomcat_atp_vcn_subnet_fss"
}

variable "tomcat_atp_vcn_subnet_db_cidr_block" {
  default = "10.0.30.0/24"
}

variable "tomcat_atp_vcn_subnet_db_display_name" {
  default = "tomcat_atp_vcn_subnet_db"
}

variable "lb_shape" {
  default = "flexible"
}

variable "flex_lb_min_shape" {
  default = "10"
}

variable "flex_lb_max_shape" {
  default = "10"
}

variable "InstanceShape" {
  default = "VM.Standard.A1.Flex"
}

variable "InstanceFlexShapeOCPUS" {
  default = 1
}

variable "InstanceFlexShapeMemory" {
  default = 10
}

variable "instance_os" {
  description = "Operating system for compute instances"
  default     = "Oracle Linux"
}

variable "linux_os_version" {
  description = "Operating system version for all Linux instances"
  default     = "9"
}

variable "numberOfNodes" {
  default = 2
}

variable "oracle_instant_client_version" {
  default = "19.10"
}

variable "oracle_instant_client_version_short" {
  default = "19.10"
}

variable "tomcat_version" {
  default = "9.0.45"
}

variable "atp_private_endpoint" {
  default = true
}

variable "atp_username" {
  default = "todoapp"
}

variable "atp_cpu_core_count" {
  default = 1
}

variable "free_tier" {
  default = false
}

variable "atp_data_storage_size_in_tbs" {
  default = 1
}

variable "atp_db_name" {
  default = "TomcatATP"
}

variable "atp_db_version" {
  default = "19c"
}

variable "atp_defined_tags_value" {
  default = ""
}

variable "atp_name" {
  default = "TomcatATP"
}

variable "atp_freeform_tags" {
  default = {
    "Owner" = "ATP"
  }
}

variable "atp_license_model" {
  default = "LICENSE_INCLUDED"
}

variable "atp_tde_wallet_zip_file" {
  default = "tde_wallet_TomcatATP.zip"
}

variable "atp_private_endpoint_label" {
  default = "ATPPrivateEndpoint"
}


