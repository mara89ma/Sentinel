#!/bin/bash

# 변수 설정
LOCATION="eastus"
RESOURCE_GROUP="rg-syslog-demo"
VM_NAME="syslog-forwarder"
VNET_NAME="vnet-syslog"
SUBNET_NAME="subnet-syslog"
NSG_NAME="nsg-syslog"
NIC_NAME="${VM_NAME}-nic"
PUBLIC_IP_NAME="${VM_NAME}-pip"
ADMIN_USER="azureuser"
ADMIN_PASSWORD="SyslogTest123!"
VM_SIZE="Standard_B2ms"
MY_IP=$(curl -s ifconfig.me)

# 리소스 그룹 생성
az group create --name $RESOURCE_GROUP --location $LOCATION

# VNet + Subnet
az network vnet create \
  --resource-group $RESOURCE_GROUP \
  --name $VNET_NAME \
  --subnet-name $SUBNET_NAME

# NSG + 포트 규칙
az network nsg create --resource-group $RESOURCE_GROUP --name $NSG_NAME

az network nsg rule create \
  --resource-group $RESOURCE_GROUP \
  --nsg-name $NSG_NAME \
  --name AllowSyslog514 \
  --protocol "*" --direction Inbound --priority 100 \
  --source-address-prefixes "*" \
  --destination-port-ranges 514 \
  --access Allow

az network nsg rule create \
  --resource-group $RESOURCE_GROUP \
  --nsg-name $NSG_NAME \
  --name AllowSSHFromMyIP \
  --protocol Tcp --direction Inbound --priority 101 \
  --source-address-prefixes ${MY_IP}/32 \
  --destination-port-ranges 22 \
  --access Allow

az network nsg rule create \
  --resource-group $RESOURCE_GROUP \
  --nsg-name $NSG_NAME \
  --name DenyInboundAll \
  --protocol "*" --direction Inbound --priority 300 \
  --access Deny --source-address-prefixes "*" \
  --destination-port-ranges "*"

az network nsg rule create \
  --resource-group $RESOURCE_GROUP \
  --nsg-name $NSG_NAME \
  --name AllowOutbound443 \
  --protocol Tcp --direction Outbound --priority 310 \
  --destination-port-ranges 443 \
  --access Allow --source-address-prefixes "*" \
  --destination-address-prefixes "*" --source-port-ranges "*"

az network nsg rule create \
  --resource-group $RESOURCE_GROUP \
  --nsg-name $NSG_NAME \
  --name AllowOutbound80 \
  --protocol Tcp --direction Outbound --priority 311 \
  --destination-port-ranges 80 \
  --access Allow --source-address-prefixes "*" \
  --destination-address-prefixes "*" --source-port-ranges "*"

az network nsg rule create \
  --resource-group $RESOURCE_GROUP \
  --nsg-name $NSG_NAME \
  --name DenyAllOutbound \
  --protocol "*" --direction Outbound --priority 500 \
  --access Deny --source-address-prefixes "*" \
  --destination-port-ranges "*"

# 퍼블릭 IP
az network public-ip create \
  --resource-group $RESOURCE_GROUP \
  --name $PUBLIC_IP_NAME \
  --sku Standard \
  --allocation-method Static

# NIC 생성 (NSG + 퍼블릭 IP 연결)
az network nic create \
  --resource-group $RESOURCE_GROUP \
  --name $NIC_NAME \
  --vnet-name $VNET_NAME \
  --subnet $SUBNET_NAME \
  --network-security-group $NSG_NAME \
  --public-ip-address $PUBLIC_IP_NAME

# VM 생성 (비밀번호 로그인 방식)
az vm create \
  --resource-group $RESOURCE_GROUP \
  --name $VM_NAME \
  --nics $NIC_NAME \
  --image Ubuntu2204 \
  --admin-username $ADMIN_USER \
  --admin-password $ADMIN_PASSWORD \
  --authentication-type password \
  --size $VM_SIZE \
  --location $LOCATION

# rsyslog 자동 설정
sleep 20
az vm run-command invoke \
  --resource-group $RESOURCE_GROUP \
  --name $VM_NAME \
  --command-id RunShellScript \
  --scripts '
    timedatectl set-timezone Asia/Seoul
    apt update
    apt install -y rsyslog net-tools
    sed -i "/^#module(load=\"imudp\")/s/^#//" /etc/rsyslog.conf
    sed -i "/^#input(type=\"imudp\" port=\"514\")/s/^#//" /etc/rsyslog.conf
    sed -i "/^#module(load=\"imtcp\")/s/^#//" /etc/rsyslog.conf
    sed -i "/^#input(type=\"imtcp\" port=\"514\")/s/^#//" /etc/rsyslog.conf
    systemctl restart rsyslog
    systemctl enable rsyslog
  '

# 퍼블릭 IP 출력
echo "🔐 로그인 정보"
echo "  사용자명: $ADMIN_USER"
echo "  비밀번호: $ADMIN_PASSWORD"
echo -n "  퍼블릭 IP: "
az network public-ip show \
  --resource-group $RESOURCE_GROUP \
  --name $PUBLIC_IP_NAME \
  --query "ipAddress" \
  --output tsv
