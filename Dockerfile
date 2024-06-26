FROM strapi/base as BUILD
WORKDIR /srv/app
RUN sudo apt install -y npm 
RUN sudo apt update -y && sudo npm install -g pm2
RUN git clone 
COPY ./app /srv/app
EXPOSE 1337
COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

CMD [ "npm", "start" ]
