# CorpAI Sandbox

CorpAI Sandbox is a self-contained local environment for trying CorpAI on your own machine. It runs the CorpAI web app locally, deploys catalog MCP servers into a local Kubernetes sandbox, and lets users interact with those tools through chat using their own LLM API key.

## Requirements

- Docker Desktop, OrbStack, or another Docker-compatible runtime
- Network access to Amazon ECR Public
- An API key from Anthropic, OpenAI, or Google

## Quick Start

Download and run the installer:

```bash
curl -L https://raw.githubusercontent.com/corpAI/corpai-sandbox/main/corpai-sandbox.sh -o corpai-sandbox.sh
chmod +x corpai-sandbox.sh
export ANTHROPIC_API_KEY=your-key
./corpai-sandbox.sh
```

The installer pulls the CorpAI Sandbox image and starts the local container with Docker socket access.

### Manual Docker Run: macOS / Linux

```bash
docker run --rm \
  -p 3000:3000 \
  -p 8000:8000 \
  -e ANTHROPIC_API_KEY=your-key \
  -v /var/run/docker.sock:/var/run/docker.sock \
  public.ecr.aws/n8n3b8o3/corpai-sandbox:latest
```

### Manual Docker Run: OrbStack

If your Docker socket is managed by OrbStack, use:

```bash
docker run --rm \
  -p 3000:3000 \
  -p 8000:8000 \
  -e ANTHROPIC_API_KEY=your-key \
  -v "$HOME/.orbstack/run/docker.sock:/var/run/docker.sock" \
  public.ecr.aws/n8n3b8o3/corpai-sandbox:latest
```

### Manual Docker Run: Windows PowerShell

```powershell
docker run --rm `
  -p 3000:3000 `
  -p 8000:8000 `
  -e ANTHROPIC_API_KEY=your-key `
  -v //./pipe/docker_engine:/var/run/docker.sock `
  public.ecr.aws/n8n3b8o3/corpai-sandbox:latest
```

## LLM Providers

Anthropic is the default provider:

```bash
-e ANTHROPIC_API_KEY=your-key
```

OpenAI:

```bash
-e LLM_PROVIDER=openai \
-e OPENAI_API_KEY=your-key
```

Google Gemini:

```bash
-e LLM_PROVIDER=google \
-e GOOGLE_API_KEY=your-key
```

To use a specific model, add:

```bash
-e LLM_MODEL=your-model
```

## Persistent Local State

For a trial that survives container restarts, create a named Docker volume:

```bash
docker volume create corpai-sandbox-data
```

Then add it to the run command:

```bash
-v corpai-sandbox-data:/var/lib/postgresql/data
```

Example:

```bash
docker run --rm \
  -p 3000:3000 \
  -p 8000:8000 \
  -e ANTHROPIC_API_KEY=your-key \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v corpai-sandbox-data:/var/lib/postgresql/data \
  public.ecr.aws/n8n3b8o3/corpai-sandbox:latest
```

This preserves local database state, generated security keys, settings, catalog state, and deployment history.

## Open CorpAI Sandbox

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

The Docker socket mount lets CorpAI Sandbox create and manage the Kind cluster and MCP server workloads on your machine.

## Smoke Test

Use this checklist to confirm CorpAI Sandbox is running correctly.

1. Open `http://127.0.0.1:3000`.
2. Log in with the default credentials.
3. Go to MCP Servers.
4. Deploy the `time` MCP server.
5. Open Chat.
6. Ask:

```text
What time is it in Tokyo?
```

Expected result:

- the assistant answers the question
- the response shows a visible tool call similar to `time / get_current_time`

## Useful Checks

Check the API health endpoint:

```bash
curl http://127.0.0.1:8000/health
```

Check running containers:

```bash
docker ps
```

You should see the CorpAI Sandbox container and a Kind control-plane container.

## Troubleshooting

### `docker pull` returns `unauthorized`

The release image should be publicly pullable:

```bash
docker pull public.ecr.aws/n8n3b8o3/corpai-sandbox:latest
```

If this returns `unauthorized`, ask the CorpAI team to confirm that the Amazon ECR Public image is published and available.

### Docker daemon is not running

Start Docker Desktop or OrbStack, then retry:

```bash
docker ps
```

If `docker ps` fails, CorpAI Sandbox will not be able to start or deploy MCP servers.

### Docker socket not found

Docker Desktop on macOS/Linux usually uses:

```bash
-v /var/run/docker.sock:/var/run/docker.sock
```

OrbStack commonly uses:

```bash
-v "$HOME/.orbstack/run/docker.sock:/var/run/docker.sock"
```

### Browser cannot reach the app

Use:

```text
http://127.0.0.1:3000
```

If port `3000` is already in use, map another host port:

```bash
-p 3001:3000
```

Then open:

```text
http://127.0.0.1:3001
```

### API is not responding

Check:

```bash
curl http://127.0.0.1:8000/health
```

If port `8000` is already in use, map another host port:

```bash
-p 8001:8000
```

Then check:

```bash
curl http://127.0.0.1:8001/health
```

### Kind cluster issues

CorpAI Sandbox creates a Kind cluster named `corpai-local`.

Check running containers:

```bash
docker ps
```

Look for a container named like:

```text
corpai-local-control-plane
```

If it is missing, confirm Docker is running and the Docker socket is mounted into the CorpAI Sandbox container.

### LLM responses fail

Confirm that the right provider variables are set.

Anthropic:

```bash
-e ANTHROPIC_API_KEY=your-key
```

OpenAI:

```bash
-e LLM_PROVIDER=openai \
-e OPENAI_API_KEY=your-key
```

Google Gemini:

```bash
-e LLM_PROVIDER=google \
-e GOOGLE_API_KEY=your-key
```

## Cleanup

Stop the CorpAI Sandbox container with `Ctrl+C` if it is running in the foreground.

If you created a persistent volume and want to remove all local state:

```bash
docker volume rm corpai-sandbox-data
```
