FROM node:20-slim

# Install basic tools including sudo
RUN apt-get update && apt-get install -y \
    git \
    curl \
    vim \
    procps \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Configure sudo for the node user (passwordless sudo)
RUN echo "node ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Ensure node user has access to npm global directory
RUN mkdir -p /usr/local/share/npm-global && \
    chown -R node:node /usr/local/share

# Create workspace directory with proper permissions
RUN mkdir -p /workspace && \
    chown -R node:node /workspace

# Switch to node user (already exists in node:20-slim)
USER node

# Set npm global directory and update PATH
ENV NPM_CONFIG_PREFIX=/usr/local/share/npm-global
ENV PATH=/usr/local/share/npm-global/bin:$PATH

# Create npm cache directory to avoid permission issues
RUN mkdir -p /home/node/.npm

# Claude Code will be installed on first run in the persistent home directory
# This ensures it works properly and can be updated easily

WORKDIR /workspace

# Set up bash prompt
RUN echo 'PS1="🔒 codecage:\\w\\$ "' >> ~/.bashrc && \
    echo 'export PATH=$PATH:/usr/local/share/npm-global/bin' >> ~/.bashrc

# Switch to root to copy entrypoint, then back to node
USER root
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
USER node

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/bin/bash"]