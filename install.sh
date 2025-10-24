#!/bin/bash

# Pikminify Installer
# Downloads and runs the icon changer script

set -e

REPO_URL="https://raw.githubusercontent.com/v-vacuum/pikminify/main"
INSTALL_DIR="$HOME/.pikminify"

# colours
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}installing pikminify...${NC}"
echo ""

# create install directory
mkdir -p "$INSTALL_DIR"

# download script
echo "downloading icon-changer.sh..."
if curl -fsSL "$REPO_URL/icon-changer.sh" -o "$INSTALL_DIR/icon-changer.sh"; then
    echo -e "${GREEN}✓${NC} downloaded script"
else
    echo -e "${RED}✗${NC} failed to download script"
    exit 1
fi

# download icon
echo "downloading torturedpikmin.png..."
if curl -fsSL "$REPO_URL/torturedpikmin.png" -o "$INSTALL_DIR/torturedpikmin.png"; then
    echo -e "${GREEN}✓${NC} downloaded icon"
else
    echo -e "${RED}✗${NC} failed to download icon"
    exit 1
fi

echo ""
echo -e "${GREEN}installation complete!${NC}"
echo ""
echo "running pikminify..."
echo ""

# run script
bash "$INSTALL_DIR/icon-changer.sh" "$@"

echo ""
echo -e "${YELLOW}tip: files installed to $INSTALL_DIR${NC}"
echo -e "${YELLOW}run again with: bash $INSTALL_DIR/icon-changer.sh${NC}"
