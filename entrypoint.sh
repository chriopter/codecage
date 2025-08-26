#!/bin/bash
# Set npm to use home directory for global installs
export NPM_CONFIG_PREFIX=~/.npm-global
export PATH=~/.npm-global/bin:/usr/local/share/npm-global/bin:$PATH

# Install Claude on first run
if [ ! -f ~/.claude-installed ]; then
  echo "First run - installing Claude Code..."
  mkdir -p ~/.npm-global
  npm install -g @anthropic-ai/claude-code && touch ~/.claude-installed
fi

# If the command is 'claude', use the one in home
if [ "$1" = "claude" ]; then
  shift
  exec ~/.npm-global/bin/claude "$@"
else
  # Execute other commands normally
  exec "$@"
fi