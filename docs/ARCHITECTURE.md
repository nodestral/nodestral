# Architecture — Community Edition

## Components

```
┌─────────────────────────────┐
│    Dashboard (Next.js)      │
│    :3000                    │
└──────────────┬──────────────┘
               │ HTTPS
┌──────────────▼──────────────┐
│    Backend (Go)             │
│    :8080                    │
│    ┌───────────────────┐    │
│    │     SQLite        │    │
│    │  users, nodes,    │    │
│    │  metrics, disc.   │    │
│    └───────────────────┘    │
└──────┬──────────────────────┘
       │
       ▲ HTTPS (30s heartbeat)
       │
┌──────┴──────────────────────┐
│    Agent (Go)               │
│    - system info            │
│    - discovery (5min)       │
│    - metrics (30s)          │
└─────────────────────────────┘
```

## Backend

Single Go binary with Gin HTTP framework. Uses SQLite for all storage (users, nodes, metrics, discovery data). No external database required.

### Endpoints

| Method | Path | Description |
|--------|------|-------------|
| POST | /auth/register | Create account |
| POST | /auth/login | Get JWT tokens |
| POST | /auth/refresh | Refresh access token |
| POST | /agent/register | Register new node |
| POST | /agent/heartbeat | Node heartbeat (30s) |
| POST | /agent/discovery | System discovery data |
| GET | /nodes | List user's nodes |
| GET | /nodes/:id | Node detail + metrics |
| GET | /nodes/:id/metrics | Time-series metrics |

## Agent

Go binary with no external dependencies. Detects OS, hardware, cloud provider, and runs periodic discovery scans.

### Discovery Items

- Running services and versions
- Docker containers
- Installed packages
- Listening ports
- SSL certificates (with expiry)
- Firewall rules (UFW/iptables)
- Pending OS updates
- SSH users with login access
- Cloud provider and region
- Instance type (from metadata API)

## Dashboard

Next.js app with dark/light theme. Connects to backend via `NEXT_PUBLIC_API_URL`.

### Pages

- Login / Register
- Node list (online/offline status)
- Node detail (metrics charts, discovery data)
- Node grouping
- Notifications
- Cost tracking
