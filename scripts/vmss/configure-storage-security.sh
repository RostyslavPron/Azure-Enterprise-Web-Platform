#!/bin/bash

RG="rg-enterprise-prod"
STORAGE="stenterpriseweb001"
IP="X.X.X.X"

# HTTPS only
az storage account update \
  --resource-group $RG \
  --name $STORAGE \
  --https-only true

# Disable public blob access
az storage account update \
  --resource-group $RG \
  --name $STORAGE \
  --allow-blob-public-access false

# Storage firewall
az storage account network-rule add \
  --resource-group $RG \
  --account-name $STORAGE \
  --ip-address $IP

az storage account update \
  --resource-group $RG \
  --name $STORAGE \
  --default-action Deny