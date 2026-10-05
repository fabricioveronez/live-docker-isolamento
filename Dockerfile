# Imagem de produção do Kube News
FROM node:22-slim

WORKDIR /app

COPY src/package*.json ./
RUN npm ci --omit=dev

COPY src/ ./

USER node
EXPOSE 8080
CMD ["node", "server.js"]
