# Installation

This guide walks through installing and starting CorpAI Local from the public release image.

## Requirements

- Docker Desktop, OrbStack, or another Docker-compatible runtime
- Network access to GitHub Container Registry
- An API key from Anthropic, OpenAI, or Google

## Pull the Image

```bash
docker pull ghcr.io/corpai/corpai-local-release:latest
```

## macOS / Linux

```bash
docker run --rm \
  -p 3000:3000 \
  -p 8000:8000 \
  -e ANTHROPIC_API_KEY=your-key \
  -v /var/run/docker.sock:/var/run/docker.sock \
  ghcr.io/corpai/corpai-local-release:latest
```

## OrbStack

OrbStack often exposes the Docker socket at a user-specific path:

```bash
docker run --rm \
  -p 3000:3000 \
  -p 8000:8000 \
  -e ANTHROPIC_API_KEY=your-key \
  -v "$HOME/.orbstack/run/docker.sock:/var/run/docker.sock" \
  ghcr.io/corpai/corpai-local-release:latest
```

## Windows PowerShell

```powershell
docker run --rm `
  -p 3000:3000 `
  -p 8000:8000 `
  -e ANTHROPIC_API_KEY=your-key `
  -v //./pipe/docker_engine:/var/run/docker.sock `
  ghcr.io/corpai/corpai-local-release:latest
```

## Persistent Local State

Create a Docker volume:

```bash
docker volume create corpai-local-data
```

Then include it in the run command:

```bash
-v corpai-local-data:/var/lib/postgresql/data
```

Example:

```bash
docker run --rm \
  -p 3000:3000 \
  -p 8000:8000 \
  -e ANTHROPIC_API_KEY=your-key \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v corpai-local-data:/var/lib/postgresql/data \
  ghcr.io/corpai/corpai-local-release:latest
```

## Open CorpAI Local

Open:

```text
http://127.0.0.1:3000
```

Default login:

```text
Email: admin@example.com
Password: corpai-local
```

## Verify Services

Check the API:

```bash
curl http://127.0.0.1:8000/health
```

Check containers:

```bash
docker ps
```

You should see the CorpAI Local container and a Kind control-plane container.
