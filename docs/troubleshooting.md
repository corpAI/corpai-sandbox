# Troubleshooting

## `docker pull` returns `unauthorized`

The release image should be publicly pullable:

```bash
docker pull ghcr.io/corpai/corpai-local-release:latest
```

If this returns `unauthorized`, the GitHub Container Registry package visibility may still be private. Ask the CorpAI team to confirm that the package is public.

## Docker daemon is not running

Start Docker Desktop or OrbStack, then retry:

```bash
docker ps
```

If `docker ps` fails, CorpAI Local will not be able to start or deploy MCP servers.

## Docker socket not found

The Docker socket mount lets CorpAI Local manage the local Kind cluster and MCP server workloads.

Docker Desktop on macOS/Linux usually uses:

```bash
-v /var/run/docker.sock:/var/run/docker.sock
```

OrbStack commonly uses:

```bash
-v "$HOME/.orbstack/run/docker.sock:/var/run/docker.sock"
```

## Browser cannot reach the app

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

## API is not responding

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

## Kind cluster issues

CorpAI Local creates a Kind cluster named `corpai-local`.

Check running containers:

```bash
docker ps
```

Look for a container named like:

```text
corpai-local-control-plane
```

If it is missing, confirm Docker is running and the Docker socket is mounted into the CorpAI Local container.

## LLM responses fail

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

## Reset local state

If you used a persistent volume and want to reset CorpAI Local:

```bash
docker volume rm corpai-local-data
```

Then start CorpAI Local again.
