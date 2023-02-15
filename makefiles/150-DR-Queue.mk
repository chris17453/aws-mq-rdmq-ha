QUEUE_CMD1="sudo /opt/mqm/bin/crtmqm -sxs -rr p -rl $(COMPUTE_B_A_IP),$(COMPUTE_B_B_IP),$(COMPUTE_B_C_IP) -ri $(COMPUTE_A_A_IP),$(COMPUTE_A_B_IP),$(COMPUTE_A_C_IP) -rp 7001 -fs 3072M DRHAQM1"
QUEUE_CMD2="sudo /opt/mqm/bin/crtmqm -sx -rr p -p 1501 -rl $(COMPUTE_B_A_IP),$(COMPUTE_B_B_IP),$(COMPUTE_B_C_IP) -ri $(COMPUTE_A_A_IP),$(COMPUTE_A_B_IP),$(COMPUTE_A_C_IP) -rp 7001 -fs 3072M DRHAQM1"
QUEUE_CMD3="sudo /opt/mqm/bin/crtmqm -sxs -rr s -ri $(COMPUTE_B_A_IP),$(COMPUTE_B_B_IP),$(COMPUTE_B_C_IP) -rl $(COMPUTE_A_A_IP),$(COMPUTE_A_B_IP),$(COMPUTE_A_C_IP) -rp 7001 -fs 3072M DRHAQM1"
QUEUE_CMD4="sudo /opt/mqm/bin/crtmqm -sx -rr s -ri $(COMPUTE_B_A_IP),$(COMPUTE_B_B_IP),$(COMPUTE_B_C_IP) -rl $(COMPUTE_A_A_IP),$(COMPUTE_A_B_IP),$(COMPUTE_A_C_IP) -rp 7001 -fs 3072M DRHAQM1"

ec2-dr-queue:
	ssh -i $(PEM_FILE) $(BASTION_A_SSH) ssh $(COMPUTE_B_C_SSH) "$(QUEUE_CMD1)"
	ssh -i $(PEM_FILE) $(BASTION_A_SSH) ssh $(COMPUTE_B_B_SSH) "$(QUEUE_CMD1)"
	ssh -i $(PEM_FILE) $(BASTION_A_SSH) ssh $(COMPUTE_B_A_SSH) "$(QUEUE_CMD2)"
#
	ssh -i $(PEM_FILE) $(BASTION_A_SSH) ssh $(COMPUTE_A_C_SSH) "$(QUEUE_CMD3)"
	ssh -i $(PEM_FILE) $(BASTION_A_SSH) ssh $(COMPUTE_A_B_SSH) "$(QUEUE_CMD3)"
	ssh -i $(PEM_FILE) $(BASTION_A_SSH) ssh $(COMPUTE_A_A_SSH) "$(QUEUE_CMD4)"

ec2-check-dr-queue:
	ssh -i $(PEM_FILE) $(BASTION_A_SSH) ssh $(COMPUTE_A_A_SSH) <scripts/150-check-node.sh
	ssh -i $(PEM_FILE) $(BASTION_A_SSH) ssh $(COMPUTE_B_A_SSH) <scripts/150-check-node.sh


ec2-dr-fail-b:
	ssh -i $(PEM_FILE) $(BASTION_A_SSH) ssh $(COMPUTE_B_A_SSH) "sudo /opt/mqm/bin/rdqmdr -s -m DRHAQM1"
	ssh -i $(PEM_FILE) $(BASTION_A_SSH) ssh $(COMPUTE_A_A_SSH) "sudo /opt/mqm/bin/rdqmdr -p -m DRHAQM1"

ec2-dr-fail-a:
	ssh -i $(PEM_FILE) $(BASTION_A_SSH) ssh $(COMPUTE_B_A_SSH) "sudo /opt/mqm/bin/rdqmdr -p -m DRHAQM1"
	ssh -i $(PEM_FILE) $(BASTION_A_SSH) ssh $(COMPUTE_A_A_SSH) "sudo /opt/mqm/bin/rdqmdr -s -m DRHAQM1"
