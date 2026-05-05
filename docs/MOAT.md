# Moat Strategy

What differentiates the SaaS from the open-source community edition, and why competitors can't simply fork it.

## Public (Community Edition)

Fully functional self-hosted stack:
- Agent with system discovery and metrics collection
- Backend (Go + SQLite, zero config)
- Dashboard with node list, metrics charts, cost tracking
- Install script, multi-platform binaries

Anyone can fork, self-host, and run their own fleet management.

## Private (SaaS Moat)

Features that require infrastructure, coordination, or operational complexity:

### 1. Web Terminal
- **What:** Browser-based SSH into any server
- **Why moat:** Requires a persistent WebSocket relay (`nx.nodestral.web.id`), PTY management, SSH key handling, and a proxy layer between browser and agent
- **Public agent has no terminal code** — `pkg/terminal/` is stripped from the public repo
- **Private repo:** `nodestral/agent-full` contains the full agent with terminal
- **Competitor effort:** Must build their own WebSocket relay + SSH proxy + PTY handling

### 2. Real-Time Metrics (WebSocket)
- **What:** Live CPU/RAM/disk/network charts updating in real-time
- **Why moat:** Requires Redis pub/sub between API and relay, WebSocket connection management per client, per-node connection limits (5 per node, 20 per user)
- **Community edition:** Polls via REST API (works but not real-time)
- **Competitor effort:** Must implement Redis pub/sub + WebSocket hub + connection pooling

### 3. Backend Export (OTel Integration)
- **What:** Ship metrics to Grafana Cloud, Prometheus, Loki, Datadog from the dashboard
- **Why moat:** Requires an OTel config generator, remote agent command execution, backend management, and apply workflow
- **Pro feature** — gated behind subscription
- **Competitor effort:** Must build config generation for multiple backends + remote execution pipeline

### 4. Dual-Database Architecture
- **What:** Supabase for user-facing data, TimescaleDB for metrics
- **Why moat:** TimescaleDB hypertable with 30-day retention, optimized time-series queries, separate connection pooling
- **Community edition:** Uses SQLite (works for small fleets)
- **Competitor effort:** Must design and operate a dual-database system

### 5. Email Alerts
- **What:** Offline detection → email notification → recovery notification
- **Why moat:** Background scanner (30s check, 90s timeout), Redis broadcast for real-time, Resend integration with HTML templates
- **Competitor effort:** Must build background scanner + notification queue + email templates

### 6. Admin Dashboard
- **What:** User management, system health, billing, audit logs
- **Why moat:** Separate JWT auth, health checks across all services, revenue tracking
- **Not useful to competitors** — it's internal tooling

### 7. Offline Detection + Auto-Recovery
- **What:** Background goroutine detects offline nodes, creates notifications, sends emails, auto-creates recovery notifications
- **Why moat:** Requires persistent background process, Redis for cross-instance coordination
- **Competitor effort:** Must build background job system + notification pipeline

## Why This Works

The moat isn't in any single feature — it's in the **operational complexity** of running all these systems together:

1. Fork the agent → works, but no terminal, no real-time metrics
2. Fork the backend → works with SQLite, but doesn't scale
3. Build your own relay → significant engineering effort
4. Wire it all together → months of work for a competitor

Meanwhile, we keep evolving. The open-source version serves as marketing and community building, while the SaaS provides the premium experience that's hard to replicate.
