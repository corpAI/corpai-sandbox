#!/usr/bin/env bash
set -euo pipefail

IMAGE_URI="public.ecr.aws/n8n3b8o3/corpai-sandbox:latest"

if ! command -v docker >/dev/null 2>&1; then
  echo "Docker is required to run CorpAI Sandbox."
  echo "Install Docker Desktop or OrbStack, then run this installer again."
  exit 1
fi

if ! docker info >/dev/null 2>&1; then
  echo "Docker is not running. Start Docker Desktop or OrbStack, then run this installer again."
  exit 1
fi

if [ -S "$HOME/.orbstack/run/docker.sock" ]; then
  DOCKER_SOCKET="$HOME/.orbstack/run/docker.sock"
else
  DOCKER_SOCKET="/var/run/docker.sock"
fi

if [ ! -S "$DOCKER_SOCKET" ]; then
  echo "Could not find a Docker socket at $DOCKER_SOCKET."
  echo "Set DOCKER_SOCKET to your Docker socket path and rerun this script."
  exit 1
fi

if [ -z "${ANTHROPIC_API_KEY:-}" ] && [ -z "${OPENAI_API_KEY:-}" ] && [ -z "${GOOGLE_API_KEY:-}" ]; then
  echo "Set one LLM API key before running CorpAI Sandbox:"
  echo "  export ANTHROPIC_API_KEY=your-key"
  echo "  export OPENAI_API_KEY=your-key"
  echo "  export GOOGLE_API_KEY=your-key"
  exit 1
fi

echo "Pulling CorpAI Sandbox..."
docker pull "$IMAGE_URI"

echo "Starting CorpAI Sandbox..."
docker rm -f corpai-sandbox >/dev/null 2>&1 || true
docker run --rm \
  --name corpai-sandbox \
  -p 3000:3000 \
  -p 8000:8000 \
  -e ANTHROPIC_API_KEY="${ANTHROPIC_API_KEY:-}" \
  -e OPENAI_API_KEY="${OPENAI_API_KEY:-}" \
  -e GOOGLE_API_KEY="${GOOGLE_API_KEY:-}" \
  -e LLM_PROVIDER="${LLM_PROVIDER:-anthropic}" \
  -e LLM_MODEL="${LLM_MODEL:-}" \
  -v "$DOCKER_SOCKET:/var/run/docker.sock" \
  "$IMAGE_URI"
