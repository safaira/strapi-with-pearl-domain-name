#!/bin/bash
sudo apt update -y
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
sudo chmod 764 ~/.nvm/nvm.sh
~/.nvm/nvm.sh
sudo apt install nodejs -y && sudo apt install -y npm
sudo apt update -y && sudo npm install -g pm2
cd /srv/
git clone https://github.com/safaira/strapi.git
cd strapi/
pm2 start npm --name strapi -- run start
sudo pm2 startup systemd

# sudo env PATH=$PATH:/home/ubuntu/.nvm/versions/node/v18.0.0/bin /home/ubuntu/.nvm/versions/node/v18.0.0/lib/node_modules/pm2/bin/pm2 startup systemd -u ubuntu --hp /home/ubuntu
