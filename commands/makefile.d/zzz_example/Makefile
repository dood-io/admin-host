INVENTORY_LOCAL=inventories/localhost.ini
INVENTORY_SYSTEM=/etc/ansible/hosts
ANSIBLE=cd /vagrant/ansible && PYTHONUNBUFFERED=1 time -p ansible-playbook
.PHONY: help-zzz




# http://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
help-zzz:
	@echo "###########################################################"
	@echo "# ZZZ Example Actions                                      #"
	@echo "###########################################################"
	@echo ""
	@grep -E -h '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-40s\033[0m %s\n", $$1, $$2}'
	@echo ""
	@echo "    (use 'make <target> -n' to show the commands)"
	@echo ""



