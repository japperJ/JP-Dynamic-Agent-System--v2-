#!/bin/bash
# JP Dynamic Agent System (v2) Installation Script
# Downloads essential files from GitHub to set up a new repository

set -e

# Configuration
GITHUB_BASE="https://raw.githubusercontent.com/japperJ/JP-Dynamic-Agent-System--v2-/main"
TARGET_PATH="${1:-.}"
SUCCESS_COUNT=0
FAIL_COUNT=0
FAILED_FILES=()

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Essential files to download
FILES_TO_DOWNLOAD=(
    # Agents
    ".github/agents/orchestrator.agent.md"
    ".github/agents/researcher.agent.md"
    ".github/agents/planner.agent.md"
    ".github/agents/coder.agent.md"
    ".github/agents/verifier.agent.md"
    ".github/agents/debugger.agent.md"
    ".github/agents/designer.agent.md"
    
    # Skills
    ".github/skills/extension-coordinator/SKILL.md"
    ".github/skills/extension-verifier/SKILL.md"
    
    # Extension Planning
    ".planning/extensions/EDR_TEMPLATE.md"
    ".planning/extensions/REGISTRY.yaml"
    ".planning/extensions/DECISION_RULES.md"
    ".planning/extensions/WIRING_CONTRACT.md"
    ".planning/extensions/ADDITIVE_ONLY.md"
    ".planning/extensions/edr/EDR-20260218-0001-extension-coordinator.md"
    ".planning/extensions/edr/EDR-20260218-0002-extension-verifier.md"
    
    # Baseline
    ".planning/baseline/P0_INVARIANTS.yaml"
    ".planning/baseline/CHANGE_GATES.md"
    ".planning/baseline/TOOL_FALLBACKS.md"
    
    # Research
    ".planning/research/SUMMARY.md"
    ".planning/research/ARCHITECTURE.md"
    
    # Planning
    ".planning/REQUIREMENTS.md"
    ".planning/ROADMAP.md"
    
    # Root
    "README.md"
)

echo -e "\n${CYAN}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║  JP Dynamic Agent System (v2) - Installation Script          ║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════════════════════════╝${NC}\n"

echo -e "Target Directory: ${YELLOW}$(cd "$TARGET_PATH" 2>/dev/null && pwd || echo "$TARGET_PATH")${NC}"
echo -e "Files to Download: ${YELLOW}${#FILES_TO_DOWNLOAD[@]}${NC}"
echo ""

# Create base directory if needed
mkdir -p "$TARGET_PATH"
cd "$TARGET_PATH"

# Download each file
for file in "${FILES_TO_DOWNLOAD[@]}"; do
    url="$GITHUB_BASE/$file"
    
    echo -ne "Downloading: ${CYAN}$file${NC} ... "
    
    # Create directory if it doesn't exist
    dir=$(dirname "$file")
    mkdir -p "$dir"
    
    # Download with curl
    if curl -L -f -s -o "$file" "$url" 2>/dev/null; then
        echo -e "${GREEN}✓${NC}"
        ((SUCCESS_COUNT++))
    else
        http_code=$(curl -L -s -o /dev/null -w "%{http_code}" "$url" 2>/dev/null)
        if [ "$http_code" = "404" ]; then
            echo -e "${RED}✗ (404 Not Found)${NC}"
        else
            echo -e "${RED}✗ (HTTP $http_code)${NC}"
        fi
        ((FAIL_COUNT++))
        FAILED_FILES+=("$file")
    fi
done

# Summary
echo -e "\n${CYAN}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║  Installation Summary                                        ║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════════════════════════╝${NC}\n"

echo -e "Successfully downloaded: ${GREEN}$SUCCESS_COUNT${NC} / ${#FILES_TO_DOWNLOAD[@]} files"

if [ $FAIL_COUNT -gt 0 ]; then
    echo -e "Failed to download: ${RED}$FAIL_COUNT${NC} files"
    echo -e "\n${YELLOW}Failed files:${NC}"
    for failed_file in "${FAILED_FILES[@]}"; do
        echo -e "  ${RED}- $failed_file${NC}"
    done
fi

echo ""

if [ $SUCCESS_COUNT -eq ${#FILES_TO_DOWNLOAD[@]} ]; then
    echo -e "${GREEN}✓ Installation complete!${NC} ${WHITE}All essential files downloaded successfully.${NC}"
    echo -e "\n${CYAN}Next steps:${NC}"
    echo -e "  ${WHITE}1. Initialize git repository: git init${NC}"
    echo -e "  ${WHITE}2. Review and customize .github/agents/*.agent.md for your needs${NC}"
    echo -e "  ${WHITE}3. Start planning your project with the Orchestrator agent${NC}"
    exit 0
elif [ $SUCCESS_COUNT -gt 0 ]; then
    echo -e "${YELLOW}⚠ Partial installation completed.${NC}"
    echo -e "${YELLOW}Some files failed to download. Please check the errors above.${NC}"
    exit 1
else
    echo -e "${RED}✗ Installation failed!${NC}"
    echo -e "${RED}No files were downloaded. Please check your internet connection and try again.${NC}"
    exit 1
fi
