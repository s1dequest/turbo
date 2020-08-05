FROM node:10-alpine

ARG GIT_COMMIT=unspecified
LABEL git_commit=$GIT_COMMIT

COPY server.js /server.js
RUN npm install -g redis@2.8.0

CMD tail -f /dev/null
