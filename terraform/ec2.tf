resource "aws_instance" "strapi-ec2" {
  ami                         = var.ami
  instance_type               = "t2.small"
  vpc_security_group_ids      = [aws_security_group.strapiEC2-sg.id]

  subnet_id                   = aws_subnet.subnet1.id

  key_name                    = "k8-key-pair"
  associate_public_ip_address = true
  user_data                      = <<-EOF
                                  #!/bin/bash
                                  sudo apt update
                                  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
                                  export NVM_DIR="$HOME/.nvm"
                                  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
                                  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
                                  sudo chmod 764 ~/.nvm/nvm.sh
                                  ~/.nvm/nvm.sh
                                  nvm install node && sudo apt install -y npm
                                  nvm install 18.0
                                  nvm use 18
                                  sudo apt update -y
                                  echo -e "skip/n" | npx create-strapi-app@latest saniya-strapi-project --quickstart
                                  npm install pm2 -g
                                  cd saniya-strapi-project
                                  echo "const strapi = require('@strapi/strapi');
                                  strapi().start();" > server.js
                                  pm2 start server.js  
                                  pm2 start npm --name strapi -- run start
                                  sleep 360                            
                                  EOF         
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



