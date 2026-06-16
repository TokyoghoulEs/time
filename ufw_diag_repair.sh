#!/bin/bash
set -e
echo "=== UFW Diagnostic & Repair ==="

echo ""
echo "--- 1. Estado UFW ---"
ufw status verbose 2>&1 | head -10

echo ""
echo "--- 2. Error exacto iptables-restore ---"
iptables-restore < /etc/ufw/before.rules 2>&1 || true

echo ""
echo "--- 3. Cadenas iptables actuales ---"
iptables -L -n 2>&1 | grep "^Chain"

echo ""
echo "--- 4. Puerto 123 en user.rules ---"
grep "123" /etc/ufw/user.rules 2>/dev/null || echo "(no encontrado)"

echo ""
echo "=== REPARACION ==="

echo "→ Eliminando puerto 123..."
ufw delete allow 123/tcp 2>/dev/null || true
ufw delete allow 123/udp 2>/dev/null || true
ufw delete allow 123     2>/dev/null || true
sed -i '/\b123\b/d' /etc/ufw/user.rules  2>/dev/null || true
sed -i '/\b123\b/d' /etc/ufw/user6.rules 2>/dev/null || true
echo "✔ Puerto 123 eliminado"

echo "→ Deshabilitando ufw..."
ufw disable 2>&1 || true

echo "→ Flush iptables (momentáneo)..."
iptables  -F; iptables  -X; iptables  -Z
ip6tables -F; ip6tables -X; ip6tables -Z
iptables  -P INPUT ACCEPT; iptables  -P FORWARD ACCEPT; iptables  -P OUTPUT ACCEPT
ip6tables -P INPUT ACCEPT; ip6tables -P FORWARD ACCEPT; ip6tables -P OUTPUT ACCEPT
echo "✔ Tablas vaciadas"

echo "→ Reiniciando Docker..."
systemctl restart docker 2>/dev/null && sleep 4 && echo "✔ Docker OK" || echo "(Docker no activo)"

echo "→ Habilitando ufw..."
echo "y" | ufw enable 2>&1

echo "→ ufw reload..."
ufw reload 2>&1

echo ""
echo "=== VERIFICACION FINAL ==="
ufw status verbose 2>&1
grep "123" /etc/ufw/user.rules 2>/dev/null && echo "⚠ Puerto 123 aún presente" || echo "✔ Puerto 123 eliminado"
