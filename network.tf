## Copyright (c) 2022 Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

resource "oci_core_vcn" "tomcat_atp_vcn" {
  cidr_block     = var.tomcat_atp_vcn_cidr_block
  compartment_id = var.compartment_ocid
  display_name   = var.tomcat_atp_vcn_display_name
  dns_label      = "tomvcn"
  defined_tags   = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}

resource "oci_core_internet_gateway" "tomcat_atp_vcn_internet_gateway" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.tomcat_atp_vcn.id
  enabled        = "true"
  display_name   = "tomcat_atp_vcn_igw"
  defined_tags   = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}

resource "oci_core_nat_gateway" "tomcat_atp_vcn_nat_gateway" {
  count          = var.free_tier ? 0 : 1
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.tomcat_atp_vcn.id
  display_name   = "tomcat_atp_vcn_nat"
  defined_tags   = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}

resource "oci_core_route_table" "tomcat_atp_vcn_igw_route_table" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.tomcat_atp_vcn.id
  display_name   = "tomcat_atp_vcn_igw_route_table"
  route_rules {
    network_entity_id = oci_core_internet_gateway.tomcat_atp_vcn_internet_gateway.id
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
  }
  defined_tags = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}

resource "oci_core_route_table" "tomcat_atp_vcn_nat_route_table" {
  count          = var.free_tier ? 0 : 1
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.tomcat_atp_vcn.id
  display_name   = "tomcat_atp_vcn_nat_route_table"
  route_rules {
    network_entity_id = oci_core_nat_gateway.tomcat_atp_vcn_nat_gateway[count.index].id
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
  }
  defined_tags = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}

resource "oci_core_security_list" "ssh_security_list" {
  compartment_id = var.compartment_ocid
  display_name   = "ssh_security_list"
  vcn_id         = oci_core_vcn.tomcat_atp_vcn.id
  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "6"
  }
  ingress_security_rules {
    tcp_options {
      max = 22
      min = 22
    }
    protocol = "6"
    source   = "0.0.0.0/0"
  }
}

resource "oci_core_security_list" "lb_http_security_list" {
  compartment_id = var.compartment_ocid
  display_name   = "lb_http_security_list"
  vcn_id         = oci_core_vcn.tomcat_atp_vcn.id
  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "6"
  }
  ingress_security_rules {
    tcp_options {
      max = 80
      min = 80
    }
    protocol = "6"
    source   = "0.0.0.0/0"
  }
}

resource "oci_core_security_list" "tomcat_http_security_list" {
  compartment_id = var.compartment_ocid
  display_name   = "tomcat_http_security_list"
  vcn_id         = oci_core_vcn.tomcat_atp_vcn.id
  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "6"
  }
  ingress_security_rules {
    tcp_options {
      max = 8080
      min = 8080
    }
    protocol = "6"
    source   = "0.0.0.0/0"
  }
}

#tomcat_atp_vcn lb subnet
resource "oci_core_subnet" "tomcat_atp_vcn_subnet_lb" {
  cidr_block        = var.tomcat_atp_vcn_subnet_lb_cidr_block
  compartment_id    = var.compartment_ocid
  vcn_id            = oci_core_vcn.tomcat_atp_vcn.id
  dns_label         = "lbsub"
  display_name      = var.tomcat_atp_vcn_subnet_lb_display_name
  security_list_ids = [oci_core_security_list.lb_http_security_list.id]
  route_table_id    = oci_core_route_table.tomcat_atp_vcn_igw_route_table.id 
  defined_tags      = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}

#tomcat_atp_vcn bastion subnet
resource "oci_core_subnet" "tomcat_atp_vcn_subnet_bastion" {
  cidr_block     = var.tomcat_atp_vcn_subnet_bastion_cidr_block
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.tomcat_atp_vcn.id
  dns_label      = "bassub"
  display_name   = var.tomcat_atp_vcn_subnet_bastion_display_name
  route_table_id = oci_core_route_table.tomcat_atp_vcn_igw_route_table.id 
  defined_tags   = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}

#tomcat_atp_vcn app01 subnet
resource "oci_core_subnet" "tomcat_atp_vcn_subnet_app" {
  cidr_block                 = var.tomcat_atp_vcn_subnet_app_cidr_block
  compartment_id             = var.compartment_ocid
  vcn_id                     = oci_core_vcn.tomcat_atp_vcn.id
  dns_label                  = "tomsub"
  display_name               = var.tomcat_atp_vcn_subnet_app_display_name
  security_list_ids          = [oci_core_security_list.ssh_security_list.id, oci_core_security_list.tomcat_http_security_list.id]
  prohibit_public_ip_on_vnic = var.free_tier ? false : true
  route_table_id             = var.free_tier ? oci_core_route_table.tomcat_atp_vcn_igw_route_table.id : oci_core_route_table.tomcat_atp_vcn_nat_route_table[0].id
  defined_tags               = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}

#tomcat_atp_vcn fss subnet
resource "oci_core_subnet" "tomcat_atp_vcn_subnet_fss" {
  cidr_block                 = var.tomcat_atp_vcn_subnet_fss_cidr_block
  compartment_id             = var.compartment_ocid
  vcn_id                     = oci_core_vcn.tomcat_atp_vcn.id
  dns_label                  = "fsssub"
  display_name               = var.tomcat_atp_vcn_subnet_fss_display_name
  prohibit_public_ip_on_vnic = var.free_tier ? false : true
  route_table_id             = var.free_tier ? oci_core_route_table.tomcat_atp_vcn_igw_route_table.id : oci_core_route_table.tomcat_atp_vcn_nat_route_table[0].id
  defined_tags               = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}

#tomcat_atp_vcn db subnet
resource "oci_core_subnet" "tomcat_atp_vcn_subnet_db" {
  cidr_block                 = var.tomcat_atp_vcn_subnet_db_cidr_block
  compartment_id             = var.compartment_ocid
  vcn_id                     = oci_core_vcn.tomcat_atp_vcn.id
  dns_label                  = "dbsub"
  display_name               = var.tomcat_atp_vcn_subnet_db_display_name
  prohibit_public_ip_on_vnic = var.free_tier ? false : true
  route_table_id             = var.free_tier ? oci_core_route_table.tomcat_atp_vcn_igw_route_table.id : oci_core_route_table.tomcat_atp_vcn_nat_route_table[0].id
  defined_tags               = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}

