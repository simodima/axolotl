#!/usr/bin/env bash
# ==============================================================================
# Axolotl Initialization Script
# Initializes $HOME/.axolotl directory structure and storage locations.
# ==============================================================================

set -e

AXOLOTL_HOME="${AXOLOTL_HOME:-$HOME/.axolotl}"
NOTES_DIR="$AXOLOTL_HOME/notes"

# ANSI Colors
if [ -t 1 ] && [ -z "$NO_COLOR" ]; then
    C_RESET="\033[0m"
    C_BOLD="\033[1m"
    C_GREEN="\033[32m"
    C_CYAN="\033[36m"
else
    C_RESET=""
    C_BOLD=""
    C_GREEN=""
    C_CYAN=""
fi

echo -e "${C_CYAN}====================================================================${C_RESET}"
echo -e "${C_BOLD}             🦎 Initializing Axolotl Storage                        ${C_RESET}"
echo -e "${C_CYAN}====================================================================${C_RESET}"

# Create base directories in $HOME/.axolotl
echo -e "Setting up directory structure in ${C_BOLD}$AXOLOTL_HOME${C_RESET}..."
mkdir -p "$AXOLOTL_HOME"
mkdir -p "$NOTES_DIR"
echo -e "${C_GREEN}✓${C_RESET} Created $AXOLOTL_HOME"
echo -e "${C_GREEN}✓${C_RESET} Created $NOTES_DIR"

# (Future extensible directory hooks can be added here)

echo -e "\n${C_GREEN}✓ Storage initialized successfully!${C_RESET}"
echo -e "Retrospective notes directory: ${C_BOLD}$NOTES_DIR${C_RESET}"
echo -e "${C_CYAN}====================================================================${C_RESET}"
