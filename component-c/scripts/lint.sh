#!/usr/bin/env bash
set -euxo pipefail
cd "$(dirname $0)/.."

uv sync --all-extras --dev
uv run pylint src/
