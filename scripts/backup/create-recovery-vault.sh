#!/bin/bash

RG="rg-enterprise-prod"
LOCATION="canadacentral"

az backup vault create \
  --resource-group $RG \
  --name rsv-enterprise-platform \
  --location $LOCATION