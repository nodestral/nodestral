# Nodestral Docs

Internal documentation for [Nodestral](https://nodestral.web.id) — VPS fleet management SaaS.

> **⚠️ This repo is private.** Contains moat features, architecture decisions, and design docs not exposed in the public repos.

## Contents

| Document | Description |
|----------|-------------|
| [ARCHITECTURE](ARCHITECTURE.md) | Technical architecture & design (full SaaS stack) |
| [PRD](PRD.md) | Product Requirements Document |
| [ROADMAP](ROADMAP.md) | Development roadmap & milestones |
| [MOAT](MOAT.md) | Moat strategy — what's public vs private and why |
| [DESIGN-DECISIONS](DESIGN-DECISIONS.md) | Key technical and product decisions |

## Repos

### Public (Community Edition)

| Repo | Description |
|------|-------------|
| [nodestral/nodestral](https://github.com/nodestral/nodestral) | Public repo — project overview, deploy configs |
| [nodestral/agent](https://github.com/nodestral/agent) | Go agent — public, no terminal code |
| [nodestral/backend](https://github.com/nodestral/backend) | Community backend — SQLite, self-hostable |
| [nodestral/dashboard](https://github.com/nodestral/dashboard) | Community dashboard — Next.js |

### Private (SaaS Platform)

| Repo | Description |
|------|-------------|
| [nodestral/api](https://github.com/nodestral/api) | SaaS API — Supabase + TimescaleDB, billing, admin |
| [nodestral/web](https://github.com/nodestral/web) | SaaS dashboard — full feature set |
| [nodestral/relay](https://github.com/nodestral/relay) | WebSocket relay — metrics streaming, terminal proxy |
| [nodestral/admin](https://github.com/nodestral/admin) | Admin dashboard — user management, health, billing |
| [nodestral/agent-full](https://github.com/nodestral/agent-full) | Full agent with terminal (moat) |
| [nodestral/docs](https://github.com/nodestral/docs) | Additional private docs |
| [nodestral/node-mcp](https://github.com/nodestral/node-mcp) | MCP server for node management |

## Infrastructure

- **VPS:** Tencent Cloud, Ubuntu 24.04.4 LTS
- **Domain:** nodestral.web.id (planned: nodestral.io)
- **Services:** systemd (api, relay, web, admin)
- **Database:** Supabase (users, nodes, discovery) + TimescaleDB (metrics)
- **Cache:** Redis 7.0 (localhost-only, 64MB, pub/sub)
- **Email:** Resend (alerts, notifications)
- **SSL:** Let's Encrypt via certbot

### Subdomains

| Subdomain | Service | Port |
|-----------|---------|------|
| nodestral.web.id | Dashboard | 3000 |
| api.nodestral.web.id | API | 8080 |
| nx.nodestral.web.id | WebSocket Relay | 8090 |
| management.nodestral.web.id | Admin Dashboard | 3001 |

## Local Workspace

All repos are cloned at `/home/openclaw/.openclaw/workspace/projects/nodestral/`:

```
projects/nodestral/
├── agent/          # Go agent (public, no terminal)
├── agent-full/     # Go agent with terminal (private, moat)
├── api/            # SaaS API (private)
├── web/            # SaaS dashboard (private)
├── relay/          # WebSocket relay (private)
├── admin/          # Admin dashboard (private)
├── docs/           # Additional docs (private)
├── nodestral-docs/ # This repo (private)
├── node-mcp/       # MCP server (private)
└── backend/        # Community backend (public)
```

## License

MIT
