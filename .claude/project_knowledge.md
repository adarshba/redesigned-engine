# n8n Setup Starter Repository - Project Knowledge

## Project Overview

This is a comprehensive tutorial repository for setting up and running n8n, an open-source workflow automation platform. The repository provides production-ready Docker configurations, example workflows, and extensive documentation for both beginners and advanced users.

## Key Components

### Infrastructure
- **docker-compose.yml**: Production-ready n8n deployment with health checks
- **.env.example**: Complete environment variable template with security and configuration options
- **.gitignore**: Excludes n8n data, credentials, logs, and build artifacts

### Documentation
- **README.md**: Main entry point with quick start and overview
- **docs/GETTING_STARTED.md**: Step-by-step setup guide
- **docs/BEST_PRACTICES.md**: Production deployment and security guidelines
- **docs/TROUBLESHOOTING.md**: Common issues and solutions

### Examples
- **workflows/**: Three example workflows (hello-world, webhook, scheduled-task)
- **examples/**: Backup and restore utility scripts

## Technical Stack

- **Container Platform**: Docker & Docker Compose
- **Application**: n8n (Node.js based workflow automation)
- **Default Database**: SQLite (with PostgreSQL/MySQL options)
- **Default Port**: 5678

## Architecture Decisions

### Why Docker Compose?
- Simplifies deployment and dependency management
- Provides consistent environment across platforms
- Easy to customize and extend
- Suitable for both development and production

### Volume Strategy
- Named volume for data persistence
- Read-only workflow directory for examples
- Separates data from code

### Security Approach
- Environment-based configuration
- Optional basic authentication
- HTTPS support via reverse proxy
- Credential encryption options

## Development Guidelines

### File Structure
```
.
├── README.md                 # Main documentation
├── docker-compose.yml        # Docker configuration
├── .env.example             # Environment template
├── workflows/               # Example workflows
├── examples/                # Utility scripts
└── docs/                    # Extended documentation
```

### Workflow Examples
All workflow JSON files follow n8n's standard format and are importable directly into n8n.

### Scripts
Backup and restore scripts use Docker volumes to safely handle data without requiring direct filesystem access.

## Common Tasks

### Start n8n
```bash
docker-compose up -d
```

### Backup Data
```bash
./examples/backup-script.sh
```

### Restore Data
```bash
./examples/restore-script.sh backups/n8n_backup_TIMESTAMP.tar.gz
```

### View Logs
```bash
docker-compose logs -f n8n
```

## Resources

- n8n Documentation: https://docs.n8n.io/
- n8n Community: https://community.n8n.io/
- n8n GitHub: https://github.com/n8n-io/n8n
