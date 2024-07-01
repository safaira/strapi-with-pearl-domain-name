# #!/bin/bash
# sudo apt update -y && sudo apt intall docker.io -y
# git clone https://github.com/safaira/strapi.git
# cd strapi/

# # #build strapi image from dockerfile
# # docker build . -t strapi:npm17

# # Log in to Docker Hub to pull the image
# echo $var.DOCKERHUB_PASSWORD | docker login -u $var.DOCKERHUB_USERNAME --password-stdin

# # # tag and push the docker image
# # docker tag strapi:latest saniyashaikh/strapi:npm17
# # docker push saniyashaikh/strapi:npm17

# # run container in detached mode
# docker run -d --name strapi-app -p 1337:1337 saniyashaikh/strapi-app:npm17




# # sudo env PATH=$PATH:/home/ubuntu/.nvm/versions/node/v18.0.0/bin /home/ubuntu/.nvm/versions/node/v18.0.0/lib/node_modules/pm2/bin/pm2 startup systemd -u ubuntu --hp /home/ubuntu


#!/bin/bash
# Update the package index
sudo apt update -y

# Install Docker
sudo apt install docker.io -y

# Start Docker service
sudo service docker start
sudo usermod -a -G docker ubuntu

# Install AWS CLI and jq
sudo apt install -y aws-cli jq

# Retrieve Docker Hub credentials from AWS Secrets Manager
CREDENTIALS=$(aws secretsmanager get-secret-value --secret-id dockerhub_credentials --query SecretString --output text)
DOCKERHUB_USERNAME=$(echo $CREDENTIALS | jq -r '.username')
DOCKERHUB_PASSWORD=$(echo $CREDENTIALS | jq -r '.password')

# Log in to Docker Hub
echo $DOCKERHUB_PASSWORD | sudo docker login -u $DOCKERHUB_USERNAME --password-stdin

# Pull the Docker image from the private repository
docker pull saniyashaikh/strapi-app:npm17

# Run the Docker container
docker run -d --name my_app_container -p 1337:1337 saniyashaikh/strapi-app:npm17
