#!/bin/bash

# macOS Desktop Icon Changer!! my gift to yewww
# Changes desktop icons to a tortured pikmin or a custom image and manages Icon? in global gitignore

# default image path (looks in same directory as script)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEFAULT_IMAGE="$SCRIPT_DIR/torturedpikmin.png"

# config
IMAGE_PATH="$DEFAULT_IMAGE"
TARGET_TYPE="folders"  # 'folders' or 'all'
SKIP_GITIGNORE=false

# colourrss
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # no colour

# message of use
usage() {
    cat << EOF
Usage: $(basename "$0") [OPTIONS]

Changes desktop icons to a custom image and manages Icon? in global gitignore.

OPTIONS:
    -i, --image PATH        Path to image file (default: torturedpikmin.png in script directory)
    -t, --type TYPE         Target type: 'folders' or 'all' (default: folders)
    -n, --no-gitignore      Skip gitignore modifications
    -h, --help              Show this help message

EXAMPLES:
    $(basename "$0")                                    # Use default image, change folders only
    $(basename "$0") -i ~/my-icon.png -t all           # Custom image, change all items
    $(basename "$0") -i custom.png --no-gitignore      # Skip gitignore modifications

EOF
    exit 0
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -i|--image)
            IMAGE_PATH="$2"
            shift 2
            ;;
        -t|--type)
            TARGET_TYPE="$2"
            shift 2
            ;;
        -n|--no-gitignore)
            SKIP_GITIGNORE=true
            shift
            ;;
        -h|--help)
            usage
            ;;
        *)
            echo -e "${RED}Error: Unknown option $1${NC}"
            usage
            ;;
    esac
done

# check image path
if [[ ! -f "$IMAGE_PATH" ]]; then
    echo -e "${RED}Error: Image file not found: $IMAGE_PATH${NC}"
    exit 1
fi

# check target type
if [[ "$TARGET_TYPE" != "folders" && "$TARGET_TYPE" != "all" ]]; then
    echo -e "${RED}Error: Target type must be 'folders' or 'all'${NC}"
    exit 1
fi

echo -e "${GREEN}Starting icon change process...${NC}"
echo "Image: $IMAGE_PATH"
echo "Target: $TARGET_TYPE"
echo ""

# functin to se icon using osascript
set_icon() {
    local target="$1"
    local img="$2"

    osascript <<EOF 2>&1
use framework "Foundation"
use framework "AppKit"
use scripting additions

set sourcePath to POSIX path of "$img"
set targetPath to POSIX path of "$target"

set imageData to current application's NSImage's alloc()'s initWithContentsOfFile:sourcePath
set ws to current application's NSWorkspace's sharedWorkspace()
set success to ws's setIcon:imageData forFile:targetPath options:0

if success then
    return "success"
else
    return "failed"
end if
EOF

    local result=$?
    if [[ $result -eq 0 ]]; then
        echo -e "  ${GREEN}✓${NC} $(basename "$target")"
        return 0
    else
        echo -e "  ${RED}✗${NC} Failed: $(basename "$target")"
        return 1
    fi
}

# desktop path
DESKTOP="$HOME/Desktop"

# change icons
echo "Changing desktop icons..."
echo ""

if [[ "$TARGET_TYPE" == "folders" ]]; then
    # folders only
    find "$DESKTOP" -maxdepth 1 -type d ! -name "Desktop" ! -name ".*" | while read -r item; do
        set_icon "$item" "$IMAGE_PATH"
    done
else
    # all items (folders and files)
    find "$DESKTOP" -maxdepth 1 ! -name "Desktop" ! -name ".*" ! -name "Icon?" | while read -r item; do
        set_icon "$item" "$IMAGE_PATH"
    done
fi

echo ""

# handle gitignore
if [[ "$SKIP_GITIGNORE" == false ]]; then
    echo "Managing global gitignore..."

    # check if git is installed
    if ! command -v git &> /dev/null; then
        echo -e "${YELLOW}Warning: git not found, skipping gitignore setup${NC}"
    else
        # get current global gitignore path
        GITIGNORE_PATH=$(git config --global core.excludesfile)

        if [[ -z "$GITIGNORE_PATH" ]]; then
            # No global gitignore configured, create one
            GITIGNORE_PATH="$HOME/.gitignore_global"
            echo "Creating global gitignore at: $GITIGNORE_PATH"
            touch "$GITIGNORE_PATH"
            git config --global core.excludesfile "$GITIGNORE_PATH"
            echo -e "${GREEN}✓${NC} Created and configured global gitignore"
        else
            # expnd tilde if present
            GITIGNORE_PATH="${GITIGNORE_PATH/#\~/$HOME}"
            echo "Found global gitignore at: $GITIGNORE_PATH"
        fi

        # check if Icon? already exists in gitignore
        if grep -qF "Icon?" "$GITIGNORE_PATH" 2>/dev/null; then
            echo -e "${GREEN}✓${NC} Icon? already in gitignore"
        else
            # ad Icon? to gitignore if not
            echo "" >> "$GITIGNORE_PATH"
            echo "# macOS custom icon files" >> "$GITIGNORE_PATH"
            echo "Icon?" >> "$GITIGNORE_PATH"
            echo -e "${GREEN}✓${NC} Added Icon? to gitignore"
        fi
    fi
else
    echo -e "${YELLOW}Skipping gitignore modifications (--no-gitignore flag)${NC}"
fi

echo ""
echo -e "${GREEN}YAY! Your desktop icons have been updated.${NC}"
echo -e "${YELLOW}Note: You may need to refresh Finder (Cmd+R) to see changes.${NC}"
