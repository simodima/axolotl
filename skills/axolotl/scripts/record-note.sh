#!/usr/bin/env bash
# Helper script to record an Axolotl retrospective note
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AXOLOTL_CLI="$SCRIPT_DIR/axolotl"

if [ -x "$AXOLOTL_CLI" ]; then
    exec "$AXOLOTL_CLI" record "$@"
else
    chmod +x "$AXOLOTL_CLI"
    exec "$AXOLOTL_CLI" record "$@"
fi
