
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
sudo apt update -y -y && sudo npm install -g pm2
git clone https://github.com/safaira/Terraform-Strapi-EC2Deployment.git
pm2 start npm --name strapi -- run start
sudo pm2 startup systemd

# sudo env PATH=$PATH:/home/ubuntu/.nvm/versions/node/v18.0.0/bin /home/ubuntu/.nvm/versions/node/v18.0.0/lib/node_modules/pm2/bin/pm2 startup systemd -u ubuntu --hp /home/ubuntu
