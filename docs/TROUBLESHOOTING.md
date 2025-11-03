# Troubleshooting Guide

Common issues and solutions for n8n setup and operations.

## Table of Contents

1. [Installation Issues](#installation-issues)
2. [Connection Problems](#connection-problems)
3. [Workflow Execution Issues](#workflow-execution-issues)
4. [Performance Problems](#performance-problems)
5. [Docker Issues](#docker-issues)
6. [Authentication Issues](#authentication-issues)
7. [Webhook Problems](#webhook-problems)
8. [Database Issues](#database-issues)
9. [Common Error Messages](#common-error-messages)
10. [Getting Help](#getting-help)

## Installation Issues

### Docker Not Running

**Symptoms:**
- Cannot start containers
- `docker-compose` commands fail

**Solution:**
```bash
# Check Docker status
systemctl status docker

# Start Docker
sudo systemctl start docker

# Enable Docker on boot
sudo systemctl enable docker
```

### Port Already in Use

**Symptoms:**
- Error: "port is already allocated"
- Cannot access n8n on default port

**Solution:**
```bash
# Find what's using port 5678
sudo lsof -i :5678
# or
sudo netstat -tulpn | grep 5678

# Option 1: Stop the conflicting service
# Option 2: Change n8n port in .env
N8N_PORT=5679
```

### Permission Denied

**Symptoms:**
- Cannot create volumes
- Cannot write to directories

**Solution:**
```bash
# Add user to docker group
sudo usermod -aG docker $USER

# Logout and login again, or run:
newgrp docker

# Fix directory permissions
sudo chown -R $USER:$USER .
```

## Connection Problems

### Cannot Access n8n UI

**Symptoms:**
- Browser shows "Cannot connect"
- Page doesn't load

**Diagnostic Steps:**
```bash
# 1. Check if container is running
docker-compose ps

# 2. Check container logs
docker-compose logs -f n8n

# 3. Check if port is accessible
curl http://localhost:5678/healthz

# 4. Check firewall
sudo ufw status
```

**Solutions:**

**If container not running:**
```bash
docker-compose up -d
```

**If port blocked:**
```bash
# Open port in firewall
sudo ufw allow 5678/tcp
```

**If DNS issues:**
- Try accessing via IP instead of hostname
- Check /etc/hosts file

### Webhook Not Receiving Data

**Symptoms:**
- Webhook workflow not triggering
- External services cannot reach webhook

**Solution:**

1. **Check Webhook URL:**
   ```bash
   # Should match your actual domain/IP
   WEBHOOK_URL=https://yourdomain.com/
   ```

2. **Verify Workflow is Active:**
   - Check toggle switch is ON
   - Refresh workflow page

3. **Test Webhook:**
   ```bash
   # Get webhook URL from n8n
   # Test with curl
   curl -X POST http://localhost:5678/webhook/test \
     -H "Content-Type: application/json" \
     -d '{"test": "data"}'
   ```

4. **Check Firewall/Network:**
   - Ensure port is accessible from internet
   - Check reverse proxy configuration
   - Verify SSL/TLS if using HTTPS

## Workflow Execution Issues

### Workflow Not Executing

**Symptoms:**
- Manual execution works but scheduled doesn't
- Workflow remains in queue
- No execution history

**Diagnostic Steps:**

1. **Check if Active:**
   - Verify toggle is ON
   - Check activation status in workflow list

2. **Review Logs:**
   ```bash
   docker-compose logs -f n8n | grep -i error
   ```

3. **Check Trigger Configuration:**
   - Cron expression valid
   - Webhook path unique
   - Credentials configured

**Solutions:**

**For Cron Issues:**
```bash
# Test cron expression at https://crontab.guru/
# Example: Every day at 9 AM
0 9 * * *
```

**For Queue Issues:**
```bash
# Restart n8n
docker-compose restart n8n
```

### Credentials Not Working

**Symptoms:**
- "401 Unauthorized" errors
- Authentication failures
- API rejecting requests

**Solutions:**

1. **Verify Credentials:**
   - Check username/password
   - Verify API keys/tokens
   - Ensure credentials not expired

2. **Test Credentials:**
   - Use external tool (Postman, curl)
   - Verify with service provider

3. **Recreate Credential:**
   - Delete old credential
   - Create new one
   - Update workflow references

### Expression Errors

**Symptoms:**
- "Expression error" in execution
- Unexpected values in output

**Common Issues:**

**Undefined Variables:**
```javascript
// ❌ Wrong
{{$json.field.subfield}}

// ✅ Correct (with null check)
{{$json.field?.subfield ?? 'default'}}
```

**Data Type Issues:**
```javascript
// ❌ Wrong
{{$json.id + 1}}  // if id is string

// ✅ Correct
{{parseInt($json.id) + 1}}
```

**Solution:**
- Use expression editor's test feature
- Check data structure in previous node
- Add error handling

## Performance Problems

### Slow Workflow Execution

**Symptoms:**
- Workflows take long time to complete
- Timeouts occurring

**Diagnostic Steps:**

1. **Check Execution Time:**
   - Review execution history
   - Identify slow nodes
   - Check external API response times

2. **Review Resource Usage:**
   ```bash
   # Check container resources
   docker stats n8n
   ```

**Solutions:**

**Optimize Workflow:**
- Process data in batches
- Use pagination
- Reduce unnecessary transformations
- Cache frequently accessed data

**Increase Resources:**
```yaml
# In docker-compose.yml
deploy:
  resources:
    limits:
      cpus: '2'
      memory: 2G
```

**Increase Timeout:**
```bash
# In .env
EXECUTIONS_TIMEOUT=600
EXECUTIONS_TIMEOUT_MAX=1800
```

### High Memory Usage

**Symptoms:**
- Container crashes
- Out of memory errors

**Solutions:**

1. **Increase Container Memory:**
   ```bash
   # In .env
   NODE_OPTIONS=--max-old-space-size=4096
   ```

2. **Optimize Workflows:**
   - Process smaller datasets
   - Clear unused data
   - Use streaming where possible

3. **Database Cleanup:**
   ```bash
   # Archive old executions
   # Configure in n8n settings
   ```

## Docker Issues

### Container Keeps Restarting

**Symptoms:**
- Container starts then stops
- Restart loop

**Diagnostic Steps:**
```bash
# Check logs
docker-compose logs n8n

# Check container status
docker inspect n8n
```

**Common Causes:**

1. **Port Conflict:** Change N8N_PORT
2. **Volume Permissions:** Fix with `chown`
3. **Memory Limit:** Increase resources
4. **Configuration Error:** Check .env file

### Cannot Remove Containers

**Symptoms:**
- "container is in use" error
- Cannot stop container

**Solution:**
```bash
# Force stop
docker-compose down --remove-orphans

# Force remove
docker rm -f n8n

# Remove volumes (⚠️ deletes data)
docker-compose down -v
```

### Volume Issues

**Symptoms:**
- Data not persisting
- Lost workflows after restart

**Solution:**
```bash
# Check volumes
docker volume ls

# Inspect volume
docker volume inspect n8n_data

# Backup before fixing
./examples/backup-script.sh

# Recreate volume
docker-compose down
docker volume rm n8n_data
docker-compose up -d
```

## Authentication Issues

### Forgotten Password

**Solution:**

**For Basic Auth:**
```bash
# Reset by removing auth temporarily
docker-compose down
# Edit .env: Set N8N_BASIC_AUTH_ACTIVE=false
docker-compose up -d
# Create new account
# Re-enable auth
```

**For Owner Account:**
- Access database directly
- Reset via CLI (if available)
- Restore from backup

### Cannot Login

**Symptoms:**
- Valid credentials rejected
- Session expires immediately

**Solutions:**

1. **Clear Browser Cache:**
   - Clear cookies
   - Use incognito mode
   - Try different browser

2. **Check Configuration:**
   ```bash
   # Verify auth settings in .env
   N8N_BASIC_AUTH_ACTIVE=true
   ```

3. **Check Logs:**
   ```bash
   docker-compose logs -f n8n | grep -i auth
   ```

## Webhook Problems

### Webhook Returns 404

**Symptoms:**
- Webhook URL returns "Not Found"
- External service cannot trigger workflow

**Solutions:**

1. **Verify Workflow Active:**
   - Toggle must be ON
   - Refresh to ensure saved

2. **Check Webhook Path:**
   - Must be unique
   - Case sensitive
   - No special characters

3. **Verify URL:**
   ```bash
   # Correct format
   http://localhost:5678/webhook/your-path
   
   # Not
   http://localhost:5678/your-path
   ```

### Webhook Timeout

**Symptoms:**
- Request times out
- No response from n8n

**Solutions:**

1. **Use Respond to Webhook Node:**
   - Required for synchronous webhooks
   - Must be in execution path

2. **Increase Timeout:**
   ```bash
   # In workflow or .env
   EXECUTIONS_TIMEOUT=300
   ```

3. **Use Async Pattern:**
   - Return immediate response
   - Process in background

## Database Issues

### Database Locked

**Symptoms:**
- "database is locked" error
- Cannot save workflows

**Solution:**
```bash
# For SQLite (default)
docker-compose restart n8n

# For production, use PostgreSQL
# Update docker-compose.yml
```

### Migration Failures

**Symptoms:**
- Errors after update
- Database schema issues

**Solution:**
```bash
# Backup first!
./examples/backup-script.sh

# Stop n8n
docker-compose down

# Remove database (⚠️ loses data if no backup)
docker volume rm n8n_data

# Start fresh
docker-compose up -d

# Restore from backup
./examples/restore-script.sh backup-file.tar.gz
```

## Common Error Messages

### "Error: ECONNREFUSED"

**Meaning:** Cannot connect to external service

**Solutions:**
- Check service is running
- Verify URL/hostname
- Check firewall/network
- Validate credentials

### "Error: Maximum execution time exceeded"

**Meaning:** Workflow took too long

**Solutions:**
- Increase timeout in .env
- Optimize workflow
- Process data in smaller batches

### "Error: Invalid credentials"

**Meaning:** Authentication failed

**Solutions:**
- Recreate credentials
- Verify with service provider
- Check credential type matches node

### "Error: CORS policy"

**Meaning:** Cross-origin request blocked

**Solutions:**
```bash
# Add to .env
N8N_CORS_ALLOW_LIST=https://yourdomain.com
```

## Getting Help

### Before Asking for Help

1. **Check Logs:**
   ```bash
   docker-compose logs -f n8n
   ```

2. **Review Documentation:**
   - This troubleshooting guide
   - [n8n Documentation](https://docs.n8n.io/)
   - [Getting Started Guide](GETTING_STARTED.md)

3. **Search Community:**
   - [Community Forum](https://community.n8n.io/)
   - [GitHub Issues](https://github.com/n8n-io/n8n/issues)

### When Asking for Help

**Include:**
- n8n version (`docker exec n8n n8n --version`)
- Docker version
- Operating system
- Error messages (full text)
- Steps to reproduce
- Relevant logs
- What you've tried

**Example:**
```
n8n version: 1.x.x
Docker: 20.10.x
OS: Ubuntu 22.04

Error: "workflow execution failed"
Logs: [paste relevant logs]
Steps: 1. Created webhook workflow 2. ...
Tried: Restarted container, checked credentials
```

### Resources

- **Community Forum:** https://community.n8n.io/
- **Discord:** https://discord.gg/n8n
- **Documentation:** https://docs.n8n.io/
- **GitHub Issues:** https://github.com/n8n-io/n8n/issues

---

If you encounter an issue not covered here, please contribute by submitting a pull request with the solution!
