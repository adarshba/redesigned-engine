# Getting Started with n8n

This guide will walk you through setting up and running your first n8n workflow.

## Table of Contents

1. [Installation](#installation)
2. [First Time Setup](#first-time-setup)
3. [Creating Your First Workflow](#creating-your-first-workflow)
4. [Understanding Nodes](#understanding-nodes)
5. [Working with Credentials](#working-with-credentials)
6. [Testing Workflows](#testing-workflows)
7. [Activating Workflows](#activating-workflows)
8. [Next Steps](#next-steps)

## Installation

### Prerequisites

Ensure you have installed:
- Docker (20.10 or higher)
- Docker Compose (1.29 or higher)

### Step 1: Clone the Repository

```bash
git clone https://github.com/adarshba/redesigned-engine.git
cd redesigned-engine
```

### Step 2: Configure Environment

```bash
cp .env.example .env
```

Edit the `.env` file to customize settings:
- Change `N8N_PORT` if 5678 is already in use
- Set `GENERIC_TIMEZONE` to your local timezone
- Configure authentication for production use

### Step 3: Start n8n

```bash
docker-compose up -d
```

Wait for the container to start (usually takes 10-30 seconds).

### Step 4: Access n8n

Open your web browser and navigate to:
```
http://localhost:5678
```

## First Time Setup

When you first access n8n, you'll need to create an owner account:

1. Enter your email address
2. Create a strong password
3. (Optional) Set up your profile information

**Important:** Save your credentials securely! This is the admin account.

## Creating Your First Workflow

### Step 1: Create a New Workflow

1. Click the **"+"** button or "New Workflow" in the sidebar
2. You'll see a blank canvas with a "Start" node

### Step 2: Add Nodes

1. Click the **"+"** icon on the canvas
2. Search for a node (e.g., "Set")
3. Click to add it to the canvas

### Step 3: Connect Nodes

1. Hover over the **Start** node
2. Click and drag from the right connection point
3. Drop on the target node

### Step 4: Configure Nodes

1. Click on a node to open its parameters panel
2. Configure the required settings
3. Click "Execute Node" to test

### Example: Hello World Workflow

Create a simple workflow:

1. **Start Node** (already present)
2. **Set Node**: Add key-value pairs
   - Key: `message`
   - Value: `Hello from n8n!`
3. **Code Node**: Transform data
   ```javascript
   return [{
     json: {
       message: $input.first().json.message.toUpperCase(),
       timestamp: new Date().toISOString()
     }
   }];
   ```

## Understanding Nodes

### Node Types

- **Trigger Nodes**: Start workflows (Webhook, Cron, Manual)
- **Action Nodes**: Perform operations (HTTP Request, Database, etc.)
- **Logic Nodes**: Control flow (IF, Switch, Merge)
- **Transform Nodes**: Modify data (Set, Function, Code)

### Common Nodes

- **Webhook**: Receive HTTP requests
- **HTTP Request**: Make API calls
- **Set**: Add/modify data
- **IF**: Conditional logic
- **Code**: Custom JavaScript/Python
- **Cron**: Schedule workflows

## Working with Credentials

### Adding Credentials

1. Click on a node requiring authentication
2. Click **"Create New Credential"**
3. Enter required information
4. Save the credential

### Managing Credentials

Access from: **Settings > Credentials**

**Security Tips:**
- Use unique credentials per service
- Regularly rotate sensitive credentials
- Never commit credentials to version control
- Use environment variables for sensitive data

## Testing Workflows

### Manual Testing

1. Click **"Execute Workflow"** button
2. Review execution in the output panel
3. Check each node's output
4. Fix any errors

### Debug Mode

- View data passing between nodes
- Inspect error messages
- Check execution time

### Best Practices

- Test with sample data first
- Validate error handling
- Check edge cases
- Use Try/Catch for error handling

## Activating Workflows

### Production Activation

1. Test thoroughly first
2. Configure all credentials
3. Click the **toggle switch** in the top-right
4. Workflow status changes to "Active"

### Monitoring

- View execution history
- Check for errors
- Monitor performance
- Review logs

## Next Steps

### Learn More

1. **Import Example Workflows**
   - Browse the `workflows/` directory
   - Import and study provided examples
   - Modify to fit your needs

2. **Explore Integrations**
   - Browse available nodes
   - Connect to your services
   - Build automations

3. **Advanced Features**
   - Variables and expressions
   - Error workflows
   - Sub-workflows
   - Custom nodes

### Resources

- [n8n Documentation](https://docs.n8n.io/)
- [Community Forum](https://community.n8n.io/)
- [Example Workflows](https://n8n.io/workflows)
- [YouTube Tutorials](https://www.youtube.com/c/n8n-io)

### Common Use Cases

- **Data Integration**: Sync data between applications
- **Notification Systems**: Alert on events
- **Data Processing**: Transform and enrich data
- **API Workflows**: Automate API interactions
- **Scheduled Tasks**: Run jobs on schedule

## Troubleshooting

### Workflow Not Executing

- Check if workflow is activated
- Verify credentials are configured
- Review error messages in execution log
- Test nodes individually

### Cannot Access n8n

- Verify Docker is running: `docker-compose ps`
- Check logs: `docker-compose logs -f n8n`
- Ensure port 5678 is not in use
- Check firewall settings

### Need Help?

- Check [Troubleshooting Guide](TROUBLESHOOTING.md)
- Visit [Community Forum](https://community.n8n.io/)
- Review [Documentation](https://docs.n8n.io/)

---

**Congratulations!** You're now ready to build powerful automations with n8n. Start with simple workflows and gradually explore more advanced features.
