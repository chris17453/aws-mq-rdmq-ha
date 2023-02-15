info:
# Print out AWS configuration for this project to the console
	@echo "AWS Regions"
	@echo "  Region A : $(REGION_A)"
	@echo "  Region B : $(REGION_B)"

	@echo " --AWS TAGS --"
	@echo "     - VPC_A_NAME         :$(VPC_A_NAME)"
	@echo "     - VPC_B_NAME         :$(VPC_B_NAME)"
	@echo "     - SUBNET_A_A_NAME    :$(SUBNET_A_A_NAME)"
	@echo "     - SUBNET_A_B_NAME    :$(SUBNET_A_B_NAME)"
	@echo "     - SUBNET_A_C_NAME    :$(SUBNET_A_C_NAME)"
	@echo "     - SUBNET_B_A_NAME    :$(SUBNET_B_A_NAME)"
	@echo "     - SUBNET_B_B_NAME    :$(SUBNET_B_B_NAME)"
	@echo "     - SUBNET_B_C_NAME    :$(SUBNET_B_C_NAME)"
	@echo "     - GATEWAY_A_NAME     :$(GATEWAY_A_NAME)"
	@echo "     - GATEWAY_B_NAME     :$(GATEWAY_B_NAME)"
	@echo "     - ATTACHMENT_A_NAME  :$(ATTACHMENT_A_NAME)"
	@echo "     - ATTACHMENT_B_NAME  :$(ATTACHMENT_B_NAME)"
	@echo "     - PEERING_NAME       :$(PEERING_NAME)"
	@echo " ------------"
	
	@echo "VPC A"
	@echo "  Name : $(VPC_A_NAME)"
	@echo "  CIDR :$(VPC_A_CIDR)"
	@echo "  VPC A ID: $(VPC_A_ID)"
	@echo "  Subnet :"
	@echo "    - $(VPC_A_SUBNET_A)";
	@echo "    - $(VPC_A_SUBNET_B)";
	@echo "    - $(VPC_A_SUBNET_C)";



	@echo "    Subnet A ID:  $(VPC_A_SUBNET_A_ID)"
	@echo "    Subnet B ID:  $(VPC_A_SUBNET_B_ID)"
	@echo "    Subnet C ID:  $(VPC_A_SUBNET_C_ID)"
	
	#	done
	@echo "VPC B"
	@echo "  Name : $(VPC_B_NAME)"
	@echo "  CIDR :$(VPC_B_CIDR)"
	@echo "  VPC B ID: $(VPC_B_ID)"
	@echo "  Subnet :"
	@echo "    - $(VPC_B_SUBNET_A)";
	@echo "    - $(VPC_B_SUBNET_B)";
	@echo "    - $(VPC_B_SUBNET_C)";
	@echo "     Subnet A ID:  $(VPC_B_SUBNET_A_ID)"
	@echo "     Subnet B ID:  $(VPC_B_SUBNET_B_ID)"
	@echo "     Subnet C ID:  $(VPC_B_SUBNET_C_ID)"

	@echo "Bastion"
	@echo "  AMI : $(COMPUTE_Z_AMI)"
	@echo "  Type : $(COMPUTE_Z_TYPE)"
	@echo "  Zone :"
	@for  x in $(COMPUTE_Z_ZONES); do \
	      echo "    - $$x"; \
		done
	@echo "  Disks: $(COMPUTE_Z_DISKS)"
	@echo "  Disk Type: $(COMPUTE_Z_DISK_TYPE)"

	@echo "REGION A"
	@echo "  AMI : $(COMPUTE_A_AMI)"
	@echo "  Type : $(COMPUTE_A_TYPE)"
	@echo "  Zones :"
	@for  x in $(COMPUTE_A_ZONES); do \
	      echo "    - $$x"; \
		done
	@echo "  Disks: $(COMPUTE_A_DISKS)"
	@echo "  Disk Type: $(COMPUTE_A_DISK_TYPE)"

	@echo "REGION B"
	@echo "  AMI : $(COMPUTE_B_AMI)"
	@echo "  Type : $(COMPUTE_B_TYPE)"
	@echo "  Zones :"
	@for  x in $(COMPUTE_B_ZONES); do \
	      echo "    - $$x"; \
		done
	@echo "  Disks: $(COMPUTE_B_DISKS)"
	@echo "  Disk Type: $(COMPUTE_B_DISK_TYPE)"


configure_aws:
	aws configure set aws_access_key_id $(AWS_ACCESS_KEY_ID)
	aws configure set aws_secret_access_key $(AWS_SECRET_ACCESS_KEY)
	aws configure set default.region $(AWS_DEFAULT_REGION)	  


get-mq:
	@wget https://github.com/mikefarah/yq/releases/download/v4.30.8/yq_linux_amd64 -O yq
	@chmod +x yq

preqs: get-mq


get-vpc-id-a:
	@aws ec2 describe-vpcs --region $(REGION_A) --filters "Name=tag:Name,Values=$(VPC_A_NAME)" \
	  $(PROJECT_TAGS)--query 'Vpcs[0].VpcId' --output text> tmp.$(INSTANCE_FILE)
	@echo $$(cat tmp.$(INSTANCE_FILE))

get-vpc-id-b:
	@aws ec2 describe-vpcs --region $(REGION_B) --filters "Name=tag:Name,Values=$(VPC_B_NAME)" \
	  $(PROJECT_TAGS)--query 'Vpcs[0].VpcId' --output text> tmp.$(INSTANCE_FILE)
	@echo $$(cat tmp.$(INSTANCE_FILE))

get-vpc-ids: get-vpc-id-a get-vpc-id-b
	
get-transit-gateway-id:
	aws ec2 describe-transit-gateways \
	--filters "Name=state,Values=available" "Name=tag:Name,Values=TRANSIT_GATEWAY" $(PROJECT_TAGS)\
  	--output text \
	--query 'TransitGateways[0].TransitGatewayId'


delete-transit-gateway:
	aws ec2 delete-transit-gateway \
	--transit-gateway-id tgw-0d5bd912d8cd3ca56

get-pid-a:
	aws ec2 describe-transit-gateway-peering-attachments --filters "Name=state,Values=pendingAcceptance" "Name=tag:Name,Values=$(PEERING_A_NAME)" $(PROJECT_TAGS) --region $(REGION_A)  --output text --query 'TransitGatewayPeeringAttachments[0].TransitGatewayAttachmentId' 

get-pid-b:
	aws ec2 describe-transit-gateway-peering-attachments --filters "Name=state,Values=pendingAcceptance" "Name=tag:Name,Values=$(PEERING_B_NAME)" $(PROJECT_TAGS) --region $(REGION_B)  --output text --query 'TransitGatewayPeeringAttachments[0].TransitGatewayAttachmentId' 
      

get-peering-id:
	aws ec2 describe-transit-gateway-peering-attachments --region $(REGION_A) --filters "Name=state,Values=available" "Name=tag:Name,Values=$(PEERING_NAME)" $(PROJECT_TAGS) --output text --query 'TransitGatewayPeeringAttachments[0].TransitGatewayAttachmentId' 

#	aws ec2 describe-transit-gateway-route-tables --transit-gateway-route-table-ids  $(TRANSIT_GW_A_RT_ID) --query "TransitGatewayRouteTables[0].TransitGatewayRouteTableId" --output text

target-a-a:
	@echo $(COMPUTE_A_A_SSH)
target-a-b:
	@echo $(COMPUTE_A_B_SSH)
target-a-c:
	@echo $(COMPUTE_A_C_SSH)

target-b-a:
	@echo $(COMPUTE_B_A_SSH)
target-b-b:
	@echo $(COMPUTE_B_B_SSH)
target-b-c:
	@echo $(COMPUTE_B_C_SSH)
	