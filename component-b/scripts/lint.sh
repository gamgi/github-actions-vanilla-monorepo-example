#!/usr/bin/env bash
set -euxo pipefail
cd "$(dirname $0)/.."

export NODE_ENV="${ENVIRONMENT:-development}"

uv sync --all-extras --dev
uv run pylint src/
