FROM node:18 
WORKDIR /srv/
RUN sudo apt update -y 
COPY . .
RUN npm install -g npm@10.8.1 && npm install -g pm2
EXPOSE 1337
# CMD [ "npm", "start" ]
CMD ["pm2-runtime", "start", "npm", "--", "run", "start"]




