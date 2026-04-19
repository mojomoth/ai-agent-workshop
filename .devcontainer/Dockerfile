# .devcontainer/Dockerfile
FROM mcr.microsoft.com/devcontainers/base:ubuntu

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    curl \
    git \
    jq \
    ripgrep \
    fd-find \
    tmux \
    unzip \
    zip \
    python3 \
    python3-pip \
    python3-venv \
    build-essential \
    ca-certificates \
    gnupg \
    && rm -rf /var/lib/apt/lists/*

# Node 설치
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get update && apt-get install -y nodejs \
    && npm install -g npm

# AI coding agent 설치
RUN npm install -g \
    @anthropic-ai/claude-code \
    @openai/codex \
    opencode-ai

# 편의
RUN usermod -s /bin/bash vscode

# XDG 디렉터리를 vscode 소유로 미리 생성
# (bind mount 시 Docker 가 부모 경로를 root 소유로 자동 생성하는 문제 방지)
RUN mkdir -p \
        /home/vscode/.claude \
        /home/vscode/.codex \
        /home/vscode/.config/opencode \
        /home/vscode/.cache/opencode \
        /home/vscode/.local/share/opencode \
        /home/vscode/.local/state/opencode \
    && chown -R vscode:vscode \
        /home/vscode/.claude \
        /home/vscode/.codex \
        /home/vscode/.config \
        /home/vscode/.cache \
        /home/vscode/.local

WORKDIR /app