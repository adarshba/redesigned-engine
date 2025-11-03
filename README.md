# n8n Setup Starter Repository

A comprehensive tutorial repository for setting up and running n8n - the workflow automation platform. This repository contains all necessary resources, configurations, and examples to get you started with n8n quickly.

## 📋 Table of Contents

- [What is n8n?](#what-is-n8n)
- [Features](#features)
- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [Directory Structure](#directory-structure)
- [Configuration](#configuration)
- [Usage](#usage)
- [Example Workflows](#example-workflows)
- [Troubleshooting](#troubleshooting)
- [Best Practices](#best-practices)
- [Resources](#resources)
- [Contributing](#contributing)
- [License](#license)

## 🤔 What is n8n?

n8n (pronounced "nodemation") is a free and open-source workflow automation tool. It's designed for technical users who need flexible automation capabilities with a node-based approach.

**Key Benefits:**
- **Self-hosted:** Full control over your data and workflows
- **Extensible:** Create custom nodes and integrations
- **Fair-code licensed:** Source available with a sustainable business model
- **Visual workflow editor:** Intuitive drag-and-drop interface
- **400+ integrations:** Connect to popular services and APIs

## ✨ Features

This starter repository provides:

- 🐳 Docker Compose setup for easy deployment
- 📝 Pre-configured environment templates
- 🔄 Example workflow templates
- 📚 Comprehensive documentation
- 🛠️ Best practices and guidelines
- 🔒 Security configurations
- 🚀 Production-ready setup options

## 📦 Prerequisites

Before you begin, ensure you have the following installed:

- **Docker:** Version 20.10 or higher
- **Docker Compose:** Version 1.29 or higher
- **Git:** For cloning the repository
- At least **2GB of RAM** available
- Port **5678** available (default n8n port)

## 🚀 Quick Start

### 1. Clone the Repository

```bash
git clone https://github.com/adarshba/redesigned-engine.git
cd redesigned-engine
```

### 2. Configure Environment

```bash
cp .env.example .env
# Edit .env with your preferred settings
```

### 3. Start n8n

```bash
docker-compose up -d
```

### 4. Access n8n

Open your browser and navigate to:
```
http://localhost:5678
```

Create your owner account on first access.

## 📁 Directory Structure

```
.
├── README.md                 # This file
├── docker-compose.yml        # Docker composition for n8n
├── .env.example             # Environment variables template
├── .gitignore               # Git ignore rules
├── workflows/               # Example workflow JSON files
│   ├── hello-world.json
│   ├── webhook-example.json
│   └── scheduled-task.json
├── examples/                # Additional examples and scripts
│   ├── backup-script.sh
│   └── restore-script.sh
├── docs/                    # Additional documentation
│   ├── GETTING_STARTED.md
│   ├── BEST_PRACTICES.md
│   └── TROUBLESHOOTING.md
└── .n8n/                    # n8n data directory (created by Docker)
```

## ⚙️ Configuration

### Environment Variables

Key environment variables in `.env`:

| Variable | Description | Default |
|----------|-------------|---------|
| `N8N_PORT` | Port for n8n web interface | `5678` |
| `N8N_PROTOCOL` | HTTP protocol (http/https) | `http` |
| `N8N_HOST` | Hostname for n8n | `localhost` |
| `WEBHOOK_URL` | Base URL for webhooks | `http://localhost:5678/` |
| `GENERIC_TIMEZONE` | Timezone for n8n | `America/New_York` |
| `N8N_BASIC_AUTH_ACTIVE` | Enable basic auth | `false` |
| `N8N_BASIC_AUTH_USER` | Basic auth username | - |
| `N8N_BASIC_AUTH_PASSWORD` | Basic auth password | - |

### Advanced Configuration

For production deployments, consider:

- Setting up HTTPS with SSL certificates
- Configuring a reverse proxy (nginx/traefik)
- Setting up database persistence (PostgreSQL/MySQL)
- Implementing backup strategies
- Configuring authentication methods

See [docs/BEST_PRACTICES.md](docs/BEST_PRACTICES.md) for detailed guidance.

## 💻 Usage

### Starting n8n

```bash
# Start in detached mode
docker-compose up -d

# Start with logs visible
docker-compose up

# Start specific services
docker-compose up n8n
```

### Stopping n8n

```bash
# Stop all services
docker-compose down

# Stop and remove volumes (⚠️ removes all data)
docker-compose down -v
```

### Viewing Logs

```bash
# View all logs
docker-compose logs

# Follow logs in real-time
docker-compose logs -f

# View logs for specific service
docker-compose logs -f n8n
```

### Backing Up Data

```bash
# Create a backup
./examples/backup-script.sh

# Restore from backup
./examples/restore-script.sh backup-file.tar.gz
```

## 🔄 Example Workflows

This repository includes several example workflows in the `workflows/` directory:

### 1. Hello World (`hello-world.json`)
A simple workflow demonstrating basic node connections and data flow.

### 2. Webhook Example (`webhook-example.json`)
Demonstrates how to create and use webhooks to trigger workflows.

### 3. Scheduled Task (`scheduled-task.json`)
Shows how to set up cron-based scheduled workflows.

### Importing Workflows

1. Access n8n at `http://localhost:5678`
2. Click "Workflows" → "Import from File"
3. Select a workflow JSON file from the `workflows/` directory
4. Configure any required credentials
5. Activate the workflow

## 🔧 Troubleshooting

### Common Issues

**Port 5678 already in use:**
```bash
# Change N8N_PORT in .env file
N8N_PORT=5679
```

**Cannot access n8n:**
- Verify Docker containers are running: `docker-compose ps`
- Check logs: `docker-compose logs -f n8n`
- Ensure firewall allows access to the configured port

**Workflow not executing:**
- Check workflow is activated (toggle in top-right)
- Verify credentials are properly configured
- Review execution logs in n8n interface

For more detailed troubleshooting, see [docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md).

## ✅ Best Practices

1. **Version Control:** Track your workflow JSON files in Git
2. **Environment Variables:** Never commit sensitive credentials
3. **Backups:** Regularly backup your n8n data directory
4. **Updates:** Keep n8n updated to the latest stable version
5. **Security:** Use HTTPS in production and enable authentication
6. **Documentation:** Document custom workflows and integrations
7. **Testing:** Test workflows in a development environment first

See [docs/BEST_PRACTICES.md](docs/BEST_PRACTICES.md) for comprehensive guidelines.

## 📚 Resources

### Official Documentation
- [n8n Documentation](https://docs.n8n.io/)
- [n8n Community Forum](https://community.n8n.io/)
- [n8n GitHub Repository](https://github.com/n8n-io/n8n)

### Tutorials
- [Getting Started with n8n](https://docs.n8n.io/getting-started/)
- [Creating Your First Workflow](https://docs.n8n.io/workflows/workflows/)
- [Understanding Nodes](https://docs.n8n.io/workflows/nodes/)

### Community
- [Discord Server](https://discord.gg/n8n)
- [YouTube Channel](https://www.youtube.com/c/n8n-io)
- [Twitter](https://twitter.com/n8n_io)

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

n8n itself is licensed under the [Sustainable Use License](https://github.com/n8n-io/n8n/blob/master/LICENSE.md).

---

**Note:** This is a starter template repository. Customize it according to your specific needs and requirements.

For questions or support, please open an issue in this repository.