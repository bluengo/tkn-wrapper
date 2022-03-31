BOOTSTRAP_CLUSTER ?= api-ocp-c1-prod-psi-redhat-com
SHELL := /bin/bash
USER_NAME = $(shell whoami)
RANDOM_NUM = $(shell cat /dev/urandom | tr -dc 'a-z0-9' | fold -w 8 | head -n 1)
AUTOGEN_NAME = $(USER_NAME)-$(RANDOM_NUM)

RED =\e[91m#  Red color
GRN =\e[92m#  Green color
BLU =\e[96m#  Blue color
YLW =\e[93m#  Yellow color
BLD =\e[1m#   Bold
RST =\e[0m#   Reset format

# Function to print help
define print_help
	@echo -e "\n$(BLD)Targets for this Makefile:$(RST)"
	@echo -e "\tmake $(GRN)deploy-ocp-regular-psi$(RST)    Deploy a regular OCP cluster at provided $(YLW)OCP_VER$(RST) in PSI"
	@echo -e "\tmake $(GRN)deploy-ocp-regular-aws$(RST)    Deploy a regular OCP cluster at provided $(YLW)OCP_VER$(RST) in AWS"
	@echo -e "\tmake $(GRN)deploy-ocp-proxy$(RST)          Deploy a proxy OCP cluster at provided $(YLW)OCP_VER$(RST) in AWS"
	@echo -e "\tmake $(GRN)deploy-ocp-disconnected$(RST)   Deploy an air-gapped OCP cluster at provided $(YLW)OCP_VER$(RST) in AWS"
	@echo -e "\tmake $(RED)destroy-cluster$(RST)           Destroys existent cluster provided by $(BLU)NAME$(RST)"
	@echo -e "\n$(BLD)Variables:$(RST)"
	@echo -e "\t$(YLW)OCP_VER$(RST)                        The OCP version of for the new cluster to be created"
	@echo -e "\t$(BLU)NAME$(RST)                           The name of the cluster that is about to be created/destroyed"
	@echo -e "\n  [Optional]:"
	@echo -e "\tBOOTSTRAP_CLUSTER              Is the OCP cluster where plumbing-gitops pipelines is installed. By default: $(BOOTSTRAP_CLUSTER)"
	@echo -e "\n$(BLD)How to use it:$(RST)"
	@echo -e "\t1) First \"oc login\" into the BOOTSTRAP_CLUSTER to have access to the pipelines"
	@echo -e "\t2) Set the needed variables in front of the make command and run your desired target. For instance:"
	@echo -e "\t\t$(YLW)OCP_VER$(RST)=\"stable-4.8\" $(BLU)NAME$(RST)=\"my-ocp-cluster\" $(BLD)make $(GRN)deploy-ocp-regular-psi$(RST)\n"
endef

# Function to check if the current context points to the BOOTSTRAP_CLUSTER
define check_bootstrap
	$(eval CURRENT_CLUSTER = $(shell kubectl config current-context | cut -d '/' -f 2 | cut -d ':' -f 1))
	$(if $(filter $(BOOTSTRAP_CLUSTER),$(CURRENT_CLUSTER)),
		@echo -e "Current bootstrap cluster is $(GRN)OK$(RST): $(CURRENT_CLUSTER)",
		$(error ERROR: Your current oc/kubectl context is not pointing to the plubing-gitops OCP cluster to run pipelines)
	)
endef

##== TARGETS ==##
.PHONY: help
help:
	$(print_help)


.PHONY: deploy-ocp-regular-psi
deploy-ocp-regular-psi:
ifndef OCP_VER
	$(error ERROR: You need to provide the OCP version for the cluster)
endif
	$(check_bootstrap)
	$(eval NAME ?= $(AUTOGEN_NAME))
	@echo -e "Deploying $(BLD)$(GRN)regular$(RST) OCP Cluster in $(BLD)PSI$(RST)"
	@echo -e "The cluster name is:\t$(BLD)$(BLU)$(NAME)$(RST)"
	@echo -e "Cluster version is:\t$(BLD)$(OCP_VER)$(RST)\n"
	tkn pipeline start flexy-install \
		-n devtools-gitops \
		-p CLUSTER_NAME="$(NAME)" \
		-p OPENSHIFT_VERSION="$(OCP_VER)" \
		-p TEMPLATE="private-templates/functionality-testing/aos-4_9/ipi-on-osp/versioned-installer" \
		-w name=flexy-secrets,secret=flexy \
		-w name=install-dir,claimName=install-dir \
		-w name=plumbing-git,claimName=plumbing-git \
		--use-param-defaults --showlog


.PHONY: deploy-ocp-regular-aws
deploy-ocp-regular-aws:
ifndef OCP_VER
	$(error ERROR: You need to provide the OCP version for the cluster)
endif
	$(check_bootstrap)
	$(eval NAME ?= $(AUTOGEN_NAME))
	@echo -e "Deploying $(BLD)$(GRN)regular$(RST) OCP Cluster in $(BLD)AWS$(RST)"
	@echo -e "The cluster name is:\t$(BLD)$(BLU)$(NAME)$(RST)"
	@echo -e "Cluster version is:\t$(BLD)$(OCP_VER)$(RST)\n"
	tkn pipeline start flexy-install \
		-n devtools-gitops \
		-p CLUSTER_NAME="$(NAME)" \
		-p OPENSHIFT_VERSION="$(OCP_VER)" \
		-p TEMPLATE="private-templates/functionality-testing/aos-4_9/ipi-on-aws/versioned-installer" \
		-w name=flexy-secrets,secret=flexy \
		-w name=install-dir,claimName=install-dir \
		-w name=plumbing-git,claimName=plumbing-git \
		--use-param-defaults --showlog


.PHONY: deploy-ocp-proxy
deploy-ocp-proxy:
ifndef OCP_VER
	$(error ERROR: You need to provide the OCP version for the cluster)
endif
	$(check_bootstrap)
	$(eval NAME ?= $(AUTOGEN_NAME))
	@echo -e "Deploying $(BLD)$(GRN)regular$(RST) OCP Cluster in $(BLD)AWS$(RST)"
	@echo -e "The cluster name is:\t$(BLD)$(BLU)$(NAME)$(RST)"
	@echo -e "Cluster version is:\t$(BLD)$(OCP_VER)$(RST)\n"
	tkn pipeline start flexy-install \
		-n devtools-gitops \
		-p CLUSTER_NAME="$(NAME)" \
		-p OPENSHIFT_VERSION="$(OCP_VER)" \
		-p TEMPLATE="private-templates/functionality-testing/aos-4_9/ipi-on-aws/versioned-installer-customer_vpc-http_proxy" \
		-w name=flexy-secrets,secret=flexy \
		-w name=install-dir,claimName=install-dir \
		-w name=plumbing-git,claimName=plumbing-git \
		--use-param-defaults --showlog


.PHONY: deploy-ocp-disconnected
deploy-ocp-disconnected:
ifndef OCP_VER
	$(error ERROR: You need to provide the OCP version for the cluster)
endif
	$(check_bootstrap)
	$(eval NAME ?= $(AUTOGEN_NAME))
	@echo -e "Deploying $(BLD)$(RED)disconnected$(RST) OCP Cluster in $(BLD)AWS$(RST)"
	@echo -e "The cluster name is:\t$(BLD)$(BLU)$(NAME)$(RST)"
	@echo -e "Cluster version is:\t$(BLD)$(OCP_VER)$(RST)\n"
	tkn pipeline start flexy-install \
		-n devtools-gitops \
		-p CLUSTER_NAME="$(NAME)" \
		-p OPENSHIFT_VERSION="$(OCP_VER)" \
		-p TEMPLATE="private-templates/functionality-testing/aos-4_9/ipi-on-aws/versioned-installer-customer_vpc-disconnected" \
		-w name=flexy-secrets,secret=flexy \
		-w name=install-dir,claimName=install-dir \
		-w name=plumbing-git,claimName=plumbing-git \
		--use-param-defaults --showlog

.PHONY: destroy-cluster
destroy-cluster:
ifndef NAME
	$(error ERROR: You need to provide the name of the cluster to destroy)
endif
	$(check_bootstrap)
	@echo -e "Destroying cluster:\t$(NAME)"
	@tkn pipeline start flexy-uninstall \
		-n devtools-gitops \
		-p CLUSTER_NAME="$(NAME)" \
		-w name=flexy-secrets,secret=flexy \
		-w name=install-dir,claimName=install-dir \
		--use-param-defaults --showlog
