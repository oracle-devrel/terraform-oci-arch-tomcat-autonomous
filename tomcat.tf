## Copyright (c) 2022 Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

module "oci-arch-tomcat" {
  source                             = "github.com/oracle-devrel/terraform-oci-arch-tomcat"
  tenancy_ocid                        = var.tenancy_ocid
  vcn_id                              = oci_core_vcn.tomcat_atp_vcn.id
  numberOfNodes                       = var.numberOfNodes
  availability_domain_name            = var.availability_domain_name == "" ? lookup(data.oci_identity_availability_domains.ADs.availability_domains[0], "name") : var.availability_domain_name
  compartment_ocid                    = var.compartment_ocid
  tomcat_version                      = var.tomcat_version
  tomcat_http_port                    = "8080"
  image_id                            = lookup(data.oci_core_images.InstanceImageOCID.images[0], "id")
  shape                               = var.InstanceShape
  flex_shape_ocpus                    = var.InstanceFlexShapeOCPUS
  flex_shape_memory                   = var.InstanceFlexShapeMemory
  label_prefix                        = ""
  ssh_authorized_keys                 = var.ssh_public_key
  tomcat_subnet_id                    = oci_core_subnet.tomcat_atp_vcn_subnet_app.id
  tomcat_nsg_ids                      = [oci_core_network_security_group.APPSecurityGroup.id]
  lb_subnet_id                        = oci_core_subnet.tomcat_atp_vcn_subnet_lb.id 
  fss_subnet_id                       = oci_core_subnet.tomcat_atp_vcn_subnet_fss.id 
  display_name                        = "tomcatvm"
  lb_shape                            = var.lb_shape 
  flex_lb_min_shape                   = var.flex_lb_min_shape 
  flex_lb_max_shape                   = var.flex_lb_max_shape 
  oci_adb_setup                       = true
  oci_adb_username                    = var.atp_username 
  oci_adb_password                    = var.atp_password
  oci_adb_db_name                     = var.atp_db_name
  oci_adb_tde_wallet_zip_file         = var.atp_tde_wallet_zip_file
  oci_adb_wallet_content              = module.oci-arch-adb.adb_database.adb_wallet_content
  oracle_instant_client_version       = var.oracle_instant_client_version
  oracle_instant_client_version_short = var.oracle_instant_client_version_short
  oci_mds_setup                       = false
  use_bastion_service                 = local.use_bastion_service ? true : false
  inject_bastion_service_id           = local.use_bastion_service ? true : false
  bastion_service_id                  = local.use_bastion_service ? oci_bastion_bastion.bastion-service[0].id : ""
  bastion_service_region              = local.use_bastion_service ? var.region : ""
  inject_bastion_server_public_ip     = local.use_bastion_host ? true : false
  bastion_server_public_ip            = local.use_bastion_host ? oci_core_instance.bastion_instance[0].public_ip : ""
  bastion_server_private_key          = local.use_bastion_host ? tls_private_key.public_private_key_pair.private_key_pem : ""  
  defined_tags                        = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}


