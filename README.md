# CodeCage 🔒

Docker sandbox for Claude Code. Isolated, auto-updating, persistent config.

- 🔒 Only sees current directory
- 🔄 Auto-installs Claude on first run
- 💾 Config persists in Docker volumes
- 🚀 Runs with `--dangerously-skip-permissions`

## Setup

```bash
# Clone and build
git clone https://github.com/YOUR_USERNAME/codecage.git ~/git/codecage
docker build -t codecage ~/git/codecage

# Create volumes for persistent storage
docker volume create codecage-home
docker volume create codecage-cc-home  # For alternative profile

# Add aliases
cat >> ~/.bashrc << 'EOF'
alias codecage='docker run -it --rm \
  -v $(pwd):/workspace/$(basename $(pwd)) \
  -v codecage-home:/home/node \
  --network host \
  --hostname codecage-$(basename $(pwd)) \
  --name codecage-$(basename $(pwd))-$$ \
  codecage \
  claude --dangerously-skip-permissions'
alias codecage-update='cd ~/git/codecage && git pull && docker build -t codecage .'
EOF

source ~/.bashrc
```

## Run

```bash
cd /any/project && codecage  # Starts Claude directly
```

## Update

```bash
codecage-update  # Pull latest changes and rebuild image
```

<details>
<summary>Alternative Profile</summary>

```bash
# Add to ~/.bashrc for different config/API key
alias codecagecc='docker run -it --rm \
  -v $(pwd):/workspace/$(basename $(pwd)) \
  -v codecage-cc-home:/home/node \
  --network host \
  --hostname codecage-$(basename $(pwd)) \
  --name codecage-$(basename $(pwd))-cc-$$ \
  codecage \
  claude --dangerously-skip-permissions'
```
</details>
