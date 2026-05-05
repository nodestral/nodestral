# Nodestral — Development Roadmap

> Last updated: 2026-04-24

## Phase 1: MVP ✅ Complete

- [x] Go API server (Gin + Supabase PostgreSQL)
- [x] JWT auth (register/login/refresh)
- [x] Agent registration + install token
- [x] Agent heartbeat (30s)
- [x] System info collection
- [x] Cloud provider detection (Tencent, AWS, GCP, Azure, Hetzner, DigitalOcean)
- [x] Next.js dashboard with node list
- [x] Per-node metrics charts (CPU, RAM, disk, network)
- [x] Dark/light theme
- [x] Install script with CDN + GitHub Releases fallback
- [x] Agent v0.1.0 release (4 binaries)

## Phase 2: Discovery & Monitoring ✅ Complete

- [x] System discovery (services, containers, packages, ports, certs, firewall, updates, SSH)
- [x] `tryCmd` helper (no sudo, retry with sudo, graceful fallback)
- [x] Offline detection (background scanner, 30s check, 90s timeout)
- [x] Email alerts via Resend (offline + recovery)
- [x] Notifications page with categories
- [x] Redis pub/sub for real-time events
- [x] Node grouping (CRUD)
- [x] Live metrics WebSocket (Redis → relay → browser)
- [x] Connection limits (5/node, 20/user)
- [x] Node ownership validation on WS connect

## Phase 3: Platform Features ✅ Complete

- [x] Self-hosted TimescaleDB (2.26, hypertable, 30-day retention)
- [x] Dual-database architecture (Supabase + TimescaleDB)
- [x] Backend export (Prometheus, Grafana Cloud, Loki, Datadog) — Pro feature
- [x] OTel config generator
- [x] Custom Grafana dashboard JSON
- [x] Export guide tab with setup instructions
- [x] Terminal stripped from public agent repo (moat strategy)
- [x] Private `agent-full` repo with terminal
- [x] CI/CD for all repos (build + test, no auto-deploy)
- [x] Cost tracking — manual input per node, provider pricing estimates
- [x] Token expiry auto-redirect with return URL
- [x] Upgrade CTA with 3-column pricing cards

## Phase 4: Admin & Management ✅ Complete

- [x] Admin dashboard (management.nodestral.web.id)
- [x] Admin API endpoints (separate JWT, separate secret)
- [x] User management (view-only, search, pagination)
- [x] Node overview (total, online/offline, per-provider)
- [x] System health (API, Supabase, TimescaleDB, Redis, Relay — 30s refresh)
- [x] Billing (MRR in Rp + USD, plan distribution, subscription table)
- [x] Audit logs (filterable, admin action tracking)
- [x] Audit logs DB table with auto-insert on admin actions

## Phase 5: Growth (In Progress)

- [ ] OAuth (Google + GitHub) — blocked, needs provider credentials
- [ ] Stripe billing integration — for pro/managed tiers
- [ ] Agent auto-update mechanism
- [ ] Staging VPS — user will handle
- [ ] Domain purchase (nodestral.io) — user will handle
- [ ] E2E agent install on external VPS — user will handle
- [ ] Announcements feature (push notifications to users)
- [ ] Update nodestral-docs to reflect Phase 2+3+4 completion

## Phase 6: Scale (Planned)

- [ ] Multi-region deployment
- [ ] Agent binary CDN with geo-routing
- [ ] Rate limiting per user
- [ ] API versioning
- [ ] Mobile app (React Native)
- [ ] SSO (SAML/OIDC) for Team plan
- [ ] RBAC within teams
- [ ] Managed LGTM stack per tenant (Prometheus + Loki + Tempo)

# Nodestral — Development Roadmap

## Phase 1: MVP (Weeks 1-4)

### Week 1: Agent Core + API Skeleton
- [ ] Go module setup (`cmd/agent`, `pkg/`)
- [ ] System info collector (CPU, RAM, disk, OS, hostname, IPs)
- [ ] Cloud provider auto-detection (Tencent, AWS, GCP, Azure, Hetzner, DO)
- [ ] Agent registration flow (first-run → get node_id + token → save config)
- [ ] Heartbeat loop (POST to API every 30s)
- [ ] API server skeleton (Go, Gin/Fiber)
- [ ] PostgreSQL schema (users, nodes, node_metrics)
- [ ] Auth endpoints (register, login, JWT)
- [ ] Agent heartbeat + register endpoints
- [ ] Install script (`curl | sh`)

### Week 2: Frontend Dashboard
- [ ] Next.js project setup with Tailwind
- [ ] Auth flow (login, register, JWT storage)
- [ ] Node list page (cards with status dots)
- [ ] Node detail page (specs table)
- [ ] Real-time metrics charts (CPU, RAM, disk sparklines)
- [ ] WebSocket connection for live updates
- [ ] Landing page (hero, features, pricing)

### Week 3: Web Terminal + OTel Integration
- [ ] xterm.js integration
- [ ] SSH proxy through API (WebSocket → agent → PTY)
- [ ] Terminal session in node detail page
- [ ] OTel Collector download + install logic in agent
- [ ] OTel Collector config generator (API side)
- [ ] Agent lifecycle management (start/stop/restart collector)
- [ ] Backend config CRUD endpoints
- [ ] Backend config UI (add Grafana Cloud / Prometheus / self-hosted)

### Week 4: Polish + Deploy
- [ ] Agent error handling + retry logic
- [ ] Node offline detection (missed heartbeats → red status)
- [ ] Docker Compose for full stack deployment
- [ ] Nginx + SSL setup
- [ ] Agent binary hosting (MinIO)
- [ ] End-to-end testing (install agent → see in dashboard → terminal)
- [ ] Documentation (install guide, quickstart)
- [ ] Landing page copy + deploy to Vercel

## Phase 2: Growth (Weeks 5-8)

### Week 5-6: Operations & Security
- [ ] Bulk operations engine (run command on N nodes)
- [ ] Bulk ops UI (select nodes, enter command, see results)
- [ ] Security scanner (OS updates, SSH config, open ports, cert expiry)
- [ ] Security scan results in node detail
- [ ] Node grouping and tagging
- [ ] Search and filter nodes

### Week 7-8: Cost + Backend Switching
- [ ] Cloud billing API integration (Tencent, AWS, GCP)
- [ ] Cost dashboard (per-node, per-provider, total)
- [ ] One-click backend switch (apply new OTel config to all nodes)
- [ ] Collector health monitoring per node
- [ ] Email notifications (node offline, security alerts)

## Phase 3: Revenue (Weeks 9-12)

### Week 9-10: Managed Backend
- [ ] Deploy managed Prometheus + Loki + Tempo (per-tenant)
- [ ] OTel endpoint per tenant
- [ ] "Connect Grafana" button (exposes Prometheus/Loki data sources)
- [ ] LGTM compatibility endpoints
- [ ] Metrics/log retention management

### Week 11-12: Billing & Teams
- [ ] Stripe integration (subscription management)
- [ ] Plan enforcement (node limits, feature gates)
- [ ] Team management (invite, RBAC)
- [ ] SSO (Google, GitHub OAuth)
- [ ] Audit log viewer

## Phase 4: Scale (Ongoing)

- [ ] API horizontal scaling
- [ ] Rate limiting
- [ ] Agent auto-update mechanism
- [ ] Kubernetes deployment option
- [ ] Windows support
- [ ] Custom deploy templates
- [ ] API documentation (OpenAPI/Swagger)
- [ ] Public API for integrations

## Milestones

| Milestone | Target | What's Shippable |
|-----------|--------|-----------------|
| **M1: Working Prototype** | Week 2 | Agent registers, dashboard shows nodes with live metrics |
| **M2: MVP** | Week 4 | Full flow: install → dashboard → terminal → OTel config |
| **M3: Public Beta** | Week 8 | Ops, security, cost tracking, multi-backend |
| **M4: Launch** | Week 12 | Billing, managed backend, teams, SSO |

## Repository Structure

```
nodestral/
├── docs/
│   ├── PRD.md
│   ├── ARCHITECTURE.md
│   └── ROADMAP.md          ← this file
├── agent/                   # Go agent
│   ├── cmd/agent/main.go
│   ├── pkg/
│   │   ├── collector/       # System info collection
│   │   ├── provider/        # Cloud provider detection
│   │   ├── heartbeat/       # Heartbeat loop
│   │   ├── otel/            # OTel Collector management
│   │   ├── terminal/        # SSH bridge / PTY proxy
│   │   └── config/          # Agent config
│   ├── go.mod
│   └── scripts/
│       └── install.sh       # curl | sh install script
├── api/                     # Go API server
│   ├── cmd/server/main.go
│   ├── internal/
│   │   ├── auth/            # JWT auth
│   │   ├── handlers/        # HTTP handlers
│   │   ├── models/          # DB models
│   │   ├── otelconfig/      # OTel Collector config generator
│   │   ├── terminal/        # WebSocket terminal proxy
│   │   └── middleware/      # Auth, rate limit, CORS
│   ├── migrations/          # SQL migrations
│   └── go.mod
├── web/                     # Next.js frontend
│   ├── src/
│   │   ├── app/             # App router pages
│   │   ├── components/      # React components
│   │   ├── lib/             # API client, auth, utils
│   │   └── hooks/           # Custom hooks (useWebSocket, etc.)
│   ├── package.json
│   └── tailwind.config.ts
├── deploy/                  # Docker Compose, Nginx, etc.
│   ├── docker-compose.yml
│   ├── nginx/nginx.conf
│   └── scripts/
└── README.md
```
