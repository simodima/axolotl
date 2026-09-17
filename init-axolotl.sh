#!/usr/bin/env bash
# ==============================================================================
# Axolotl Initialization Script
# Sets up ~/.axolotl directories, installs the CLI toolkit, and configures skills.
# ==============================================================================

set -e

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AXOLOTL_HOME="${AXOLOTL_HOME:-$HOME/.axolotl}"
BIN_DEST="$AXOLOTL_HOME/bin"
NOTES_DEST="$AXOLOTL_HOME/notes"
TEMPLATES_DEST="$AXOLOTL_HOME/templates"

# Colors
if [ -t 1 ] && [ -z "$NO_COLOR" ]; then
    C_RESET="\033[0m"
    C_BOLD="\033[1m"
    C_GREEN="\033[32m"
    C_YELLOW="\033[33m"
    C_CYAN="\033[36m"
else
    C_RESET=""
    C_BOLD=""
    C_GREEN=""
    C_YELLOW=""
    C_CYAN=""
fi

echo -e "${C_CYAN}====================================================================${C_RESET}"
echo -e "${C_BOLD}             🦎 Initializing Axolotl Retrospective System           ${C_RESET}"
echo -e "${C_CYAN}====================================================================${C_RESET}"

# 1. Create directory structure
echo -e "\n${C_BOLD}[1/4] Setting up storage directories in $AXOLOTL_HOME...${C_RESET}"
mkdir -p "$NOTES_DEST"
mkdir -p "$TEMPLATES_DEST"
mkdir -p "$BIN_DEST"
echo -e "${C_GREEN}✓${C_RESET} Created $NOTES_DEST"
echo -e "${C_GREEN}✓${C_RESET} Created $TEMPLATES_DEST"
echo -e "${C_GREEN}✓${C_RESET} Created $BIN_DEST"

# 2. Install CLI binary
echo -e "\n${C_BOLD}[2/4] Installing Axolotl CLI tool...${C_RESET}"
if [ -f "$REPO_DIR/bin/axolotl" ]; then
    chmod +x "$REPO_DIR/bin/axolotl"
    cp "$REPO_DIR/bin/axolotl" "$BIN_DEST/axolotl"
    chmod +x "$BIN_DEST/axolotl"
    echo -e "${C_GREEN}✓${C_RESET} Installed executable: $BIN_DEST/axolotl"
else
    echo -e "${C_YELLOW}⚠ Warning:${C_RESET} $REPO_DIR/bin/axolotl not found. Skipping binary copy."
fi

# Ensure workspace scripts are executable
if [ -f "$REPO_DIR/.agents/skills/axolotl/scripts/record-note.sh" ]; then
    chmod +x "$REPO_DIR/.agents/skills/axolotl/scripts/record-note.sh"
    echo -e "${C_GREEN}✓${C_RESET} Made .agents/skills/axolotl/scripts/record-note.sh executable"
fi

# Run axolotl init to set up templates
"$BIN_DEST/axolotl" init >/dev/null 2>&1 || true

# 3. Configure Shell PATH
echo -e "\n${C_BOLD}[3/4] Checking shell PATH configuration...${C_RESET}"
CURRENT_SHELL="$(basename "$SHELL")"
RC_FILE=""

case "$CURRENT_SHELL" in
    zsh)  RC_FILE="$HOME/.zshrc" ;;
    bash) [ -f "$HOME/.bash_profile" ] && RC_FILE="$HOME/.bash_profile" || RC_FILE="$HOME/.bashrc" ;;
    *)    RC_FILE="$HOME/.profile" ;;
esac

PATH_EXPORT='export PATH="$HOME/.axolotl/bin:$PATH"'

if echo "$PATH" | grep -q "$BIN_DEST"; then
    echo -e "${C_GREEN}✓${C_RESET} $BIN_DEST is already in your current PATH"
elif [ -n "$RC_FILE" ] && [ -f "$RC_FILE" ] && grep -q "\.axolotl/bin" "$RC_FILE"; then
    echo -e "${C_GREEN}✓${C_RESET} $BIN_DEST is already configured in $RC_FILE"
else
    if [ -n "$RC_FILE" ]; then
        echo "" >> "$RC_FILE"
        echo "# Axolotl Retrospective CLI" >> "$RC_FILE"
        echo "$PATH_EXPORT" >> "$RC_FILE"
        echo -e "${C_GREEN}✓${C_RESET} Appended Axolotl PATH to $RC_FILE"
        echo -e "${C_YELLOW}ℹ Note:${C_RESET} Run 'source $RC_FILE' or open a new shell to load 'axolotl' directly into PATH."
    fi
fi

# 4. Verification and Self-Test
echo -e "\n${C_BOLD}[4/4] Verifying Axolotl installation...${C_RESET}"
if [ -x "$BIN_DEST/axolotl" ]; then
    "$BIN_DEST/axolotl" --version
    echo -e "${C_GREEN}✓ Verification succeeded!${C_RESET}"
else
    echo -e "${C_YELLOW}⚠ Verification warning: could not execute $BIN_DEST/axolotl${C_RESET}"
fi

echo -e "\n${C_CYAN}====================================================================${C_RESET}"
echo -e "${C_BOLD}✨ Axolotl is ready to observe!${C_RESET}"
echo -e "• Skill documentation: ${C_BOLD}.agents/skills/axolotl/SKILL.md${C_RESET}"
echo -e "• Active rule:         ${C_BOLD}.agents/rules/axolotl.md${C_RESET}"
echo -e "• Retrospective notes: ${C_BOLD}$NOTES_DEST${C_RESET}"
echo ""
echo -e "Try running:"
echo -e "  ${C_CYAN}axolotl list${C_RESET}    - View recorded notes"
echo -e "  ${C_CYAN}axolotl stats${C_RESET}   - Show metrics & pattern distribution"
echo -e "  ${C_CYAN}axolotl retro${C_RESET}   - Generate a retrospective agenda"
echo -e "${C_CYAN}====================================================================${C_RESET}\n"
