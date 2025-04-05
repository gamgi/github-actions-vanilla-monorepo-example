FROM node:23-bookworm

# install common tools
RUN apt-get update && apt-get -qq update && apt-get install -qq -y \
        cloc \
        curl \
        shellcheck \
    && apt-get autoremove -y && apt-get clean

ENTRYPOINT ["bash", "-c"]
