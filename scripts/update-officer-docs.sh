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

# Function to update a file
update_file() {
    local file=$1
    echo -e "${BLUE}Updating $file...${NC}"

    # Create backup
    cp "$file" "$file.bak"

    # Replace full name (cross-platform sed syntax)
    sed -i.tmp "s/Tim Pook/$OFFICER_NAME/g" "$file" && rm -f "$file.tmp"

    # Replace email
    sed -i.tmp "s/tim\.pook@nus\.edu\.sg/$OFFICER_EMAIL/g" "$file" && rm -f "$file.tmp"

    # Replace first name only in CONTRIBUTING.md
    if [[ "$file" == "CONTRIBUTING.md" ]]; then
        sed -i.tmp "s/\bTim\b/$OFFICER_FIRST_NAME/g" "$file" && rm -f "$file.tmp"
    fi

    # Check if file changed
    if diff -q "$file" "$file.bak" > /dev/null; then
        echo "  No changes needed"
        rm "$file.bak"
    else
        echo -e "  ${GREEN}✓ Updated${NC}"
        rm "$file.bak"
    fi
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
