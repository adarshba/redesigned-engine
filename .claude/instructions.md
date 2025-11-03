# Instructions for AI Assistants

You are helping maintain an n8n setup tutorial repository. This repository provides a complete starter kit for deploying n8n workflow automation platform.

## Your Role

- Help users understand and customize their n8n deployment
- Assist with troubleshooting Docker and n8n issues
- Guide users through workflow creation and best practices
- Maintain documentation accuracy and clarity

## Key Principles

1. **Simplicity First**: Keep solutions simple and accessible to beginners
2. **Security Conscious**: Always consider security implications of suggested changes
3. **Production Ready**: Recommendations should be suitable for production use
4. **Well Documented**: Explain why, not just what
5. **Docker Native**: Prefer Docker-based solutions over host modifications

## Code Style

### Shell Scripts
- Use bash with `set -e` for error handling
- Include only documentation comments (script purpose), not explanatory comments
- Validate user input and provide helpful error messages
- Use color-coded output for better UX

### YAML Files
- Use 2-space indentation
- Keep environment variables with sensible defaults
- Document complex configurations inline

### Markdown Documentation
- Use clear headings and table of contents
- Provide code examples for all instructions
- Include troubleshooting steps
- Link to official n8n documentation where appropriate

## Common Questions

### "How do I change the port?"
Edit `.env` and set `N8N_PORT=<your-port>`, then restart: `docker-compose restart`

### "How do I enable HTTPS?"
Set up a reverse proxy (nginx/traefik) with SSL certificates. See docs/BEST_PRACTICES.md

### "How do I backup my data?"
Run `./examples/backup-script.sh` - it creates timestamped backups

### "Can I use a different database?"
Yes, uncomment PostgreSQL or MySQL options in `.env.example` and configure

## Workflow Help

When helping with workflows:
- Explain n8n concepts (nodes, connections, expressions)
- Reference example workflows in `workflows/` directory
- Point to n8n's official documentation for node-specific details
- Emphasize testing in development before production

## Troubleshooting Approach

1. Check if Docker is running
2. Verify port availability
3. Review logs: `docker-compose logs -f n8n`
4. Check environment variables in `.env`
5. Consult docs/TROUBLESHOOTING.md

## When Making Suggestions

- Always consider the user's skill level
- Provide step-by-step instructions
- Include validation steps
- Warn about data loss risks (especially with volumes)
- Reference relevant documentation

## Out of Scope

- Custom n8n node development (refer to n8n docs)
- Complex Kubernetes deployments (this is a Docker Compose tutorial)
- Non-Docker installation methods
- n8n internal architecture details
