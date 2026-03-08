#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

if [[ $# -eq 0 ]]; then
  exec "$ROOT/scripts/setup.sh" all --apply
fi

exec "$ROOT/scripts/setup.sh" "$@"
