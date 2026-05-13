# Smoke Test

Use this checklist to confirm CorpAI Local is running correctly.

## 1. Start CorpAI Local

```bash
docker run --rm \
  -p 3000:3000 \
  -p 8000:8000 \
  -e ANTHROPIC_API_KEY=your-key \
  -v /var/run/docker.sock:/var/run/docker.sock \
  ghcr.io/corpai/corpai-local-release:latest
```

Use the OrbStack socket path if needed:

```bash
-v "$HOME/.orbstack/run/docker.sock:/var/run/docker.sock"
```

## 2. Open the App

Open:

```text
http://127.0.0.1:3000
```

Log in:

```text
Email: admin@example.com
Password: corpai-local
```

## 3. Check API Health

```bash
curl http://127.0.0.1:8000/health
```

## 4. Deploy an MCP Server

In the app:

1. Go to MCP Servers.
2. Open the `time` server.
3. Click Deploy.
4. Wait for the deployment to show as running.

## 5. Invoke a Tool from Chat

Open Chat and ask:

```text
What time is it in Tokyo?
```

Expected result:

- the assistant answers the question
- the response shows a visible tool call similar to `time / get_current_time`

## 6. Inspect Docker

```bash
docker ps
```

You should see:

- the CorpAI Local container
- a Kind control-plane container

## 7. Stop and Restart

Stop the container with `Ctrl+C` if it is running in the foreground.

If you mounted a persistent volume, restart with the same volume and confirm you can log in again.
