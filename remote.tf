## Copyright (c) 2022 Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl


data "template_file" "create_app_user_oracle_sh_template" {
  template = file("${path.module}/scripts/create_app_user_oracle.sh")
  vars = {
    oci_adb_admin_username              = "admin"
    oci_adb_admin_password              = var.atp_password
    oci_adb_db_name                     = var.atp_db_name
    oracle_instant_client_version_short = var.oracle_instant_client_version_short
  }
}

data "template_file" "create_app_user_oracle_sql_template" {
  template = file("${path.module}/sqls/create_app_user_oracle.sql")
  vars = {
    oci_adb_username                    = var.atp_username
    oci_adb_password                    = var.atp_password
  }
}

data "template_file" "create_app_tables_oracle_sh_template" {
  template = file("${path.module}/scripts/create_app_tables_oracle.sh")
  vars = {
    oci_adb_username                    = var.atp_username
    oci_adb_password                    = var.atp_password
    oci_adb_db_name                     = var.atp_db_name
    oracle_instant_client_version_short = var.oracle_instant_client_version_short
  }
}

data "template_file" "create_app_tables_oracle_sql_template" {
  template = file("${path.module}/sqls/create_app_tables_oracle.sql")
  vars = {
    oci_adb_username                    = var.atp_username
    oci_adb_password                    = var.atp_password
  }
}

resource "null_resource" "adb_sql_exec" {
  depends_on = [module.oci-arch-tomcat.oci-arch-tomcat, module.oci-arch-adb.adb_database]


  provisioner "file" {
    connection {
      type                = "ssh"
      user                = "opc"
      host                = module.oci-arch-tomcat.tomcat_nodes_private_ips[0]
      private_key         = module.oci-arch-tomcat.generated_ssh_private_key
      script_path         = "/home/opc/myssh.sh"
      agent               = false
      timeout             = "10m"
      bastion_host        = var.use_bastion_service ? "host.bastion.${var.region}.oci.oraclecloud.com" : oci_core_instance.bastion_instance[0].public_ip
      bastion_port        = "22"
      bastion_user        = var.use_bastion_service ? module.oci-arch-tomcat.bastion_session_ids[0] : "opc"
      bastion_private_key = var.use_bastion_service ? module.oci-arch-tomcat.generated_ssh_private_key : tls_private_key.public_private_key_pair.private_key_pem
    }
    content     = data.template_file.create_app_user_oracle_sh_template.rendered
    destination = "/home/opc/create_app_user_oracle.sh"
  }

  provisioner "file" {
    connection {
      type                = "ssh"
      user                = "opc"
      host                = module.oci-arch-tomcat.tomcat_nodes_private_ips[0]
      private_key         = module.oci-arch-tomcat.generated_ssh_private_key
      script_path         = "/home/opc/myssh.sh"
      agent               = false
      timeout             = "10m"
      bastion_host        = var.use_bastion_service ? "host.bastion.${var.region}.oci.oraclecloud.com" : oci_core_instance.bastion_instance[0].public_ip
      bastion_port        = "22"
      bastion_user        = var.use_bastion_service ? module.oci-arch-tomcat.bastion_session_ids[0] : "opc"
      bastion_private_key = var.use_bastion_service ? module.oci-arch-tomcat.generated_ssh_private_key : tls_private_key.public_private_key_pair.private_key_pem
    }
    content     = data.template_file.create_app_user_oracle_sql_template.rendered
    destination = "/home/opc/create_app_user_oracle.sql"
  }

  provisioner "file" {
    connection {
      type                = "ssh"
      user                = "opc"
      host                = module.oci-arch-tomcat.tomcat_nodes_private_ips[0]
      private_key         = module.oci-arch-tomcat.generated_ssh_private_key
      script_path         = "/home/opc/myssh.sh"
      agent               = false
      timeout             = "10m"
      bastion_host        = var.use_bastion_service ? "host.bastion.${var.region}.oci.oraclecloud.com" : oci_core_instance.bastion_instance[0].public_ip
      bastion_port        = "22"
      bastion_user        = var.use_bastion_service ? module.oci-arch-tomcat.bastion_session_ids[0] : "opc"
      bastion_private_key = var.use_bastion_service ? module.oci-arch-tomcat.generated_ssh_private_key : tls_private_key.public_private_key_pair.private_key_pem
    }
    content     = data.template_file.create_app_tables_oracle_sh_template.rendered
    destination = "/home/opc/create_app_tables_oracle.sh"
  }

  provisioner "file" {
    connection {
      type                = "ssh"
      user                = "opc"
      host                = module.oci-arch-tomcat.tomcat_nodes_private_ips[0]
      private_key         = module.oci-arch-tomcat.generated_ssh_private_key
      script_path         = "/home/opc/myssh.sh"
      agent               = false
      timeout             = "10m"
      bastion_host        = var.use_bastion_service ? "host.bastion.${var.region}.oci.oraclecloud.com" : oci_core_instance.bastion_instance[0].public_ip 
      bastion_port        = "22"
      bastion_user        = var.use_bastion_service ? module.oci-arch-tomcat.bastion_session_ids[0] : "opc"
      bastion_private_key = var.use_bastion_service ? module.oci-arch-tomcat.generated_ssh_private_key : tls_private_key.public_private_key_pair.private_key_pem
    }
    content     = data.template_file.create_app_tables_oracle_sql_template.rendered
    destination = "/home/opc/create_app_tables_oracle.sql"
  }

  provisioner "remote-exec" {
    connection {
      type                = "ssh"
      user                = "opc"
      host                = module.oci-arch-tomcat.tomcat_nodes_private_ips[0]
      private_key         = module.oci-arch-tomcat.generated_ssh_private_key
      script_path         = "/home/opc/myssh.sh"
      agent               = false
      timeout             = "10m"
      bastion_host        = var.use_bastion_service ? "host.bastion.${var.region}.oci.oraclecloud.com" : oci_core_instance.bastion_instance[0].public_ip
      bastion_port        = "22"
      bastion_user        = var.use_bastion_service ? module.oci-arch-tomcat.bastion_session_ids[0] : "opc"
      bastion_private_key = var.use_bastion_service ? module.oci-arch-tomcat.generated_ssh_private_key : tls_private_key.public_private_key_pair.private_key_pem
    }
    inline = [
      "echo '--> Running create_app_user_oracle.sh...'",
      "more /home/opc/create_app_user_oracle.sh",
      "chmod +x /home/opc/create_app_user_oracle.sh",
      "sudo /home/opc/create_app_user_oracle.sh",
      "echo '-[100%]-> create_app_user_oracle.sh finished.'",
      "echo '--> Running create_app_tables_oracle.sh...'",
      "more /home/opc/create_app_tables_oracle.sh",
      "chmod +x /home/opc/create_app_tables_oracle.sh",
      "sudo /home/opc/create_app_tables_oracle.sh",
      "echo '-[100%]-> create_app_tables_oracle.sh finished.'"
    ]
  }

}

resource "null_resource" "app_deployment" {
  depends_on = [null_resource.adb_sql_exec]

  count = var.numberOfNodes

  provisioner "remote-exec" {
    connection {
      type                = "ssh"
      user                = "opc"
      host                = module.oci-arch-tomcat.tomcat_nodes_private_ips[count.index]
      private_key         = module.oci-arch-tomcat.generated_ssh_private_key
      script_path         = "/home/opc/myssh.sh"
      agent               = false
      timeout             = "10m"
      bastion_host        = var.use_bastion_service ? "host.bastion.${var.region}.oci.oraclecloud.com" : oci_core_instance.bastion_instance[0].public_ip 
      bastion_port        = "22"
      bastion_user        = var.use_bastion_service ? module.oci-arch-tomcat.bastion_session_ids[count.index] : "opc"
      bastion_private_key = var.use_bastion_service ? module.oci-arch-tomcat.generated_ssh_private_key : tls_private_key.public_private_key_pair.private_key_pem
    }
    inline = [
      "echo '--> Downloading todoapp-atp.war ...'",
      "wget -O /home/opc/todoapp.war https://github.com/oracle-devrel/terraform-oci-arch-tomcat-autonomous/releases/latest/download/todoapp-atp.war",
      "sudo chown opc:opc /home/opc/todoapp.war",
      "echo '-[100%]-> todoapp-atp.war downloaded.'",
      "echo '--> Deploying todoapp-atp.war ...'",      
      "sudo cp /home/opc/todoapp.war /u01/apache-tomcat-${var.tomcat_version}/webapps",
      "sudo chown tomcat:tomcat /u01/apache-tomcat-${var.tomcat_version}/webapps/todoapp.war",
      "sleep 30",
      "echo '-[100%]-> todoapp-atp.war deployed.'"
    ]
  }

}


