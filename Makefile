BOOTSTRAP_CLUSTER ?= "api-ocp-c1-prod-psi-redhat-com"

define print_help
	@echo -e "Targets for ${0}:"
	@echo -e "\tdeploy-cluster-regular VERSION \t\tDeploy a regular OCP cluster at provided version in PSI"
	@echo -e "\tdeploy-cluster-proxy VERSION \t\tDeploy a proxy OCP cluster at provided version in AWS"
	@echo -e "\tdeploy-cluster-proxy VERSION \t\tDeploy an air-gapped OCP cluster at provided version in AWS"
	@echo -e "\tdestroy-cluster NAME \t\t\tDestroys existent cluster provided by name"
endef

.PHONY: help
help:
	$(call print_help)

.PHONY: run-pipelinerun
run-pipelinerun:
	@echo 'Running pipelinerun'
	@./scripts/run-pipelinerun.sh
