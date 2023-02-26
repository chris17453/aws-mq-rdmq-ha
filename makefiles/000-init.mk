init:
	mkdir -p $(DATA_DIR)
	mkdir -p $(DATA_DIR)/ssh


### This function will execute any function on all hosts if you prefix it with all-
exec-a: 
	-@$(MAKE) TARGET=$(MQ_A_A_SSH) HOSTNAME=$(MQ_NAME_A_A) $(FUNCTION) 
	-@$(MAKE) TARGET=$(MQ_A_B_SSH) HOSTNAME=$(MQ_NAME_A_B) $(FUNCTION) 
	-@$(MAKE) TARGET=$(MQ_A_C_SSH) HOSTNAME=$(MQ_NAME_A_C) $(FUNCTION) 

exec-b:
	-@$(MAKE) TARGET=$(MQ_B_A_SSH) HOSTNAME=$(MQ_NAME_B_A) $(FUNCTION) 
	-@$(MAKE) TARGET=$(MQ_B_B_SSH) HOSTNAME=$(MQ_NAME_B_B) $(FUNCTION) 
	-@$(MAKE) TARGET=$(MQ_B_C_SSH) HOSTNAME=$(MQ_NAME_B_C) $(FUNCTION) 

all-%: 
	@echo -e "\e[1;32m - Executing on $(MQ_NAME_A_A) $(FUNCTION) - \e[0m\n\n"
	@-$(MAKE) TARGET=$(MQ_A_A_SSH) HOSTNAME=$(MQ_NAME_A_A) $(FUNCTION) 
	@echo -e "\e[1;32m - Executing on $(MQ_NAME_A_B) $(FUNCTION) - \e[0m\n\n"
	@-$(MAKE) TARGET=$(MQ_A_B_SSH) HOSTNAME=$(MQ_NAME_A_B) $(FUNCTION) 
	@echo -e "\e[1;32m - Executing on $(MQ_NAME_A_C) $(FUNCTION) - \e[0m\n\n"
	@-$(MAKE) TARGET=$(MQ_A_C_SSH) HOSTNAME=$(MQ_NAME_A_C) $(FUNCTION) 
	@echo -e "\e[1;32m - Executing on $(MQ_NAME_B_A) $(FUNCTION) - \e[0m\n\n"
	@-$(MAKE) TARGET=$(MQ_B_A_SSH) HOSTNAME=$(MQ_NAME_B_A) $(FUNCTION) 
	@echo -e "\e[1;32m - Executing on $(MQ_NAME_B_B) $(FUNCTION) - \e[0m\n\n"
	@-$(MAKE) TARGET=$(MQ_B_B_SSH) HOSTNAME=$(MQ_NAME_B_B) $(FUNCTION) 
	@echo -e "\e[1;32m - Executing on $(MQ_NAME_B_C) $(FUNCTION) - \e[0m\n\n"
	@-$(MAKE) TARGET=$(MQ_B_C_SSH) HOSTNAME=$(MQ_NAME_B_C) $(FUNCTION) 


arns:
	aws resourcegroupstaggingapi get-resources --region $(REGION_A) --tag-filters Key=Project,Values=$(PROJECT_NAME) Key=Rev,Values=$(PROJECT_REV) --query 'ResourceTagMappingList[].ResourceARN' --output json
	aws resourcegroupstaggingapi get-resources --region $(REGION_B) --tag-filters Key=Project,Values=$(PROJECT_NAME) Key=Rev,Values=$(PROJECT_REV) --query 'ResourceTagMappingList[].ResourceARN' --output json

