#!/bin/bash
# VPS Setup Script for Nodestral
# Run as root on a fresh Ubuntu 24.04

set -e

echo "=== Nodestral VPS Setup ==="

# 1. Create user
echo "[1/8] Creating nodestral user..."
id nodestral &>/dev/null || useradd -r -s /usr/sbin/nologin nodestral

# 2. Create directories
echo "[2/8] Creating directories..."
mkdir -p /opt/nodestral/{api,web,relay,agent,bin}
chown -R nodestral:nodestral /opt/nodestral

# 3. Install Nginx
echo "[3/8] Installing Nginx..."
apt-get update -qq
apt-get install -y -qq nginx > /dev/null

# 4. Install Certbot for SSL (Cloudflare DNS challenge)
echo "[4/8] Installing Certbot..."
apt-get install -y -qq certbot python3-certbot-dns-cloudflare > /dev/null

# 5. Copy Nginx configs
echo "[5/8] Configuring Nginx..."
cp /tmp/nodestral-deploy/nginx-nodestral.web.id /etc/nginx/sites-available/nodestral.web.id
cp /tmp/nodestral-deploy/nginx-api.nodestral.web.id /etc/nginx/sites-available/api.nodestral.web.id
cp /tmp/nodestral-deploy/nginx-nx.nodestral.web.id /etc/nginx/sites-available/nx.nodestral.web.id
ln -sf /etc/nginx/sites-available/nodestral.web.id /etc/nginx/sites-enabled/
ln -sf /etc/nginx/sites-available/api.nodestral.web.id /etc/nginx/sites-enabled/
ln -sf /etc/nginx/sites-available/nx.nodestral.web.id /etc/nginx/sites-enabled/
rm -f /etc/nginx/sites-enabled/default
nginx -t
systemctl enable nginx
systemctl restart nginx

# 6. Copy systemd services
echo "[6/8] Setting up systemd services..."
cp /tmp/nodestral-deploy/nodestral-api.service /etc/systemd/system/
cp /tmp/nodestral-deploy/nodestral-web.service /etc/systemd/system/
cp /tmp/nodestral-deploy/nodestral-relay.service /etc/systemd/system/
systemctl daemon-reload
systemctl enable nodestral-api nodestral-web nodestral-relay

# 7. Copy agent binaries
echo "[7/8] Installing agent binaries..."
cp /tmp/nodestral-deploy/bin/* /opt/nodestral/bin/
chmod +x /opt/nodestral/bin/*
cp /tmp/nodestral-deploy/install.sh /opt/nodestral/bin/

# 8. Open firewall
echo "[8/8] Configuring firewall..."
ufw allow 22/tcp
ufw allow 80/tcp
ufw allow 443/tcp
ufw --force enable

echo ""
echo "=== Setup Complete ==="
echo ""
echo "Next steps:"
echo "  1. Create /opt/nodestral/api/.env with:"
echo "     NODESTRAL_DB_URL=<your-supabase-url>"
echo "     NODESTRAL_JWT_SECRET=<random-64-char-string>"
echo "     PORT=8080"
echo "     ALLOWED_ORIGINS=https://nodestral.web.id"
echo ""
echo "  2. Create /etc/nodestral/agent.yaml (see agent repo README)"
echo ""
echo "  3. For SSL with Cloudflare DNS challenge, create /root/.secrets/cloudflare.ini:"
echo "     dns_cloudflare_api_token = <your-cloudflare-api-token>"
echo "     chmod 600 /root/.secrets/cloudflare.ini"
echo "     certbot certonly --dns-cloudflare --dns-cloudflare-credentials /root/.secrets/cloudflare.ini -d nodestral.web.id -d api.nodestral.web.id -d nx.nodestral.web.id"
echo ""
echo "  4. Deploy binaries:"
echo "     API:     cp nodestral-api /opt/nodestral/api/ && systemctl restart nodestral-api"
echo "     Web:     (cp standalone build) /opt/nodestral/web/ && systemctl restart nodestral-web"
echo "     Relay:   cp nodestral-relay /opt/nodestral/relay/ && systemctl restart nodestral-relay"
echo "     Agent:   cp nodestral-agent /opt/nodestral/agent/ && restart agent process"
echo ""
