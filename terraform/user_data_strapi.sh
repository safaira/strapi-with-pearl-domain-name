#!/bin/bash
sudo apt update
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
nvm install node && sudo apt install -y npm
nvm install 18.0
nvm use 18
sudo apt update -y 
sudo npm install -g yarn pm2
echo -e "skip/n" | sudo npx create-strapi-app@latest saniya-strapi-project --quickstart
cd saniya-strapi-project
echo "const strapi = require('@strapi/strapi'); strapi().start();" | sudo tee server.js > /dev/null
pm2 start server.js
sleep 100
