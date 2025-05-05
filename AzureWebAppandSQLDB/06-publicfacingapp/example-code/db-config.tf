resource "null_resource" "addfiles" {
   
provisioner "file" {
  source      = "01.sql"
  destination = "/home/linuxadmin/01.sql"

      connection {
        type="ssh"
        user="linuxadmin"
        password = var.adminpassword
        host ="${azurerm_public_ip.dbip["dbvm01"].ip_address}"
      }
    }

provisioner "remote-exec" {
    connection {
        type="ssh"
        user="linuxadmin"
        password = var.adminpassword
        host ="${azurerm_public_ip.dbip["dbvm01"].ip_address}"
      }
  inline = ["sudo mysql -u root < 01.sql",
  "sudo sed -i 's/.*bind-address.*/bind-address = 10.0.1.4/' /etc/mysql/mysql.conf.d/mysqld.cnf",
  "sudo systemctl restart mysql"]
}
    depends_on = [ azurerm_network_security_group.app_nsg,
    azurerm_linux_virtual_machine.dbvm ]
}