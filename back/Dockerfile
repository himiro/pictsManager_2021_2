FROM node:13

WORKDIR /app
COPY src src
COPY uploads uploads
COPY package*.json ./

RUN ls
RUN npm install

ENTRYPOINT npm run deploy
