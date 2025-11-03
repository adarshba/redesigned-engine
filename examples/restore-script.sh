#!/bin/bash

# n8n Restore Script
# This script restores n8n data from a backup file

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}n8n Restore Script${NC}"
echo "================================"

# Check if backup file is provided
if [ $# -eq 0 ]; then
    echo -e "${RED}Error: No backup file specified${NC}"
    echo "Usage: $0 <backup-file.tar.gz>"
    echo ""
    echo "Available backups:"
    ls -1t ./backups/n8n_backup_*.tar.gz 2>/dev/null || echo "  No backups found"
    exit 1
fi

BACKUP_FILE="$1"

# Check if backup file exists
if [ ! -f "${BACKUP_FILE}" ]; then
    echo -e "${RED}Error: Backup file not found: ${BACKUP_FILE}${NC}"
    exit 1
fi

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo -e "${RED}Error: Docker is not running${NC}"
    exit 1
fi

echo -e "${YELLOW}WARNING: This will overwrite existing n8n data!${NC}"
read -p "Are you sure you want to continue? (yes/no): " -r
echo

if [[ ! $REPLY =~ ^[Yy][Ee][Ss]$ ]]; then
    echo "Restore cancelled"
    exit 0
fi

# Stop n8n if running
if docker ps --format '{{.Names}}' | grep -q '^n8n$'; then
    echo "Stopping n8n container..."
    docker-compose down
fi

# Get or create volume
VOLUME_NAME=$(docker volume ls --format '{{.Name}}' | grep 'n8n_data' | head -n 1)

if [ -z "$VOLUME_NAME" ]; then
    echo "Creating new volume..."
    docker volume create n8n_data
    VOLUME_NAME="n8n_data"
fi

echo "Restoring from: ${BACKUP_FILE}"

# Restore data to volume
docker run --rm \
    -v "${VOLUME_NAME}:/data" \
    -v "$(pwd):/backup" \
    alpine \
    sh -c "rm -rf /data/* /data/..?* /data/.[!.]* 2>/dev/null; tar xzf /backup/${BACKUP_FILE} -C /data"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}Restore completed successfully!${NC}"
    echo ""
    echo "Starting n8n..."
    docker-compose up -d
    echo -e "${GREEN}n8n has been restored and started!${NC}"
else
    echo -e "${RED}Restore failed!${NC}"
    exit 1
fi
