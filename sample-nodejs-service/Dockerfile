FROM node:carbon
RUN apk add tzdata
RUN cp /usr/share/zoneinfo/Brazil/East /etc/localtime
RUN echo "Brazil/East" > /etc/timezone
WORKDIR /usr/srv/app
COPY package*.json ./
RUN npm install
COPY app.js app.js
COPY index.html index.html
EXPOSE 80
CMD [ "npm", "start"]
