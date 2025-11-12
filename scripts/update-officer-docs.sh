#!/bin/bash
# Script to update documentation files with officer information from config
# Run this after updating .github/officer-config.yml

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}Updating documentation with officer information...${NC}"

# Read officer config
OFFICER_NAME=$(sed -n '/^officer:/,/^[a-z]/p' .github/officer-config.yml | grep '  name:' | sed 's/.*name: *"\([^"]*\)".*/\1/')
OFFICER_EMAIL=$(grep 'email:' .github/officer-config.yml | sed 's/.*email: *"\([^"]*\)".*/\1/')
OFFICER_USERNAME=$(grep 'github_username:' .github/officer-config.yml | sed 's/.*github_username: *"\([^"]*\)".*/\1/')
OFFICER_FIRST_NAME=$(echo "$OFFICER_NAME" | awk '{print $1}')

echo "Officer Name: $OFFICER_NAME"
echo "Officer Email: $OFFICER_EMAIL"
echo "Officer Username: @$OFFICER_USERNAME"
echo "Officer First Name: $OFFICER_FIRST_NAME"
echo ""

export OFFICER_NAME OFFICER_EMAIL OFFICER_USERNAME OFFICER_FIRST_NAME

# Function to update a file
update_file() {
    local file=$1
    echo -e "${BLUE}Updating $file...${NC}"

    # Create backup
    cp "$file" "$file.bak"

    TARGET_FILE="$file" python3 <<'PY'
import os
import pathlib
import re

file_path = pathlib.Path(os.environ["TARGET_FILE"])
text = file_path.read_text()
original = text

officer_name = os.environ["OFFICER_NAME"]
officer_email = os.environ["OFFICER_EMAIL"]
officer_first = os.environ["OFFICER_FIRST_NAME"]

text = text.replace("Tim Pook", officer_name)
text = text.replace("tim.pook@nus.edu.sg", officer_email)

if file_path.name == "CONTRIBUTING.md":
    text = re.sub(r"\bTim\b", officer_first, text)

if text != original:
    file_path.write_text(text)
PY

    # Check if file changed
    if diff -q "$file" "$file.bak" > /dev/null; then
        echo "  No changes needed"
    else
        echo -e "  ${GREEN}✓ Updated${NC}"
    fi
    rm "$file.bak"
}

# Update files
update_file "README.md"
update_file "CONTRIBUTING.md"
update_file "docs/faq.md"

echo ""
echo -e "${GREEN}✓ Documentation update complete!${NC}"
echo ""
echo "Next steps:"
echo "1. Review the changes: git diff"
echo "2. Commit: git add . && git commit -m 'Update officer information in docs'"
echo "3. Push: git push"
