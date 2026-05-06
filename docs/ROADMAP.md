# Nodestral — Development Roadmap

> Last updated: 2026-05-06

## Phase 1: MVP ✅ Complete

- [x] Go API server (Gin + Supabase PostgreSQL)
- [x] JWT auth (register/login/refresh/change password)
- [x] Agent registration + install token (pre-authenticated)
- [x] Agent heartbeat (30s interval)
- [x] System info collection (CPU, RAM, disk, network, OS)
- [x] Cloud provider detection (Tencent, AWS, GCP, Azure, Hetzner, DigitalOcean)
- [x] Next.js dashboard with node list, search/filter, status tabs
- [x] Per-node detail page (specs, metrics charts, discovery, inline rename)
- [x] Real-time metrics charts (CPU/RAM/Disk area, Network line, recharts)
- [x] Time range selector (5m/15m/1h/6h/24h/7d)
- [x] Dark/light theme
- [x] Install script with CDN + GitHub Releases fallback
- [x] Agent v0.1.0 release (linux/darwin × amd64/arm64, ~17MB)
- [x] Node tagging + rename
- [x] Bulk operations API + UI
- [x] Notifications page (server persistence + client-side scanner)
- [x] Web terminal (xterm.js, persistent shell via nx relay)
- [x] Install token management UI
- [x] Settings page (account info, change password)
- [x] Sidebar notification unread badge
- [x] Backends page with Pro gate
- [x] Free/Pro/Team plan model (server-side enforcement)

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
- [x] Rate limiter middleware
- [x] AES-GCM encryption for auth_config (backend credentials)
- [x] Backend test connection + set default endpoints

## Phase 4: Admin & Management ✅ Complete

- [x] Admin dashboard (management.nodestral.web.id)
- [x] Admin API endpoints (separate JWT, separate secret)
- [x] User management (view-only, search, pagination)
- [x] Node overview (total, online/offline, per-provider)
- [x] System health (API, Supabase, TimescaleDB, Redis, Relay — 30s refresh)
- [x] Billing (MRR in Rp + USD, plan distribution, subscription table)
- [x] Audit logs (filterable, admin action tracking)
- [x] Audit logs DB table with auto-insert on admin actions

## Phase 5: Growth 🔄 In Progress

### Ready to Build
- [ ] **Announcements feature** — admin can push notifications to users (maintenance, new features)
- [ ] **Agent auto-update** — version check on heartbeat, download prompt
- [ ] **Update nodestral-docs** — sync docs with Phase 2+3+4 completion ← *you are here*

### Blocked / External
- [ ] OAuth (Google + GitHub) — needs provider credentials
- [ ] Stripe billing integration — needs Stripe account
- [ ] Staging VPS — user will handle
- [ ] Domain purchase (nodestral.io) — user will handle
- [ ] E2E agent install on external VPS — user will handle

## Phase 6: Scale (Planned)

- [ ] Multi-region deployment
- [ ] Agent binary CDN with geo-routing
- [ ] Rate limiting per user (tier-based)
- [ ] API versioning (v2)
- [ ] Mobile app (React Native)
- [ ] SSO (SAML/OIDC) for Team plan
- [ ] RBAC within teams
- [ ] Managed LGTM stack per tenant (Prometheus + Loki + Tempo)
- [ ] OpenAPI/Swagger documentation
- [ ] Public API for integrations
- [ ] Windows agent support
- [ ] Kubernetes deployment option

## Milestones

| Milestone | Status | What |
|-----------|--------|------|
| **M1: Prototype** | ✅ Done | Agent registers, dashboard shows nodes with live metrics |
| **M2: MVP** | ✅ Done | Full flow: install → dashboard → terminal → discovery → ops → notifications |
| **M3: Public Beta** | ✅ Done | Offline detection, email alerts, grouping, real-time WS, backend export, admin |
| **M4: Growth** | 🔄 Next | Announcements, auto-update, OAuth, Stripe billing |
| **M5: Scale** | 🔜 Future | Multi-region, mobile, SSO, managed LGTM, API v2 |

## Repository Structure

```
nodestral/                    # GitHub org
├── nodestral/nodestral       # Hub repo (public, MIT) — README, deploy configs
├── nodestral/agent           # Agent binary (public, MIT) — no terminal code
├── nodestral/backend         # Community backend (public, MIT) — Go + SQLite
├── nodestral/dashboard       # Community dashboard (public, MIT) — Next.js
├── nodestral/api             # SaaS API (private) — Supabase + TimescaleDB
├── nodestral/web             # SaaS dashboard (private) — full feature set
├── nodestral/relay           # nx WebSocket relay (private)
├── nodestral/admin           # Admin dashboard (private)
├── nodestral/agent-full      # Full agent with terminal (private, moat)
├── nodestral/nodestral-docs  # Documentation (private)
├── nodestral/node-mcp        # MCP server for node management (private)
└── nodestral/archflow        # Architecture diagram library (public)
```

## Infrastructure

- **VPS:** Tencent Cloud, Ubuntu 24.04 LTS
- **Domain:** nodestral.web.id (planned: nodestral.io)
- **Services:** systemd (api, relay, web, admin)
- **Database:** Supabase PostgreSQL (users, nodes) + TimescaleDB (metrics, 30-day retention)
- **Cache:** Redis 7.0 (localhost-only, 64MB, pub/sub)
- **Email:** Resend (offline/recovery alerts)
- **SSL:** Let's Encrypt via certbot

### Subdomains

| Subdomain | Service | Port |
|-----------|---------|------|
| nodestral.web.id | Dashboard | 3000 |
| api.nodestral.web.id | API | 8080 |
| nx.nodestral.web.id | WebSocket Relay | 8090 |
| management.nodestral.web.id | Admin Dashboard | 3001 |
