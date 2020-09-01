FROM alpine:3.7

RUN apk add curl \
    && curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/master/contrib/install.sh | sh -s -- -b /usr/local/bin \
    && trivy filesystem --exit-code 0 --severity MEDIUM,HIGH --no-progress /
