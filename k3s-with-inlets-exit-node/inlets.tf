#####
# EC2
#####

data "aws_ami" "amazon_linux" {
  most_recent = true
  name_regex  = "^amzn-.*"
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "template_file" "user_data" {
  template = "${file("templates/inlets.tpl")}"

  vars = {
    token = "${var.inlets_token}"
  }
}

resource "aws_instance" "inlets_server" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t2.micro"

  key_name               = aws_key_pair.this.key_name
  vpc_security_group_ids = [aws_security_group.public_sg.id]
  subnet_id              = aws_subnet.public1.id
  associate_public_ip_address = true

  user_data = data.template_file.user_data.rendered

  tags = {
    Name = "inlets_server"
  }
}


##########
# Route 53
##########

resource "aws_route53_record" "inlets" {
  zone_id = var.zone_id
  name    = "*.${var.cluster_name}.${var.dns_domain_name}"
  type    = "A"
  ttl     = "300"
  records = [aws_instance.inlets_server.public_ip]
}
