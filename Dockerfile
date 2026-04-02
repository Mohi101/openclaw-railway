FROM ghcr.io/openclaw/openclaw:latest

ENV OPENCLAW_GATEWAY_PORT=3000
ENV OPENCLAW_GATEWAY_BIND=lan

EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
  CMD curl -f http://localhost:3000/healthz || exit 1

CMD ["node", "dist/index.js", "gateway", "--port", "3000", "--bind", "lan"]
