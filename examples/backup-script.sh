#!/bin/bash

# n8n Backup Script
# This script creates a backup of n8n data and workflows

set -e

# Configuration
BACKUP_DIR="./backups"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="${BACKUP_DIR}/n8n_backup_${TIMESTAMP}.tar.gz"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}n8n Backup Script${NC}"
echo "================================"

# Create backup directory if it doesn't exist
mkdir -p "${BACKUP_DIR}"

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo -e "${RED}Error: Docker is not running${NC}"
    exit 1
fi

# Check if n8n container exists
if ! docker ps -a --format '{{.Names}}' | grep -q '^n8n$'; then
    echo -e "${RED}Error: n8n container not found${NC}"
    exit 1
fi

echo "Creating backup..."

# Get the volume name
VOLUME_NAME=$(docker volume ls --format '{{.Name}}' | grep 'n8n_data' | head -n 1)

if [ -z "$VOLUME_NAME" ]; then
    echo -e "${RED}Error: n8n data volume not found${NC}"
    exit 1
fi

echo "Found volume: $VOLUME_NAME"

# Create temporary container to access volume
docker run --rm \
    -v "${VOLUME_NAME}:/data" \
    -v "$(pwd)/${BACKUP_DIR}:/backup" \
    alpine \
    tar czf "/backup/n8n_backup_${TIMESTAMP}.tar.gz" -C /data .

if [ $? -eq 0 ]; then
    echo -e "${GREEN}Backup created successfully!${NC}"
    echo "Backup file: ${BACKUP_FILE}"
    echo "Size: $(du -h "${BACKUP_FILE}" | cut -f1)"
else
    echo -e "${RED}Backup failed!${NC}"
    exit 1
fi

# Clean up old backups (keep last 7)
echo "Cleaning up old backups (keeping last 7)..."
ls -t "${BACKUP_DIR}"/n8n_backup_*.tar.gz | tail -n +8 | xargs -r rm

echo -e "${GREEN}Backup process completed!${NC}"
