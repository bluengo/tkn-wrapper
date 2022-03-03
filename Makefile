BOOTSTRAP_CLUSTER ?= "api-ocp-c1-prod-psi-redhat-com"
USER_NAME = $(shell whoami)
RANDOM_NUM = $(shell cat /dev/urandom | tr -dc 'a-z0-9' | fold -w 8 | head -n 1)
AUTOGEN_NAME = $(USER_NAME)-$(OCP_VER)-$(RANDOM_NUM)

RED =\e[91m#  Red color
GRN =\e[92m#  Green color
BLU =\e[96m#  Blue color
YLW =\e[93m#  Yellow color
BLD =\e[1m#   Bold
RST =\e[0m#   Reset color

# Function to print help
define print_help
	@echo -e "\nTargets for this Makefile:"
	@echo -e "\tmake $(GRN)deploy-ocp-regular$(RST)        Deploy a regular OCP cluster at provided $(YLW)OCP_VER$(RST) in PSI"
	@echo -e "\tmake $(GRN)deploy-ocp-proxy$(RST)          Deploy a proxy OCP cluster at provided $(YLW)OCP_VER$(RST) in AWS"
	@echo -e "\tmake $(GRN)deploy-ocp-disconnected$(RST)   Deploy an air-gapped OCP cluster at provided $(YLW)OCP_VER$(RST) in AWS"
	@echo -e "\tmake $(RED)destroy-cluster$(RST)           Destroys existent cluster provided by $(BLU)NAME$(RST)"
	@echo -e "\nVariables:"
	@echo -e "\t$(YLW)OCP_VER$(RST)                        The OCP version of for the new cluster to be created"
	@echo -e "\t$(BLU)NAME$(RST)                           The name of the cluster that is about to be created/destroyed"
	@echo -e "\t[BOOTSTRAP_CLUSTER]            Is the OCP cluster where plumbing-gitops pipelines is installed. By default: 'api-ocp-c1-prod-psi-redhat-com'\n"
endef


.PHONY: help
help:
	$(call print_help)

.PHONY: deploy-ocp-regular
deploy-ocp-regular:
ifndef OCP_VER
	$(error ERROR: You need to provide the OCP version for the cluster)
endif
	$(eval NAME ?= $(AUTOGEN_NAME))
	@echo -e "Deploying $(BLD)regular$(RST) OCP Cluster in PSI"
	@echo -e "The cluster name is:\t$(NAME)"
	@echo -e "Cluster version is:\t$(OCP_VER)"
	@tkn pipeline start flexy-install \
		-n devtools-gitops \
		-p CLUSTER_NAME="$(NAME)" \
		-p TEMPLATE="private-templates/functionality-testing/aos-4_9/ipi-on-aws/versioned-installer" \
		-w name=flexy-secrets,secret=flexy \
		-w name=install-dir,claimName=install-dir \
		-w name=plumbing-git,claimName=plumbing-git \
		--showlog

.PHONY: deploy-ocp-proxy
deploy-ocp-proxy:
ifndef OCP_VER
	$(error ERROR: You need to provide the OCP version for the cluster)
endif
	$(eval NAME ?= $(AUTOGEN_NAME))
	@echo -e "Deploying $(BLD)proxy$(RST) OCP Cluster in AWS"
	@echo -e "The cluster name is:\t$(NAME)"
	@echo -e "Cluster version is:\t$(OCP_VER)"
#####TODO

.PHONY: deploy-ocp-disconnected
deploy-ocp-disconnected:
ifndef OCP_VER
	$(error ERROR: You need to provide the OCP version for the cluster)
endif
	$(eval NAME ?= $(AUTOGEN_NAME))
	@echo -e "Deploying $(BLD)disconnected$(RST) OCP Cluster in AWS"
	@echo -e "The cluster name is:\t$(NAME)"
	@echo -e "Cluster version is:\t$(OCP_VER)"
#####TODO

.PHONY: destroy-cluster
destroy-cluster:
ifndef NAME
	$(error ERROR: You need to provide the name of the cluster to destroy)
endif
	@echo -e "Destroying cluster:\t$(NAME)"
	@tkn pipeline start flexy-uninstall \
		-n devtools-gitops \
		-p CLUSTER_NAME="$(NAME)" \
		-w name=flexy-secrets,secret=flexy \
		-w name=install-dir,claimName=install-dir \
		--showlog