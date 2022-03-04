# Container image that runs your code
FROM alpine:3.10

RUN apk add jq

# Copies your code file from your action repository to the filesystem path `/` of the container
COPY entrypoint.sh /entrypoint.sh
COPY createModule.sh /createModule.sh
COPY module.tar.gz /module.tar.gz

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]