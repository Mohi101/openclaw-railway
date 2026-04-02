FROM ghcr.io/openclaw/openclaw:latest

ENV OPENCLAW_GATEWAY_PORT=3000
ENV OPENCLAW_GATEWAY_BIND=lan
ENV NODE_ENV=production

EXPOSE 3000

# Create workspace and config
RUN mkdir -p /home/node/.openclaw/workspace && \
    echo '{"gateway":{"port":3000,"bind":"lan","mode":"local"}}' > /home/node/.openclaw/openclaw.json

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=120s --retries=5 \
  CMD curl -f http://localhost:3000/healthz || exit 1

# Start gateway with proper flags
CMD ["node", "dist/index.js", "gateway", "--port", "3000", "--bind", "lan", "--allow-unconfigured"]
