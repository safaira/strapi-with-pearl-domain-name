
# fetch AMI id and filter by name and alias and create instance from that id.
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["amazon"]


  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-*-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  # owners = ["amazon"] # Canonical's AWS account ID for official Ubuntu images
}

resource "aws_instance" "SaniyaStrapiEC2" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.small"
  vpc_security_group_ids      = [aws_security_group.strapiEC2-sg.id]

  subnet_id                   = aws_subnet.subnet1.id

  key_name                    = "domain"
  associate_public_ip_address = true
  user_data = file("user_data_strapi.sh")         
  
  tags = {
    Name = "StrapiEC2"
  }
}

resource "aws_security_group" "strapiEC2-sg" {
  vpc_id      = aws_vpc.strapi_vpc.id
  description = "Security Group for Strapi Application"
  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = "1337"
    to_port     = "1337"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = "443"
    to_port     = "443"
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = "80"
    to_port     = "80"
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


  tags = {
    Name = "Strapi-sg"
  }

}

# Main hosted zone
# resource "aws_route53_zone" "main_zone" {
#   name = "strapi.in"
# }

# Subdomain record in the main hosted zone
resource "aws_route53_record" "subdomain" {
  zone_id = var.route53_zone_id
  name    = "saniya.contentecho.in"  
  type    = "A"
  ttl     = 300
  records = [aws_instance.SaniyaStrapiEC2.public_ip]
}

