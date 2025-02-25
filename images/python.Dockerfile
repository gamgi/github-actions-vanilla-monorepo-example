FROM python:3.12-bookworm

# install common tools
RUN apt-get update && apt-get -qq update && apt-get install -qq -y \
        cloc \
        curl \
    && apt-get autoremove -y && apt-get clean

# install language specific tools
COPY --from=ghcr.io/astral-sh/uv:0.6.3 /uv /uvx /bin/

ENTRYPOINT ["bash", "-c"]
