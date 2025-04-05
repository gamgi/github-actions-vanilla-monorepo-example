FROM python:3.12-bookworm

# install common tools
RUN apt-get update && apt-get -qq update && apt-get install -qq -y \
        cloc \
        curl \
        shellcheck \
    && apt-get autoremove -y && apt-get clean

# install language specific tools
COPY --from=ghcr.io/astral-sh/uv:0.6.7 /uv /uvx /bin/
ENV UV_LINK_MODE=copy
ENV UV_PYTHON=python3.12

ENTRYPOINT ["bash", "-c"]
