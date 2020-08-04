FROM node:10-alpine

ARG GIT_COMMIT=unspecified
LABEL git_commit=$GIT_COMMIT

COPY server.js /server.js

COPY package.json /
RUN npm install

CMD node /server.js
