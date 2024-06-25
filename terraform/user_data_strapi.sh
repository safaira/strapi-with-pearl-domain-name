    #!/bin/bash
    sudo apt update -y
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
    sudo chmod 764 ~/.nvm/nvm.sh
    ~/.nvm/nvm.sh
    nvm install node && sudo apt install -y npm
    nvm install 18.0
    nvm use 18
    sudo apt update -y && sudo npm install -g pm2
    git clone https://github.com/safaira/strapi-ec2.git
    cd strapi
    pm2 start server.js
    pm2 startup systemd -u ubuntu -hp /home/ubuntu/ && pm2 save
    sudo reboot
