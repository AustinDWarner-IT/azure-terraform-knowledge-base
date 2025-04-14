resource "null_resource" "addfiles" {
provisioner "file" {
    source = "Default.html"
    destination = "/home/linuxadmin/Default.html"

        connection {
          type = "ssh"
            user = "linuxadmin"
            password = var.admin_password
            host = "${azurerm_public_ip.appip["appvm01"].ip_address}"
        }
  
    }
  provisioner "remote-exec" {
    connection {
      type = "ssh"
      user = "linuxadmin"
      password = var.admin_password
      host = "${azurerm_public_ip.appip["appvm01"].ip_address}"
    }
    inline = [
      "sudo mv /home/linuxadmin/Default.html /var/www/html/Default.html"
    ]
    }

        depends_on = [ azurerm_network_security_group.app_nsg ]
    
  }



