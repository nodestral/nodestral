# Nodestral — Product Requirements Document

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
| Hobbyist | 1-5 | Want simple dashboard, no Grafana setup | Free |
| Indie Dev | 5-20 | Need web terminal, bulk ops, cost tracking | $5/node/mo |
| Small Team | 20-100 | Need RBAC, audit logs, managed backend | $15/node/mo |
| Enterprise | 100+ | Need SSO, compliance, dedicated support | Custom |

## 4. Product Layers

### Layer 1: Agent & Registration (MVP)
- Single Go binary (~5MB), zero dependencies
- One-command install: `curl -sSL nodestral.io/install | sh`
- Auto-detect: OS, CPU, RAM, disk, IP, hostname, cloud provider
- Auto-register to Nodestral dashboard
- Heartbeat every 30s via HTTPS
- Manage OTel Collector lifecycle (install, configure, update, restart)

### Layer 2: Dashboard & Inventory (MVP)
- Server list with live status (green/yellow/red)
- Per-server detail: specs, uptime, OS, provider, IP
- **Node auto-discovery**: installed services, packages, Docker containers, listening ports, firewall rules, SSL cert expiry, pending OS updates, SSH users, existing monitoring tools
- Built-in lightweight charts (CPU, RAM, disk) — works without Grafana
- Server grouping and tagging (prod, staging, by-provider)
- Quick actions: reboot, run command, check updates

### Layer 3: Web Terminal (MVP)
- Browser-based SSH terminal (xterm.js)
- SSH proxy through backend — no direct SSH exposure
- Audit log of all terminal sessions

### Layer 4: Backend Management (Post-MVP)
- Configure OTel Collector export destination per-node or globally
- One-click switch: Datadog → Grafana Cloud → Prometheus → any OTel backend
- Built-in support: Grafana Cloud, self-hosted Prometheus+Loki+Tempo, Datadog, Honeycomb
- Collector health monitoring per node

### Layer 5: Operations (Post-MVP)
- Bulk operations: run command across all/some nodes
- Deploy templates: docker-compose stacks, scripts
- Security posture: OS updates, SSH config audit, cert expiry, open ports
- Cost tracking: pull billing APIs from cloud providers, show per-node cost

### Layer 6: Managed Backend (Revenue)
- Nodestral hosts Prometheus + Loki + Tempo for users who don't want self-hosted
- OTel Collector ships to our backend
- Users can still connect their own Grafana to our backend (LGTM compatibility)

## 5. Non-Goals (MVP)

- ❌ Building our own metrics engine (use OTel + Prometheus)
- ❌ Building our own log storage (use OTel + Loki)
- ❌ Building our own tracing (use OTel + Tempo)
- ❌ Kubernetes-native features (future consideration)
- ❌ Windows support (Linux-only for MVP)
- ❌ Mobile app (responsive web first)

## 6. Success Metrics

| Metric | Target (6 months) |
|--------|-------------------|
| Registered nodes | 1,000+ |
| Active users | 200+ |
| Free → Pro conversion | 5%+ |
| Agent install success rate | 99%+ |
| Dashboard load time | <2s |
| Web terminal latency | <200ms added |

## 7. Revenue Model

| Tier | Price | Included |
|------|-------|----------|
| Free | $0 | Up to 5 nodes, built-in charts, basic inventory |
| Pro | $5/node/mo | Unlimited nodes, web terminal, bulk ops, cost tracking, backend management |
| Team | $15/node/mo | Everything in Pro + managed LGTM backend, SSO, RBAC, audit logs |

## 8. Branding

- **Name**: Nodestral
- **Tagline**: "Your server fleet. One dashboard. Any monitoring backend."
- **Domain**: nodestral.io (to acquire), nodestral.io (fallback)
- **Logo**: TBD
- **Colors**: Dark theme primary, accent blue/green
