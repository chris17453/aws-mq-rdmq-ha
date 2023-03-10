


MQIPT_IMAGE=9.3.2.0-IBM-MQIPT-LinuxX64.tar.gz
MQADV_IMAGE=mqadv_dev931_linux_x86-64.tar.gz

PROJECT_NAME=mq
PROJECT_REV=7
PRJ_ID=$(PROJECT_NAME)-$(PROJECT_REV)

### TEMPLATING SUFFIXES


UID_REGION_A=dc1
UID_REGION_B=dc2
UID_MQ=mq

UID_A=1
UID_B=2
UID_C=3
UID_BASTION=bastion
UID_MQIPT=mqipt
UID_GW=gw
UID_ATT=att
UID_PEER=peer
UID_IGW=igw
UID_NATGW=natgw
UID_KEY=key
UID_ROUTE=rt
UID_SECURITY_GROUP=sg


### PROJECT LEVEL VARIABLESS

## WORKING Directory for files on remote machines 
INSTALL_DIR=/home/centos/work

## TEMP FILE for storing instance ids for AWS CLI
INSTANCE_FILE=$(PRJ_ID).ini

## BASE NAMES
A_NAME=$(PRJ_ID)-$(UID_REGION_A)
B_NAME=$(PRJ_ID)-$(UID_REGION_B)

## SSH KEY NAME
KEY_NAME=$(PRJ_ID)-$(UID_KEY)

## VPC NAMES
VPC_A_NAME=$(A_NAME)
VPC_B_NAME=$(B_NAME)

## SUBNET NAMES
SUBNET_A_A_NAME=$(A_NAME)-$(UID_A)
SUBNET_A_B_NAME=$(A_NAME)-$(UID_B)
SUBNET_A_C_NAME=$(A_NAME)-$(UID_C)
SUBNET_A_D_NAME=$(A_NAME)-$(UID_BASTION)
SUBNET_A_E_NAME=$(A_NAME)-$(UID_MQIPT)

SUBNET_B_A_NAME=$(B_NAME)-$(UID_A)
SUBNET_B_B_NAME=$(B_NAME)-$(UID_B)
SUBNET_B_C_NAME=$(B_NAME)-$(UID_C)
SUBNET_B_D_NAME=$(B_NAME)-$(UID_BASTION)
SUBNET_B_E_NAME=$(B_NAME)-$(UID_MQIPT)

## TRANSIT GATEWAY NAMES
GATEWAY_A_NAME=$(A_NAME)-$(UID_GW)
GATEWAY_B_NAME=$(B_NAME)-$(UID_GW)

## TRANSIT GATEWAY ATTACHMENT NAMES
ATTACHMENT_A_NAME=$(A_NAME)-$(UID_ATT)
ATTACHMENT_B_NAME=$(B_NAME)-$(UID_ATT)

## TRANSIT GATEWAY PEERING NAME
PEERING_NAME=$(A_NAME)-$(B_NAME)-$(UID_PEER)

## INTERNET GATEWAY NAMES
IGW_A_NAME=$(A_NAME)-$(UID_IGW)
IGW_B_NAME=$(B_NAME)-$(UID_IGW)

## NAT GATEWAY EIP NAMES
NAT_GW_A_PUBLIC_IP_NAME=$(A_NAME)-$(UID_NATGW)
NAT_GW_B_PUBLIC_IP_NAME=$(B_NAME)-$(UID_NATGW)

## NAT GATEWAY NAMES
NAT_GW_A_NAME=$(A_NAME)-$(UID_NATGW)
NAT_GW_B_NAME=$(B_NAME)-$(UID_NATGW)

SECURITY_GROUP_A_NAME=$(A_NAME)-$(UID_SECURITY_GROUP)
SECURITY_GROUP_B_NAME=$(B_NAME)-$(UID_SECURITY_GROUP)
BASTION_A_PUBLIC_IP_NAME=$(A_NAME)-$(UID_BASTION)
BASTION_B_PUBLIC_IP_NAME=$(B_NAME)-$(UID_BASTION)
ROUTE_TABLE_A_NAME=$(A_NAME)-$(UID_ROUTE)
ROUTE_TABLE_B_NAME=$(B_NAME)-$(UID_ROUTE)
# ******************************

# AWS REGIONS
REGION_A=us-east-1
REGION_B=us-west-2
ZONE_A_A=$(REGION_A)a
ZONE_A_B=$(REGION_A)b
ZONE_A_C=$(REGION_A)c
ZONE_B_A=$(REGION_B)a
ZONE_B_B=$(REGION_B)b
ZONE_B_C=$(REGION_B)c
ZONES_A=$(REGION_A)a $(REGION_A)b $(REGION_A)c
ZONES_B=$(REGION_B)a $(REGION_B)b $(REGION_B)c



# VPC A (O=OCTET)
A_O1=10
A_O2=194
# SUBNET 
A_O3_1=0
A_O3_2=64
A_O3_3=128
A_O3_4=1
A_O3_5=2

VPC_A_CIDR=$(A_O1).$(A_O2).0.0/16
VPC_A_SUBNET_A=$(A_O1).$(A_O2).$(A_O3_1).0/24
VPC_A_SUBNET_B=$(A_O1).$(A_O2).$(A_O3_2).0/24
VPC_A_SUBNET_C=$(A_O1).$(A_O2).$(A_O3_3).0/24
VPC_A_SUBNET_D=$(A_O1).$(A_O2).$(A_O3_4).0/24
VPC_A_SUBNET_E=$(A_O1).$(A_O2).$(A_O3_5).0/24

# VPC B
B_O1=10
B_O2=195
# SUBNET 
B_O3_1=0
B_O3_2=64
B_O3_3=128
B_O3_4=1
B_O3_5=2
VPC_B_CIDR=$(B_O1).$(B_O2).0.0/16
VPC_B_SUBNET_A=$(B_O1).$(B_O2).$(B_O3_1).0/24
VPC_B_SUBNET_B=$(B_O1).$(B_O2).$(B_O3_2).0/24
VPC_B_SUBNET_C=$(B_O1).$(B_O2).$(B_O3_3).0/24
VPC_B_SUBNET_D=$(B_O1).$(B_O2).$(B_O3_4).0/24
VPC_B_SUBNET_E=$(B_O1).$(B_O2).$(B_O3_5).0/24




# COMPUTE
# BASTION
BASTION_AMI=ami-0ee70e88eed976a1b
BASTION_TYPE=t3.nano	
BASTION_DISK_TYPE=GP2

# REGION A
MQ_A_AMI=ami-0ee70e88eed976a1b

MQ_A_TYPE=t3.xlarge
MQ_A_DISK_TYPE=GP2

# REGION B
MQ_B_AMI=ami-056c679fab9e48d8a
MQ_B_TYPE=t3.xlarge
MQ_B_DISK_TYPE=GP2

MQIPT_A_ZONE=$(REGION_A)b
MQIPT_B_ZONE=$(REGION_B)b

MQIPT_A_IP=$(A_O1).$(A_O2).$(A_O3_5).4
MQIPT_B_IP=$(B_O1).$(B_O2).$(B_O3_5).4
BASTION_A_IP=$(A_O1).$(A_O2).$(A_O3_4).4
BASTION_B_IP=$(B_O1).$(B_O2).$(B_O3_4).4
MQ_A_A_IP=$(A_O1).$(A_O2).$(A_O3_1).4
MQ_A_B_IP=$(A_O1).$(A_O2).$(A_O3_2).4
MQ_A_C_IP=$(A_O1).$(A_O2).$(A_O3_3).4
MQ_B_A_IP=$(B_O1).$(B_O2).$(B_O3_1).4
MQ_B_B_IP=$(B_O1).$(B_O2).$(B_O3_2).4
MQ_B_C_IP=$(B_O1).$(B_O2).$(B_O3_3).4

## Local work data
DATA_DIR=data/$(PRJ_ID)
PEM_FILE=$(DATA_DIR)/ssh/id.rsa
MQM_PEM_FILE=$(DATA_DIR)/ssh/mqm.id_rsa

# SSHINFO FOR BASTION
BASTION_USER=centos



# SSH
BASTION_A_SSH=$(BASTION_USER)@$(BASTION_A_PUBLIC_IP)
BASTION_B_SSH=$(BASTION_USER)@$(BASTION_B_PUBLIC_IP)
MQ_A_A_SSH=$(BASTION_USER)@$(MQ_A_A_IP)
MQ_A_B_SSH=$(BASTION_USER)@$(MQ_A_B_IP)
MQ_A_C_SSH=$(BASTION_USER)@$(MQ_A_C_IP)

MQ_B_A_SSH=$(BASTION_USER)@$(MQ_B_A_IP)
MQ_B_B_SSH=$(BASTION_USER)@$(MQ_B_B_IP)
MQ_B_C_SSH=$(BASTION_USER)@$(MQ_B_C_IP)
MQIPT_A_SSH=$(BASTION_USER)@$(MQIPT_A_IP)
MQIPT_B_SSH=$(BASTION_USER)@$(MQIPT_B_IP)



### OS LEVEL DATA

## HOSTNAMES
MQ_NAME_A_A=$(UID_REGION_A)-$(UID_A)-$(UID_MQ)
MQ_NAME_A_B=$(UID_REGION_A)-$(UID_B)-$(UID_MQ)
MQ_NAME_A_C=$(UID_REGION_A)-$(UID_C)-$(UID_MQ)
MQ_NAME_B_A=$(UID_REGION_B)-$(UID_A)-$(UID_MQ)
MQ_NAME_B_B=$(UID_REGION_B)-$(UID_B)-$(UID_MQ)
MQ_NAME_B_C=$(UID_REGION_B)-$(UID_C)-$(UID_MQ)
BASTION_A_NAME=$(UID_REGION_A)-$(UID_BASTION)
BASTION_B_NAME=$(UID_REGION_B)-$(UID_BASTION)
MQIPT_A_NAME=$(UID_REGION_A)-$(UID_MQIPT)
MQIPT_B_NAME=$(UID_REGION_B)-$(UID_MQIPT)


