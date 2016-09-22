INVENTORY_LOCAL=inventories/localhost.ini
INVENTORY_SYSTEM=/etc/ansible/hosts
ANSIBLE=cd /vagrant/ansible && PYTHONUNBUFFERED=1 time -p ansible-playbook
.PHONY: help




# http://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
help:
	@echo "###########################################################"
	@echo "# Admin Host Actions                                      #"
	@echo "###########################################################"
	@echo ""
	@grep -E -h '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-40s\033[0m %s\n", $$1, $$2}'
	@echo ""
	@echo "    (use 'make <target> -n' to show the commands)"
	@echo ""




###########################################################
#  local
###########################################################

ansible-vars-remote: ## Show the ansible variables for localhost via ssh
	@$(ANSIBLE) \
		-i $(INVENTORY_LOCAL) \
		debug-vars.yml

ansible-vars-local: ## Show the ansible variables for localhost via local connection
	@$(ANSIBLE) \
		-i $(INVENTORY_SYSTEM) \
		debug-vars.yml

include makefile.d/*/*

