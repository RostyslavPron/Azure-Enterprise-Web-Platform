#!/bin/bash

RG="rg-enterprise-prod"
VAULT="rsv-enterprise-platform"
VM="webvm"

az backup protection enable-for-vm \
  --resource-group $RG \
  --vault-name $VAULT \
  --vm $VM \
  --policy-name DefaultPolicy