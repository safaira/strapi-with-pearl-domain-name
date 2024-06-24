<<EOF
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
sleep 100 
# pm2 start npm --name strapi -- run start 
# pm2 monitor && pm2 startup                           
EOF  

# sudo env PATH=$PATH:/home/ubuntu/.nvm/versions/node/v18.0.0/bin /home/ubuntu/.nvm/versions/node/v18.0.0/lib/node_modules/pm2/bin/pm2 startup systemd -u ubuntu --hp /home/ubuntu