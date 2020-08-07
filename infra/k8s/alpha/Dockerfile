FROM node:10-alpine

WORKDIR /app

ARG GIT_COMMIT=unspecified
LABEL git_commit=$GIT_COMMIT

COPY package.json package.json
COPY package-lock.json package-lock.json
COPY server.js server.js

RUN npm install redis@2.8.0

CMD node server.js
