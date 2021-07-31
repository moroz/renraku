FROM node:latest

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y install inotify-tools

WORKDIR /app

COPY package.json yarn.lock /

RUN yarn install

CMD yarn watch

