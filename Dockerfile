FROM ghcr.io/openclaw/openclaw:latest

ENV OPENCLAW_GATEWAY_PORT=18789
ENV OPENCLAW_GATEWAY_BIND=lan
ENV NODE_ENV=production
ENV HOME=/home/node

WORKDIR /home/node

EXPOSE 18789

# Create proper directory structure and minimal config
RUN mkdir -p /home/node/.openclaw/workspace && \
    chmod -R 755 /home/node/.openclaw && \
    cat > /home/node/.openclaw/openclaw.json << 'EOF'
{
  "gateway": {
    "port": 18789,
    "bind": "lan",
    "mode": "local",
    "auth": "none"
  },
  "models": {
    "defaults": {
      "provider": "openai",
      "model": "gpt-4o"
    }
  },
  "agents": {
    "defaults": {
      "sandbox": {
        "mode": "off"
      }
    }
  }
}
EOF

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=120s --retries=5 \
  CMD curl -f http://localhost:18789/healthz || exit 1

# Start gateway
CMD ["node", "dist/index.js", "gateway", "--port", "18789", "--bind", "lan"]
