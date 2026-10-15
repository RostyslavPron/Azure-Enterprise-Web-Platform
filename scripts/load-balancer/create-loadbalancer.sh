#!/bin/bash

RG="rg-enterprise-prod"
LOCATION="canadacentral"

# Create Public IP
az network public-ip create \
  --resource-group $RG \
  --name web-lb-pip \
  --sku Standard \
  --allocation-method Static

# Create Load Balancer
az network lb create \
  --resource-group $RG \
  --name web-lb \
  --sku Standard \
  --public-ip-address web-lb-pip \
  --frontend-ip-name frontend-config \
  --backend-pool-name web-backend-pool

# Create Health Probe
az network lb probe create \
  --resource-group $RG \
  --lb-name web-lb \
  --name http-probe \
  --protocol Tcp \
  --port 80

# Create Load Balancing Rule
az network lb rule create \
  --resource-group $RG \
  --lb-name web-lb \
  --name http-rule \
  --protocol Tcp \
  --frontend-port 80 \
  --backend-port 80 \
  --frontend-ip-name frontend-config \
  --backend-pool-name web-backend-pool \
  --probe-name http-probe