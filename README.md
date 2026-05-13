# CorpAI Local

CorpAI Local is a self-contained sandbox for trying CorpAI on your own machine. It lets you run the CorpAI web app locally, deploy catalog MCP servers into a local Kubernetes sandbox, and use those tools through chat with your own LLM API key.

## Requirements

- Docker Desktop, OrbStack, or another Docker-compatible runtime
- An API key from Anthropic, OpenAI, or Google

## Quick Start

### macOS / Linux

```bash
docker run --rm \
  -p 3000:3000 \
  -p 8000:8000 \
  -e ANTHROPIC_API_KEY=your-key \
  -v /var/run/docker.sock:/var/run/docker.sock \
  ghcr.io/corpai/corpai-local-release:latest
```

### OrbStack

If your Docker socket is managed by OrbStack, use:

```bash
docker run --rm \
  -p 3000:3000 \
  -p 8000:8000 \
  -e ANTHROPIC_API_KEY=your-key \
  -v "$HOME/.orbstack/run/docker.sock:/var/run/docker.sock" \
  ghcr.io/corpai/corpai-local-release:latest
```

### Windows PowerShell

```powershell
docker run --rm `
  -p 3000:3000 `
  -p 8000:8000 `
  -e ANTHROPIC_API_KEY=your-key `
  -v //./pipe/docker_engine:/var/run/docker.sock `
  ghcr.io/corpai/corpai-local-release:latest
```

## LLM Providers

Anthropic is the default provider:

```bash
-e ANTHROPIC_API_KEY=your-key
```

For OpenAI:

```bash
-e LLM_PROVIDER=openai \
-e OPENAI_API_KEY=your-key
```

For Google Gemini:

```bash
-e LLM_PROVIDER=google \
-e GOOGLE_API_KEY=your-key
```

## Persistent Local State

For a trial that survives container restarts, create a named Docker volume:

```bash
docker volume create corpai-local-data
```

Then add it to the run command:

```bash
-v corpai-local-data:/var/lib/postgresql/data
```

This preserves local database state, generated security keys, settings, and deployment history.

## Open CorpAI Local

After the container starts, open:

```text
http://127.0.0.1:3000
```

Default login:

```text
Email: admin@example.com
Password: corpai-local
```

The API documentation is available at:

```text
http://127.0.0.1:8000/docs
```

## What Starts Locally

The container starts:

- CorpAI web application on port `3000`
- CorpAI API server on port `8000`
- PostgreSQL
- A local Kind Kubernetes cluster named `corpai-local`
- A Kubernetes namespace named `corpai-local`

The Docker socket mount lets CorpAI Local create and manage the Kind cluster and MCP server workloads on your machine.

## Smoke Test

To verify the local sandbox:

1. Open CorpAI Local in your browser.
2. Log in with the default credentials.
3. Go to MCP Servers.
4. Deploy the `time` MCP server.
5. Open Chat.
6. Ask:

```text
What time is it in Tokyo?
```

You should see a response that includes a visible tool call similar to:

```text
time / get_current_time
```

## Useful Checks

Check the API health endpoint:

```bash
curl http://127.0.0.1:8000/health
```

Check running containers:

```bash
docker ps
```

You should see the CorpAI Local container and a Kind control-plane container.

## Cleanup

Stop the CorpAI Local container with `Ctrl+C` if running in the foreground.

If you created a persistent volume and want to remove all local state:

```bash
docker volume rm corpai-local-data
```

