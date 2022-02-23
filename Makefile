BOOTSTRAP_CLUSTER ?= "api-ocp-c1-prod-psi-redhat-com"
USER_NAME = $(shell whoami)
RANDOM_NUM = $(shell cat /dev/urandom | tr -dc 'a-z0-9' | fold -w 8 | head -n 1)
AUTOGEN_NAME = $(USER_NAME)-$(RANDOM_NUM)

RED =\e[91m#  Red color
GRN =\e[92m#  Green color
BLU =\e[96m#  Blue color
YLW =\e[93m#  Yellow color
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
	$(eval NAME ?= $(AUTOGEN_NAME))
	@echo 'Deploying regular OCP Cluster in PSI'
	@echo "The cluster name is $(NAME)"
	@echo "Cluster version is $(OCP_VER)"

.PHONY: deploy-ocp-proxy
deploy-ocp-proxy:
	NAME ?= $(AUTOGEN_NAME)
	@echo 'Deploying proxy OCP Cluster in AWS'

.PHONY: deploy-ocp-disconnected
deploy-ocp-disconnected:
	NAME ?= $(AUTOGEN_NAME)
	@echo 'Deploying disconnected OCP Cluster in AWS'

.PHONY: destroy-cluster
destroy-cluster:
	@echo 'Destroying cluster $(1)'