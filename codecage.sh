#!/bin/bash

# CodeCage - Docker container for Claude Code
# Secure sandbox environment for AI coding assistance

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

IMAGE_NAME="codecage"
CONFIG_DIR="$HOME/.codecage"

echo -e "${BLUE}CodeCage Setup${NC}"
echo "======================="

# Check if Docker is installed and running
if ! command -v docker &> /dev/null; then
    echo -e "${RED}Error: Docker is not installed${NC}"
    exit 1
fi

if ! docker info &> /dev/null; then
    echo -e "${RED}Error: Docker daemon is not running${NC}"
    exit 1
fi

# Create persistent home directory if it doesn't exist
if [ ! -d "$CONFIG_DIR" ]; then
    echo -e "${GREEN}Creating persistent home directory: $CONFIG_DIR${NC}"
    mkdir -p "$CONFIG_DIR"
fi

# Check if image exists, build if not
if ! docker image inspect $IMAGE_NAME &> /dev/null; then
    echo -e "${GREEN}Building Docker image: $IMAGE_NAME${NC}"
    # Build from Dockerfile in current directory
    docker build -t $IMAGE_NAME $(dirname "$0")
    echo -e "${GREEN}Image built successfully${NC}"
else
    echo -e "${BLUE}Using existing image: $IMAGE_NAME${NC}"
fi

# Get current directory name for workspace
WORKSPACE_NAME="${PWD##*/}"

echo -e "${GREEN}Starting container...${NC}"
echo -e "${BLUE}Mounting current directory: $(pwd)${NC}"
echo -e "${BLUE}Workspace name: $WORKSPACE_NAME${NC}"
echo ""
echo -e "${GREEN}Claude Code will start automatically with auto-update${NC}"
echo -e "${BLUE}Running with --dangerously-skip-permissions${NC}"
echo ""

# Run the container
docker run -it --rm \
    -v "$(pwd):/workspace/$WORKSPACE_NAME" \
    -v "$CONFIG_DIR:/home/node" \
    --network="host" \
    -w "/workspace/$WORKSPACE_NAME" \
    --hostname "codecage" \
    --name "codecage-$$" \
    $IMAGE_NAME \
    bash -c "npm update -g @anthropic-ai/claude-code && claude-code --dangerously-skip-permissions"