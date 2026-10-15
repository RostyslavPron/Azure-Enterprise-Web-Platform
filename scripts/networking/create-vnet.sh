#!/bin/bash

RG="rg-enterprise-prod"
LOCATION="canadacentral"

az group create \
  --name $RG \
  --location $LOCATION

az network vnet create \
  --resource-group $RG \
  --name prod-vnet \
  --address-prefix 10.0.0.0/16 \
  --subnet-name WebSubnet \
  --subnet-prefix 10.0.1.0/24

az network vnet subnet create \
  --resource-group $RG \
  --vnet-name prod-vnet \
  --name AppSubnet \
  --address-prefixes 10.0.2.0/24

az network vnet subnet create \
  --resource-group $RG \
  --vnet-name prod-vnet \
  --name MgmtSubnet \
  --address-prefixes 10.0.3.0/24