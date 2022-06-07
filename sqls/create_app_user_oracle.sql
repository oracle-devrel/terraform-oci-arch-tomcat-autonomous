CREATE USER ${oci_adb_username} IDENTIFIED BY "${oci_adb_password}";
GRANT CREATE SESSION TO ${oci_adb_username};
GRANT CREATE TABLE TO ${oci_adb_username};
GRANT CREATE SEQUENCE TO ${oci_adb_username};
GRANT UNLIMITED TABLESPACE TO ${oci_adb_username};
exit;
