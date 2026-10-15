# Deployment Guide

## Overview

This guide outlines the deployment process for the Azure Enterprise Web Platform.

The platform is deployed using Infrastructure as Code (IaC) through reusable Bicep modules and can be managed using Azure CLI and PowerShell automation scripts.

---

## Prerequisites

Before deployment, ensure the following requirements are met:

- Active Azure Subscription
- Azure CLI installed
- Bicep CLI installed
- Appropriate permissions to create Azure resources
- PowerShell Az Module (optional)

---

## Authentication

Login to Azure:

```bash
az login
```

Verify the active subscription:

```bash
az account show
```

---

## Create Resource Group

```bash
az group create \
  --name rg-enterprise-prod \
  --location canadacentral
```

---

## Deploy Infrastructure

Deploy the environment using the main Bicep template:

```bash
az deployment group create \
  --resource-group rg-enterprise-prod \
  --template-file infrastructure/main.bicep
```

---

## Deployed Components

The deployment includes:

### Networking

- Azure Virtual Network
- Web Subnet
- Application Subnet
- Management Subnet

### Security

- Network Security Groups
- Azure Key Vault
- Customer Managed Keys

### Compute

- Azure Load Balancer
- Web VM Scale Set
- Application VM Scale Set

### Monitoring

- Azure Monitor
- Log Analytics Workspace
- Alerting Components

### Recovery

- Recovery Services Vault
- Azure Backup Policies

---

## Validation Checklist

After deployment, verify:

- Virtual Network deployed successfully
- NSGs associated with appropriate subnets
- Load Balancer operational
- VM Scale Sets deployed successfully
- Storage Account configured securely
- Key Vault created and accessible
- Log Analytics Workspace operational
- Recovery Services Vault available

---

## Infrastructure Management

Individual resources may also be managed using:

- Azure Portal
- Azure CLI scripts
- PowerShell automation scripts

Scripts are located under:

```text
scripts/
```

---

## Cleanup

To remove all deployed resources:

```bash
az group delete \
  --name rg-enterprise-prod \
  --yes
```