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
  instance_type          = "t2.micro"

  key_name               = aws_key_pair.this.key_name
  vpc_security_group_ids = [aws_security_group.public_sg.id]
  subnet_id              = aws_subnet.public1.id
  associate_public_ip_address = true

  tags = {
    Name = "k3s_master"
  }
}

resource "aws_instance" "k3s_node1" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"

  key_name               = aws_key_pair.this.key_name
  vpc_security_group_ids = [aws_security_group.public_sg.id]
  subnet_id              = aws_subnet.public1.id
  associate_public_ip_address = true

  tags = {
    Name = "k3s_node1"
  }
}

resource "aws_instance" "k3s_node2" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"

  key_name               = aws_key_pair.this.key_name
  vpc_security_group_ids = [aws_security_group.public_sg.id]
  subnet_id              = aws_subnet.public1.id
  associate_public_ip_address = true

  tags = {
    Name = "k3s_node2"
  }
}
