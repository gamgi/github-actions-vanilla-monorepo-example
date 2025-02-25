#!/usr/bin/env bash
set -euxo pipefail
cd "$(dirname $0)/.."

export NODE_ENV="${ENVIRONMENT:-development}"

npm ci --include=dev
npm run lint
