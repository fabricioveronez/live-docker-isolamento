# Isolamento de agentes de IA com Docker

Projeto da live sobre isolamento de agentes de código em dois níveis: **Dev Container** (container)
e **Docker Sandboxes** (microVM). A aplicação é o [Kube News](https://github.com/KubeDev/kube-news):
Node.js, Express e PostgreSQL.

## Estrutura

```
├── Dockerfile                  # imagem de produção
├── compose.yaml                # estrutura principal, próxima de produção (app + database)
├── src/                        # Kube News
└── .devcontainer/
    ├── Dockerfile              # imagem de desenvolvimento, com o Claude Code
    ├── compose.yaml            # override: só o que muda para desenvolvimento
    └── devcontainer.json       # combina os dois composes
```

O `compose.yaml` da raiz descreve o que a aplicação é. O override em `.devcontainer/` descreve só o
que muda no desenvolvimento: imagem com ferramentas, projeto montado, container parado esperando
comandos e um volume para a sessão do Claude Code.

## Produção local

```bash
docker compose up --build
```

Aplicação em http://localhost:8080.

## Três formas de rodar o agente

### A. Agente no host, Dev Container como ambiente

O Dev Container roda a aplicação; o Claude Code roda na sua máquina.

```bash
devcontainer up --workspace-folder .
devcontainer exec --workspace-folder . bash -c "cd src && npm install && npm start"
```

O ambiente está isolado. O agente não.

### B. Agente dentro do Dev Container

Abra o projeto no editor com **Reopen in Container**, ou:

```bash
devcontainer up --workspace-folder .
devcontainer exec --workspace-folder . bash
claude
```

O agente só enxerga o projeto. Em `.devcontainer/compose.yaml` há uma linha comentada que monta o
`~/.claude` do host: troque pela linha do volume e recrie o container para ver o que atravessa.

### C. Agente numa microVM, Dev Container ao lado

Requer o [Docker Sandboxes](https://docs.docker.com/ai/sandboxes/).

```bash
sbx run --name kube-news claude
```

Dentro da sandbox, o agente sobe o mesmo Dev Container no Docker da microVM:

```bash
npm install -g @devcontainers/cli
devcontainer up --workspace-folder .
```

Para acessar a aplicação no navegador do host:

```bash
sbx ports kube-news --publish 8080:8080
```

Destinos de rede bloqueados pela política aparecem em `sbx policy log` e são liberados com
`sbx policy allow network --sandbox kube-news <host>`.

## Créditos

Aplicação: [KubeDev/kube-news](https://github.com/KubeDev/kube-news).
