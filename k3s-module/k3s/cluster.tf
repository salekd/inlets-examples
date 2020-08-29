#####
# EC2
#####

data "aws_ami" "ubuntu" {
  most_recent = true
  owners = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
}

resource "aws_instance" "k3s_master" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type

  key_name               = aws_key_pair.this.key_name
  vpc_security_group_ids = [aws_security_group.public_sg.id]
  subnet_id              = aws_subnet.public1.id
  associate_public_ip_address = true

  user_data = <<EOF
#!/bin/bash
curl -sfL https://get.k3s.io | K3S_TOKEN=${var.k3s_token} INSTALL_K3S_EXEC="server --no-deploy traefik" sh -s -
EOF

  tags = {
    Name = "K3s master"
  }
}

resource "aws_instance" "k3s_node" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  count                  = var.num_workers

  key_name               = aws_key_pair.this.key_name
  vpc_security_group_ids = [aws_security_group.public_sg.id]
  subnet_id              = aws_subnet.public1.id
  associate_public_ip_address = true

  user_data = <<EOF
#!/bin/bash
curl -sfL https://get.k3s.io | K3S_URL=https://${aws_instance.k3s_master.private_ip}:6443 K3S_TOKEN=${var.k3s_token} INSTALL_K3S_EXEC="agent --node-external-ip `curl http://169.254.169.254/latest/meta-data/public-ipv4`" sh -s -
EOF

  tags = {
    Name = "K3s node ${count.index}"
  }

  depends_on = [aws_instance.k3s_master]
}
