terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "webserver" {
  count         = 2
  ami           = "ami-04a81a99f5ec58529"
  instance_type = "t2.micro"
  tags = {
    Name = "OpenClassrooms-P8-Webserver-${count.index}"
  }
  vpc_security_group_ids = ["${aws_security_group.my_security_group.id}"]
  key_name               = aws_key_pair.generated_key.key_name
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = tls_private_key.my_ssh_key.private_key_pem
    host        = self.public_ip
  }
  provisioner "remote-exec" {
    script = "./install-webserver.sh"
  }
}

resource "aws_instance" "haproxy" {
  ami           = "ami-04a81a99f5ec58529"
  instance_type = "t2.micro"
  tags = {
    Name = "OpenClassrooms-P8-HAProxy"
  }
  vpc_security_group_ids = ["${aws_security_group.my_security_group.id}"]
  key_name               = aws_key_pair.generated_key.key_name
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = tls_private_key.my_ssh_key.private_key_pem
    host        = self.public_ip
  }
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -y",
      "sudo apt-get install -y haproxy",
    ]
  }
}

resource "aws_security_group" "my_security_group" {
  name = "OpenClassrooms-P8"
  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
  }
  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

variable "generated_key_name" {
  type        = string
  default     = "openclassrooms_devops_p8"
  description = "Key-pair generated by Terraform"
}

resource "tls_private_key" "my_ssh_key" {
  algorithm = "ED25519"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = var.generated_key_name
  public_key = tls_private_key.my_ssh_key.public_key_openssh
}

resource "local_sensitive_file" "pem_file" {
  filename             = pathexpand("~/.ssh/aws_${aws_key_pair.generated_key.key_name}.pem")
  file_permission      = "600"
  directory_permission = "700"
  content              = tls_private_key.my_ssh_key.private_key_pem
}

output "webserver_ssh" {
  value = { for i in aws_instance.webserver : i.tags.Name => "\nPour se connecter au serveur:\n\tssh -i ${local_sensitive_file.pem_file.filename} -o IdentitiesOnly=yes ubuntu@${i.public_dns}" }
}

output "haproxy_ssh" {
  value = "Pour se connecter au serveur 'haproxy':\n\tssh -i ${local_sensitive_file.pem_file.filename} -o IdentitiesOnly=yes ubuntu@${aws_instance.haproxy.public_dns}"
}

output "haproxy_http" {
  value = "Pour accéder au load-balancer:\n\thttp://${aws_instance.haproxy.public_dns}"
}
