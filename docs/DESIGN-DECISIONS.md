# Design Decisions

Key technical and product decisions, with rationale.

## Auth & Security

### JWT with separate admin secret
- **Decision:** Admin endpoints use `ADMIN_JWT_SECRET`, user endpoints use `NODESTRAL_JWT_SECRET`
- **Why:** Admin and user auth are completely isolated. Admin token can't access user endpoints and vice versa.
- **Date:** 2026-04-24

### `tryCmd` instead of sudoers file
- **Decision:** Agent discovery commands try without sudo first, retry once with sudo, graceful fallback on failure
- **Why:** User explicitly rejected creating a sudoers file on production VPS. Agent should work without root privileges where possible.
- **File:** `agent/pkg/discovery/discovery.go`

### Redis localhost-only
- **Decision:** Redis binds to 127.0.0.1 only, 64MB max memory
- **Why:** Security — Redis has no auth. Only used for pub/sub between API and relay on the same machine.

### Admin users are view-only
- **Decision:** Admin dashboard shows user status but no deactivate/reactivate buttons
- **Why:** Prevent workers from making prank/nasty changes. User lifecycle managed by system.
- **Date:** 2026-04-24

## Architecture

### Dual-database (Supabase + TimescaleDB)
- **Decision:** User data in Supabase (hosted PostgreSQL), metrics in local TimescaleDB
- **Why:** TimescaleDB hypertable for efficient time-series queries with 30-day retention. Supabase handles auth, user data with built-in pooling.
- **Trade-off:** Two databases to manage, but each is optimized for its workload.

### WebSocket metrics through relay, not API
- **Decision:** Single WebSocket entry point at `nx.nodestral.web.id` (port 8090)
- **Why:** One domain for all WS connections, simpler SSL, easier connection management. API handles REST only.

### Same binary for admin + user API
- **Decision:** Admin endpoints live in the same Go binary as user API, separated by middleware
- **Why:** Less ops overhead, shared DB pools, shared Redis. Admin has ~2 users — not worth a separate service.
- **Revisit:** If admin needs different deployment cadence or background jobs affecting API latency.

## Frontend

### Cost tracking: manual input, estimation as fallback
- **Decision:** Users set actual monthly cost per node. Provider pricing estimates shown as reference.
- **Why:** Cloud list prices don't match reseller pricing (e.g., Tencent S5.MEDIUM4 list $80/mo vs actual Rp90K). Actual cost is what matters.
- **Date:** 2026-04-24

### Token expiry auto-redirect with return URL
- **Decision:** On 401, clear localStorage and redirect to `/auth/login?redirect=<current_path>`
- **Why:** Better UX than just showing an error. User returns to where they were after re-login.

### Upgrade CTA matches landing page style
- **Decision:** Free users see 3-column pricing cards (same as homepage) on gated features
- **Why:** Consistent branding. Shallow CTA felt incomplete.

## Infrastructure

### Auto-deploy disabled in CI
- **Decision:** All CI workflows have `if: false` on deploy steps
- **Why:** No staging VPS yet. Direct deploy to production is risky.
- **Revisit:** After staging VPS is set up.

### Terminal as moat (public agent stripped)
- **Decision:** Public `nodestral/agent` repo has no `pkg/terminal/` code. Private `nodestral/agent-full` has it.
- **Why:** Terminal is the highest-value differentiator. Forkers get everything except terminal.
- **VPS runs:** agent-full binary (with terminal)

### Node ownership validated on WebSocket connect
- **Decision:** WS connection checks if the connecting user owns the requested node
- **Why:** Prevent users from subscribing to other users' node metrics via WebSocket.

### Connection limits
- **Decision:** 5 connections per node, 20 per user on metrics WebSocket
- **Why:** Prevent resource exhaustion from too many open WS connections.
