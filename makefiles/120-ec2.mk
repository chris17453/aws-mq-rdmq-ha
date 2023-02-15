delete-subnet:
	aws ec2 delete-subnet --subnet-id "XXX"


attach-bastion-a-ip:
	aws ec2 associate-address --region $(REGION_A) --instance-id $(BASTION_A_ID) --public-ip $(BASTION_A_PUBLIC_IP)

attach-bastion-b-ip:
	aws ec2 associate-address --region $(REGION_B) --instance-id $(BASTION_B_ID) --public-ip $(BASTION_B_PUBLIC_IP)

#$(PROJECT_TAGS)
get-bastion-id:
	aws ec2 describe-instances --region $(REGION_A) --filters "Name=tag:Name,Values=$(BASTION_NAME)"  $(PROJECT_TAGS) --output text --query "Reservations[0].Instances[0].InstanceId" 
	@echo BASTION_ID=$$(cat tmp.${INSTANCE_FILE}) >> ${INSTANCE_FILE}

get-public-ip:
	aws ec2 describe-addresses --region $(REGION_A) --filters "Name=tag:Name,Values=$(BASTION_PUBLIC_IP_NAME)"   --output json --query "Addresses[0].PublicIp"

bastion-a-public-ip:
	aws ec2 allocate-address --region $(REGION_A) --query "AllocationId" --output text>tmp.$(INSTANCE_FILE)
	aws ec2 create-tags --resources $$(cat tmp.${INSTANCE_FILE})  \
		--region ${REGION_A} \
	    --tags Key=Name,Value=$(BASTION_A_PUBLIC_IP_NAME) Key=Project,Value=$(PROJECT_NAME) Key=Rev,Value=$(PROJECT_REV) \
		--output json

bastion-b-public-ip:
	aws ec2 allocate-address --region $(REGION_B) --query "AllocationId" --output text>tmp.$(INSTANCE_FILE)
	aws ec2 create-tags --resources $$(cat tmp.${INSTANCE_FILE})  \
		--region ${REGION_B} \
	    --tags Key=Name,Value=$(BASTION_B_PUBLIC_IP_NAME) Key=Project,Value=$(PROJECT_NAME) Key=Rev,Value=$(PROJECT_REV) \
		--output json

# Create the bastion server
bastion-a:
	aws ec2 run-instances \
	  --region $(REGION_A) \
	  --image-id $(COMPUTE_Z_AMI) \
	  --count 1 \
	  --instance-type $(COMPUTE_Z_TYPE) \
	  --key-name $(KEY_NAME) \
	  --private-ip-address $(BASTION_A_IP) \
	  --subnet-id $(VPC_A_SUBNET_D_ID) \
	  --block-device-mappings "[ \
	  $$($(ESCAPE_JSON) ec2-maps/bastion-instance.map) ]" \
	  --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=$(BASTION_A_NAME)},{ Key=Project,Value=$(PROJECT_NAME)},{Key=Rev,Value=$(PROJECT_REV)}]' \
	  'ResourceType=volume,Tags=[{Key=Name,Value=$(BASTION_A_NAME)},{Key=Project,Value=$(PROJECT_NAME)},{Key=Rev,Value=$(PROJECT_REV)}]' \
	  --output json

bastion-b:
	aws ec2 run-instances \
	  --region $(REGION_B) \
	  --image-id $(COMPUTE_B_AMI) \
	  --count 1 \
	  --instance-type $(COMPUTE_Z_TYPE) \
	  --key-name $(KEY_NAME) \
	  --private-ip-address $(BASTION_B_IP) \
	  --subnet-id $(VPC_B_SUBNET_D_ID) \
	  --block-device-mappings "[ \
	  $$($(ESCAPE_JSON) ec2-maps/bastion-instance.map) ]" \
	  --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=$(BASTION_B_NAME)},{ Key=Project,Value=$(PROJECT_NAME)},{Key=Rev,Value=$(PROJECT_REV)}]' \
	  'ResourceType=volume,Tags=[{Key=Name,Value=$(BASTION_B_NAME)},{Key=Project,Value=$(PROJECT_NAME)},{Key=Rev,Value=$(PROJECT_REV)}]' \
	  --output json

add-ssh-access-to-bastion-a:
	aws ec2 authorize-security-group-ingress \
	  --region $(REGION_A) \
      --group-id $(BASTION_A_SG) \
      --protocol tcp \
      --port 22 \
      --cidr 0.0.0.0/0

add-ssh-access-to-bastion-b:
	aws ec2 authorize-security-group-ingress \
	  --region $(REGION_B) \
      --group-id $(BASTION_B_SG) \
      --protocol tcp \
      --port 22 \
      --cidr 0.0.0.0/0

# Create the EC2 instance
ec2-a-a:
	aws ec2 run-instances \
	  --region $(REGION_A) \
	  --image-id $(COMPUTE_A_AMI) \
	  --count 1 \
	  --instance-type $(COMPUTE_A_TYPE) \
	  --key-name $(KEY_NAME) \
	  --private-ip-address $(COMPUTE_A_A_IP) \
	  --subnet-id $(VPC_A_SUBNET_A_ID) \
	  --block-device-mappings "[ \
	  $$($(ESCAPE_JSON) ec2-maps/mq-servers.map) ]" \
	  --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=$(COMPUTE_NAME_A_A)},{ Key=Project,Value=$(PROJECT_NAME)},{Key=Rev,Value=$(PROJECT_REV)}]' \
	   'ResourceType=volume,Tags=[{Key=Name,Value=$(COMPUTE_NAME_A_A)},{Key=Project,Value=$(PROJECT_NAME)},{Key=Rev,Value=$(PROJECT_REV)}]' \
	  --output text

ec2-a-b:
	aws ec2 run-instances \
	  --region $(REGION_A) \
	  --image-id $(COMPUTE_A_AMI) \
	  --count 1 \
	  --instance-type $(COMPUTE_A_TYPE) \
	  --key-name $(KEY_NAME) \
	  --private-ip-address $(COMPUTE_A_B_IP) \
	  --subnet-id $(VPC_A_SUBNET_B_ID) \
	  --block-device-mappings "[ \
	  $$($(ESCAPE_JSON) ec2-maps/mq-servers.map) ]" \
	  --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=$(COMPUTE_NAME_A_B)},{ Key=Project,Value=$(PROJECT_NAME)},{Key=Rev,Value=$(PROJECT_REV)}]' \
	   'ResourceType=volume,Tags=[{Key=Name,Value=$(COMPUTE_NAME_A_B)},{Key=Project,Value=$(PROJECT_NAME)},{Key=Rev,Value=$(PROJECT_REV)}]' \
	  --output text

ec2-a-c:
	aws ec2 run-instances \
	  --region $(REGION_A) \
	  --image-id $(COMPUTE_A_AMI) \
	  --count 1 \
	  --instance-type $(COMPUTE_A_TYPE) \
	  --key-name $(KEY_NAME) \
	  --private-ip-address $(COMPUTE_A_C_IP) \
	  --subnet-id $(VPC_A_SUBNET_C_ID) \
	  --block-device-mappings "[ \
	  $$($(ESCAPE_JSON) ec2-maps/mq-servers.map) ]" \
	  --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=$(COMPUTE_NAME_A_C)},{ Key=Project,Value=$(PROJECT_NAME)},{Key=Rev,Value=$(PROJECT_REV)}]' \
	   'ResourceType=volume,Tags=[{Key=Name,Value=$(COMPUTE_NAME_A_C)},{Key=Project,Value=$(PROJECT_NAME)},{Key=Rev,Value=$(PROJECT_REV)}]' \
	  --output text


# Create the EC2 instance
ec2-b-a:
	aws ec2 run-instances \
	  --region $(REGION_B) \
	  --image-id $(COMPUTE_B_AMI) \
	  --count 1 \
	  --instance-type $(COMPUTE_B_TYPE) \
	  --key-name $(KEY_NAME) \
	  --private-ip-address $(COMPUTE_B_A_IP) \
	  --subnet-id $(VPC_B_SUBNET_A_ID) \
	  --block-device-mappings "[ \
	  $$($(ESCAPE_JSON) ec2-maps/mq-servers.map) ]" \
	  --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=$(COMPUTE_NAME_B_A)},{ Key=Project,Value=$(PROJECT_NAME)},{Key=Rev,Value=$(PROJECT_REV)}]' \
	  'ResourceType=volume,Tags=[{Key=Name,Value=$(COMPUTE_NAME_B_A)},{Key=Project,Value=$(PROJECT_NAME)},{Key=Rev,Value=$(PROJECT_REV)}]' \
	  --output text



ec2-b-b:
	aws ec2 run-instances \
	  --region $(REGION_B) \
	  --image-id $(COMPUTE_B_AMI) \
	  --count 1 \
	  --instance-type $(COMPUTE_B_TYPE) \
	  --key-name $(KEY_NAME) \
	  --private-ip-address $(COMPUTE_B_B_IP) \
	  --subnet-id $(VPC_B_SUBNET_B_ID) \
	  --block-device-mappings "[ \
	  $$($(ESCAPE_JSON) ec2-maps/mq-servers.map) ]" \
	  --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=$(COMPUTE_NAME_B_B)},{ Key=Project,Value=$(PROJECT_NAME)},{Key=Rev,Value=$(PROJECT_REV)}]' \
	  'ResourceType=volume,Tags=[{Key=Name,Value=$(COMPUTE_NAME_B_B)},{Key=Project,Value=$(PROJECT_NAME)},{Key=Rev,Value=$(PROJECT_REV)}]' \
	  --output text


ec2-b-c:
	aws ec2 run-instances \
	  --region $(REGION_B) \
	  --image-id $(COMPUTE_B_AMI) \
	  --count 1 \
	  --instance-type $(COMPUTE_B_TYPE) \
	  --key-name $(KEY_NAME) \
	  --private-ip-address $(COMPUTE_B_C_IP) \
	  --subnet-id $(VPC_B_SUBNET_C_ID) \
	  --block-device-mappings "[ \
	  $$($(ESCAPE_JSON) ec2-maps/mq-servers.map) ]" \
	  --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=$(COMPUTE_NAME_B_C)},{ Key=Project,Value=$(PROJECT_NAME)},{Key=Rev,Value=$(PROJECT_REV)}]' \
	  'ResourceType=volume,Tags=[{Key=Name,Value=$(COMPUTE_NAME_B_C)},{Key=Project,Value=$(PROJECT_NAME)},{Key=Rev,Value=$(PROJECT_REV)}]' \
	  --output text


