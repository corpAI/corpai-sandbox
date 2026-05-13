# Configuration

CorpAI Local is configured with environment variables passed to `docker run`.

## LLM Provider

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

## Model Override

To use a specific model, add:

```bash
-e LLM_MODEL=your-model
```

## Security Keys

CorpAI Local uses:

- `JWT_SECRET_KEY` for user sessions
- `ENCRYPTION_KEY` for locally stored credentials and settings

If you do not provide them, CorpAI Local generates and stores them in the local data directory. If you use a persistent Docker volume, the generated keys survive restarts.

To provide your own keys, use exactly 32 characters for `ENCRYPTION_KEY`:

```bash
-e JWT_SECRET_KEY="$(openssl rand -hex 16)" \
-e ENCRYPTION_KEY="$(openssl rand -hex 16)"
```

Keep these keys stable when reusing the same data volume.

## Persistent Data

For persistent local state, mount a Docker volume:

```bash
docker volume create corpai-local-data
```

Then add:

```bash
-v corpai-local-data:/var/lib/postgresql/data
```

This preserves:

- local database state
- generated security keys
- settings
- catalog state
- deployment history

## Ports

CorpAI Local exposes:

- Web app: `3000`
- API server: `8000`

If either port is already in use, map it to another host port:

```bash
-p 3001:3000 \
-p 8001:8000
```

Then open:

```text
http://127.0.0.1:3001
```
