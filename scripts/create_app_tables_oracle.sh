export LD_LIBRARY_PATH=/usr/lib/oracle/${oracle_instant_client_version_short}/client64/lib
/usr/lib/oracle/${oracle_instant_client_version_short}/client64/bin/sqlplus ${oci_adb_username}/${oci_adb_password}@${oci_adb_db_name}_medium @/home/opc/create_app_tables_oracle.sql > /home/opc/create_app_tables_oracle.log
cat /home/opc/create_app_tables_oracle.log