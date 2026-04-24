# Nodestral

Your entire server fleet, visible from one place.

Nodestral is an open-source VPS fleet management tool. Install a lightweight agent on your servers, self-host the backend + dashboard, and get real-time monitoring, system discovery, and multi-provider visibility — no cloud account required.

## Why Nodestral?

- **One dashboard for all providers** — Tencent Cloud, AWS, GCP, Azure, Hetzner, DigitalOcean, or bare metal
- **Lightweight agent** — single Go binary, no runtime dependencies, no Docker required
- **Self-hosted** — backend + dashboard run on your own server, your data stays yours
- **Built-in monitoring** — CPU, RAM, disk, network metrics out of the box
- **System discovery** — auto-detects services, containers, packages, ports, certificates, firewall rules, and pending updates
- **Cloud provider detection** — identifies the provider and region automatically

## Quick Start

### 1. Start the Backend

```bash
git clone https://github.com/nodestral/backend.git
cd backend
make build
./nodestral-backend
```

The backend starts on `:8080` with an embedded SQLite database. Zero config.

### 2. Start the Dashboard

```bash
git clone https://github.com/nodestral/dashboard.git
cd dashboard
npm install
NEXT_PUBLIC_API_URL=http://localhost:8080 npm run dev
```

Open `http://localhost:3000` and create an account.

### 3. Install the Agent

On any Linux server:

```bash
curl -sSL https://nx.nodestral.web.id/install.sh | sh
```

The agent auto-registers with the backend, starts collecting metrics, and sends heartbeats every 30 seconds. Your server appears in the dashboard immediately.

## Architecture

```
┌─────────────────────────────┐
│    Dashboard (Next.js)      │
└──────────────┬──────────────┘
               │ HTTPS
┌──────────────▼──────────────┐
│    Backend (Go + SQLite)    │
│  Auth · Nodes · Heartbeat   │
│  Discovery · Metrics        │
└──────┬──────────────────────┘
       │ SQLite
       ▲
       │ HTTPS (30s heartbeat)
┌──────┴──────────────────────┐
│    Agent (Go, <20MB)        │
│  System info · Discovery    │
│  Cloud provider detection   │
└─────────────────────────────┘
```

## What the Agent Discovers

On registration and every 5 minutes, the agent scans and reports:

- **System services** — running/stopped status, versions
- **Docker containers** — images, status, resource usage
- **Installed packages** — nginx, postgresql, nodejs, go, python, etc.
- **Listening ports** — open ports with owning processes
- **SSL certificates** — domains, issuers, expiry dates
- **Firewall rules** — UFW/iptables active rules
- **OS updates** — pending and critical update counts
- **SSH access** — users with login capability
- **Cloud provider** — auto-detects Tencent, AWS, GCP, Azure, Hetzner, DigitalOcean
- **Instance type** — fetches from cloud metadata for cost estimation

## Repositories

| Repo | Description |
|------|-------------|
| [nodestral/nodestral](https://github.com/nodestral/nodestral) | Project overview and documentation |
| [nodestral/agent](https://github.com/nodestral/agent) | Go agent — lightweight, cross-platform |
| [nodestral/backend](https://github.com/nodestral/backend) | Go backend — SQLite, self-hostable, zero config |
| [nodestral/dashboard](https://github.com/nodestral/dashboard) | Next.js dashboard — works with backend out of the box |

## Features

### Agent
- Auto-registration with backend
- 30-second heartbeat
- System info collection (OS, kernel, CPU, RAM, disk)
- Cloud provider detection (Tencent, AWS, GCP, Azure, Hetzner, DigitalOcean)
- Instance type detection from cloud metadata
- System discovery (services, packages, containers, ports, certs, firewall, updates)
- Multi-platform binaries (Linux/macOS, amd64/arm64)

### Backend
- JWT authentication (register, login, refresh tokens)
- Node registration and heartbeat tracking
- Metrics storage with time-series queries
- System discovery storage and retrieval
- Offline detection (configurable timeout)
- SQLite — zero external dependencies

### Dashboard
- Node list with real-time status (online/offline)
- Per-node detail page with metrics charts (CPU, RAM, disk, network)
- Node grouping
- Cost tracking with manual per-node costs
- Notifications (offline, firewall, updates, cert expiry)
- Dark/light theme
- Responsive design

## Tech Stack

- **Agent:** Go — single static binary, cross-platform
- **Backend:** Go (Gin) + SQLite — fast, low memory, zero config
- **Dashboard:** Next.js + CSS variables — dark/light, responsive

## Install from Source

```bash
# Agent
git clone https://github.com/nodestral/agent.git
cd agent && go build -o nodestral-agent ./cmd/agent

# Backend
git clone https://github.com/nodestral/backend.git
cd backend && make build

# Dashboard
git clone https://github.com/nodestral/dashboard.git
cd dashboard && npm install
```

## License

MIT
