# Imagem de desenvolvimento: ferramentas + Claude Code, sem root
FROM mcr.microsoft.com/devcontainers/typescript-node:22

RUN apt-get update && apt-get install -y --no-install-recommends \
      git curl less procps jq vim \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

ENV NPM_CONFIG_PREFIX=/usr/local/share/npm-global
ENV PATH=$PATH:/usr/local/share/npm-global/bin
RUN mkdir -p /usr/local/share/npm-global /home/node/.claude /workspace \
    && chown -R node:node /usr/local/share/npm-global /home/node/.claude /workspace

USER node
RUN npm install -g @anthropic-ai/claude-code

# Etiqueta do ambiente no prompt
RUN echo 'export PS1="\[\e[30;43m\] DEV CONTAINER \[\e[0m\] \w \$ "' >> /home/node/.bashrc

ENV CLAUDE_CONFIG_DIR=/home/node/.claude
WORKDIR /workspace
