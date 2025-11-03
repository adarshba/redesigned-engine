# n8n Best Practices

This guide covers best practices for developing, deploying, and maintaining n8n workflows.

## Table of Contents

1. [Workflow Design](#workflow-design)
2. [Security](#security)
3. [Performance](#performance)
4. [Error Handling](#error-handling)
5. [Development Workflow](#development-workflow)
6. [Production Deployment](#production-deployment)
7. [Maintenance](#maintenance)
8. [Monitoring](#monitoring)

## Workflow Design

### Keep Workflows Focused

- **Single Responsibility**: Each workflow should handle one specific task
- **Modular Design**: Break complex processes into smaller workflows
- **Reusability**: Create sub-workflows for common operations

### Use Clear Naming

```
✅ Good: "Sync_Customers_From_Salesforce_To_Database"
❌ Bad: "Workflow1" or "Test"
```

### Node Naming Conventions

- Use descriptive names for nodes
- Include the operation (e.g., "Fetch Customer Data")
- Use consistent naming patterns

### Documentation

- Add notes to complex nodes
- Document workflow purpose in description
- Comment complex expressions
- Maintain a workflow changelog

### Version Control

- Export workflows as JSON
- Commit to Git repository
- Use meaningful commit messages
- Tag releases

## Security

### Credential Management

**DO:**
- ✅ Use n8n's credential system
- ✅ Rotate credentials regularly
- ✅ Use separate credentials for dev/prod
- ✅ Limit credential access by user
- ✅ Store sensitive data in environment variables

**DON'T:**
- ❌ Hardcode credentials in workflows
- ❌ Share credentials across environments
- ❌ Commit credentials to version control
- ❌ Use overly permissive credentials

### Environment Variables

Store sensitive configuration in `.env`:

```bash
# Good
N8N_ENCRYPTION_KEY=your-secure-key-here
API_SECRET=your-secret-here

# Reference in workflow
{{$env.API_SECRET}}
```

### Authentication

**For Production:**
- Enable authentication (basic auth or LDAP)
- Use HTTPS/SSL certificates
- Implement IP whitelisting if possible
- Set strong passwords
- Enable two-factor authentication if available

### Network Security

- Use reverse proxy (nginx, Traefik)
- Implement rate limiting
- Enable CORS only for trusted domains
- Use VPN for sensitive workflows
- Isolate n8n network

## Performance

### Workflow Optimization

**Reduce Execution Time:**
- Minimize HTTP requests
- Use batch operations
- Implement pagination
- Cache frequently accessed data
- Avoid unnecessary transformations

**Parallel Processing:**
```
Use "Split in Batches" + "Merge" for parallel operations
```

**Efficient Data Handling:**
- Process data in chunks
- Use filters early in workflow
- Limit returned fields in API calls
- Implement early exits for invalid data

### Resource Management

**Docker Configuration:**
```yaml
deploy:
  resources:
    limits:
      cpus: '2'
      memory: 2G
    reservations:
      memory: 1G
```

**Database Optimization:**
- Use PostgreSQL for production (not SQLite)
- Regular database maintenance
- Index commonly queried fields
- Archive old execution data

### Limits and Timeouts

```bash
# Set appropriate timeouts
EXECUTIONS_TIMEOUT=300
EXECUTIONS_TIMEOUT_MAX=3600

# Limit workflow executions
N8N_PAYLOAD_SIZE_MAX=16

# Set memory limits
NODE_OPTIONS=--max-old-space-size=2048
```

## Error Handling

### Implement Try-Catch

Always handle potential errors:
- Use Error Trigger workflows
- Implement retry logic
- Log errors appropriately
- Send failure notifications

### Error Workflow Pattern

```
Main Workflow → [Error] → Error Handler Workflow
                           ↓
                    - Log Error
                    - Send Notification
                    - Retry Logic
```

### Graceful Degradation

- Provide fallback options
- Don't fail entire workflow for minor issues
- Implement circuit breakers
- Use default values

### Validation

- Validate input data early
- Check API responses
- Verify credentials before execution
- Test edge cases

## Development Workflow

### Local Development

1. **Use Separate Instance**
   - Development environment separate from production
   - Different database for testing
   - Copy workflows, not data

2. **Testing Strategy**
   - Test with sample data
   - Validate all branches (IF conditions)
   - Test error scenarios
   - Use mock endpoints for development

3. **Code Review**
   - Review workflow JSON changes
   - Test critical workflows manually
   - Validate credentials are not exposed
   - Check for performance issues

### CI/CD Integration

**Automated Workflow Testing:**
```bash
# Export workflows
n8n export:workflow --all --output=./workflows

# Import to test environment
n8n import:workflow --input=./workflows
```

### Environment Separation

- **Development**: Testing and experimentation
- **Staging**: Pre-production validation
- **Production**: Live workflows

## Production Deployment

### Pre-Deployment Checklist

- [ ] All credentials configured
- [ ] Webhooks URLs updated for production domain
- [ ] HTTPS/SSL certificates installed
- [ ] Authentication enabled
- [ ] Backups configured
- [ ] Monitoring set up
- [ ] Error notifications configured
- [ ] Documentation updated
- [ ] Team trained on workflows

### Infrastructure

**Use Production Database:**
```yaml
DB_TYPE=postgresdb
DB_POSTGRESDB_HOST=postgres
DB_POSTGRESDB_DATABASE=n8n
```

**Enable Security Features:**
```bash
N8N_BASIC_AUTH_ACTIVE=true
N8N_BASIC_AUTH_USER=admin
N8N_BASIC_AUTH_PASSWORD=secure-password

# Or use JWT
N8N_JWT_AUTH_SECRET=your-jwt-secret
```

**Reverse Proxy (nginx example):**
```nginx
server {
    listen 443 ssl;
    server_name n8n.yourdomain.com;
    
    ssl_certificate /path/to/cert.pem;
    ssl_certificate_key /path/to/key.pem;
    
    location / {
        proxy_pass http://localhost:5678;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
```

### High Availability

- Use container orchestration (Kubernetes, Docker Swarm)
- Implement load balancing
- Configure database replication
- Set up automatic failover
- Use persistent volumes

## Maintenance

### Regular Tasks

**Daily:**
- Monitor execution logs
- Check for failed workflows
- Review system resources

**Weekly:**
- Review workflow performance
- Update credentials if needed
- Check for n8n updates

**Monthly:**
- Backup workflows and data
- Archive old executions
- Review and optimize slow workflows
- Update documentation

### Backup Strategy

**What to Backup:**
- Workflow JSON files
- Credentials (encrypted)
- Database
- Environment configuration

**Backup Script:**
```bash
# Automated daily backups
0 2 * * * /path/to/backup-script.sh
```

**Retention Policy:**
- Daily backups: Keep 7 days
- Weekly backups: Keep 4 weeks
- Monthly backups: Keep 12 months

### Updates

**Update Process:**
1. Review changelog
2. Test in development
3. Backup production
4. Schedule maintenance window
5. Update and test
6. Monitor for issues

## Monitoring

### Metrics to Track

- **Execution Metrics:**
  - Success/failure rates
  - Execution duration
  - Queue depth
  - Error frequency

- **System Metrics:**
  - CPU usage
  - Memory usage
  - Disk space
  - Network traffic

### Logging

**Enable Appropriate Log Level:**
```bash
# Production
N8N_LOG_LEVEL=info

# Development
N8N_LOG_LEVEL=debug
```

**Log Management:**
- Use centralized logging (ELK, Splunk)
- Set up log rotation
- Monitor error logs
- Alert on critical errors

### Alerts

**Configure Alerts For:**
- Workflow failures
- System resource thresholds
- Authentication failures
- Database connection issues
- API rate limits

### Health Checks

```bash
# Docker health check
healthcheck:
  test: ["CMD", "wget", "--quiet", "--tries=1", "--spider", "http://localhost:5678/healthz"]
  interval: 30s
  timeout: 10s
  retries: 3
```

## Troubleshooting Tips

### Performance Issues

1. Check execution history for slow workflows
2. Review database query performance
3. Monitor system resources
4. Optimize data processing
5. Implement caching

### Common Pitfalls

**Avoid:**
- Infinite loops
- Unbounded recursion
- Processing entire large datasets at once
- Hardcoding values that should be configurable
- Ignoring error responses

### Documentation

Maintain documentation for:
- Workflow purposes and dependencies
- Credential requirements
- Environment variables
- Deployment procedures
- Troubleshooting guides

---

Following these best practices will help you build robust, maintainable, and secure n8n workflows that scale with your needs.
