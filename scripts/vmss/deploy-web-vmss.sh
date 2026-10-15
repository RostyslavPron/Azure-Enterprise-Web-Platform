#!/bin/bash

RG="rg-enterprise-prod"

az vmss create \
  --resource-group $RG \
  --name web-vmss \
  --image Win2022Datacenter \
  --instance-count 2 \
  --vm-sku Standard_B2s \
  --vnet-name prod-vnet \
  --subnet WebSubnet \
  --lb web-lb