#!/bin/bash
set -e

SHINOBI_ROOT="/shinobi"
SHINOBI_DATA="${SHINOBI_ROOT}/shinobi_data"
MYSQL_INIT="${SHINOBI_ROOT}/mysql-init"

echo "[i] cleaning up old data..."
rm -rf "$SHINOBI_DATA"
rm -rf "$MYSQL_INIT"

echo "[i] creating shinobi directories..."
mkdir -p "$SHINOBI_DATA"
mkdir -p /dev/shm/ShinobiRAM

echo "[i] cloning Shinobi repository temporarily to grab mysql-init..."
TMP_REPO=$(mktemp -d)
git clone https://gitlab.com/Shinobi-Systems/Shinobi.git "$TMP_REPO"

echo "[i] copying mysql-init directory..."
cp -r "$TMP_REPO/sql" "$MYSQL_INIT"

echo "[i] cleaning up temporary repo..."
rm -rf "$TMP_REPO"

echo "[i] copying docker-compose to shinobi root..."
cp /app/docker-compose.yml "$SHINOBI_ROOT/docker-compose.yml"

cd "$SHINOBI_ROOT"

echo "[i] pulling images"
docker-compose pull
echo "[i] starting shinobi docker..."
docker-compose up
