# Nodestral — Product Requirements Document

> Last updated: 2026-05-06

## 1. Vision

**Nodestral is a VPS fleet management control plane.** One agent, one dashboard, any monitoring backend. Install a lightweight agent on any server, see all your nodes in one place, manage them from your browser, and ship observability data to whatever backend you already use — Grafana, Datadog, Prometheus, or our built-in dashboard.

We don't compete with Grafana or Datadog. We coexist and simplify.

## 2. Problem Statement

Developers and small teams with multiple VPS instances across different cloud providers face:

- **Scattered visibility** — no single view of all servers across providers (Tencent, AWS, Hetzner, DigitalOcean, etc.)
- **No unified management** — each provider has its own console, SSH access, and billing
- **Monitoring fragmentation** — setting up Prometheus/Grafana/Loki on every server is tedious
- **Migration friction** — switching from Datadog to Grafana Cloud requires SSH into every node
- **No lightweight option** — existing tools are either enterprise-priced (Datadog $70/host) or require heavy self-hosting (Prometheus stack)

## 3. Target Users

| Segment | Servers | Pain Point | Willingness to Pay |
|---------|---------|------------|-------------------|
| Hobbyist | 1-5 | Want simple dashboard, no Grafana setup | Free (2 nodes) |
| Indie Dev | 5-20 | Need web terminal, bulk ops, cost tracking | Rp10K/node/mo |
| Small Team | 20-100 | Need RBAC, audit logs, managed backend | Custom |
| Enterprise | 100+ | Need SSO, compliance, dedicated support | Custom |

## 4. Product Layers

### Layer 1: Agent & Registration ✅
- Single Go binary (~17MB), zero dependencies, static build
- One-command install: `curl | sh` with CDN + GitHub Releases fallback
- Auto-detect: OS, CPU, RAM, disk, IP, hostname, cloud provider, instance type
- Auto-register to Nodestral dashboard (or via install token)
- Heartbeat every 30s via HTTPS
- Prometheus remote write exporter (Pro only)

### Layer 2: Dashboard & Inventory ✅
- Server list with live status (green/yellow/red), search/filter, status tabs
- Per-server detail: specs, metrics charts, discovery, inline rename
- **Node auto-discovery**: installed services, packages, Docker containers, listening ports, firewall rules, SSL cert expiry, pending OS updates, SSH users, existing monitoring tools
- Built-in real-time metrics charts (CPU, RAM, disk, network) via WebSocket
- Server grouping and tagging (CRUD)
- Cost tracking (manual input + provider pricing estimates)
- Notifications (offline/recovery alerts via email)

### Layer 3: Web Terminal ✅
- Browser-based SSH terminal (xterm.js)
- Persistent shell via WebSocket relay (nx)
- Connection limits (5/node, 20/user)
- Node ownership validation on WS connect
- **Note:** Terminal code is stripped from public agent repo (moat strategy)

### Layer 4: Backend Management ✅
- Configure Prometheus remote write destination per-node or globally
- One-click switch: Grafana Cloud → Prometheus → Loki → Datadog → OTLP
- Backend test connection + set default
- Export guide tab with setup instructions
- Custom Grafana dashboard JSON
- **Pro feature** — gated behind subscription

### Layer 5: Operations ✅
- Bulk operations: run command across all/some nodes
- Operations history with per-node results
- Install token management (pre-authenticated registration)

### Layer 6: Admin & Management ✅
- Admin dashboard (separate subdomain, separate JWT)
- User management (view-only, search, pagination)
- Node overview (total, online/offline, per-provider)
- System health (API, Supabase, TimescaleDB, Redis, Relay — 30s refresh)
- Billing (MRR in Rp + USD, plan distribution, subscription table)
- Audit logs (filterable, admin action tracking)

### Layer 7: Growth 🔄 (In Progress)
- [ ] Announcements feature (push notifications to users)
- [ ] Agent auto-update mechanism
- [ ] OAuth (Google + GitHub)
- [ ] Stripe billing integration

### Layer 8: Scale (Planned)
- [ ] Multi-region deployment
- [ ] Mobile app (React Native)
- [ ] SSO (SAML/OIDC) for Team plan
- [ ] RBAC within teams
- [ ] Managed LGTM stack per tenant
- [ ] OpenAPI/Swagger documentation
- [ ] Public API for integrations

## 5. Non-Goals

- ❌ Building our own metrics engine (use OTel + Prometheus)
- ❌ Building our own log storage (use OTel + Loki)
- ❌ Building our own tracing (use OTel + Tempo)
- ❌ Windows support (Linux/macOS only)
- ❌ Kubernetes-native features (future consideration)

## 6. Success Metrics

| Metric | Target (6 months) | Status |
|--------|-------------------|--------|
| Registered nodes | 1,000+ | 🔄 |
| Active users | 200+ | 🔄 |
| Free → Pro conversion | 5%+ | 🔄 |
| Agent install success rate | 99%+ | 🔄 |
| Dashboard load time | <2s | ✅ |
| Web terminal latency | <200ms added | ✅ |

## 7. Revenue Model

| Tier | Price | Included |
|------|-------|----------|
| Free | $0 | Up to 2 nodes, built-in charts, basic inventory, terminal |
| Pro | Rp10K/node/mo (~$0.60) | Unlimited nodes, backend export, node_exporter install |
| Team | Custom | Everything in Pro + managed LGTM backend, SSO, RBAC, audit logs |

**Note:** Pricing in IDR (Indonesian Rupiah) for local market. USD equivalent shown for reference.

## 8. Open Source Strategy

**Public (MIT):**
- `nodestral/agent` — Agent binary (no terminal code)
- `nodestral/backend` — Community backend (Go + SQLite)
- `nodestral/dashboard` — Community dashboard (Next.js)
- `nodestral/archflow` — Architecture diagram library

**Private (SaaS moat):**
- `nodestral/api` — SaaS API (Supabase + TimescaleDB)
- `nodestral/web` — SaaS dashboard (full features)
- `nodestral/relay` — WebSocket relay
- `nodestral/admin` — Admin dashboard
- `nodestral/agent-full` — Full agent with terminal

## 9. Branding

- **Name:** Nodestral
- **Tagline:** "Your server fleet. One dashboard. Any monitoring backend."
- **Domain:** nodestral.web.id (planned: nodestral.io)
- **Colors:** Dark theme primary, accent blue/green
