#!/usr/bin/env bash
# Helper script to record an Axolotl retrospective note
set -e

AXOLOTL_CLI="${HOME}/.axolotl/bin/axolotl"

if [ -x "$AXOLOTL_CLI" ]; then
    exec "$AXOLOTL_CLI" record "$@"
else
    # Fallback to local repo binary if available
    REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
    if [ -x "$REPO_ROOT/bin/axolotl" ]; then
        exec "$REPO_ROOT/bin/axolotl" record "$@"
    else
        echo "Error: Axolotl CLI not found at $AXOLOTL_CLI or $REPO_ROOT/bin/axolotl" >&2
        echo "Please run ./init-axolotl.sh to set up Axolotl." >&2
        exit 1
    fi
fi
