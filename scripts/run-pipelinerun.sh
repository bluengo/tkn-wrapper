#!/usr/bin/env bash
# tkn pipeline start flexy-uninstall -n devtools-gitops -p CLUSTER_NAME=gitops-4912a -w name=flexy-secrets,secret=flexy -w name=install-dir,claimName=install-dir --showlog

# Variables
BOOTSTRAP_CLUSTER=${BOOTSTRAP_CLUSTER:-"api-ocp-c1-prod-psi-redhat-com"}

# Import some functions
source "$(dirname -- ${BASH_SOURCE[0]})/../lib/bash_functions.sh"

# Check dependencies
check_dependencies "oc tkn"

log_info "Running PipelineRun"
log_info "Bootstrap OCP Cluster is: ${BOOTSTRAP_CLUSTER}"

# Check oc/kubectl current context
CURRENT_SERVER=$(oc config get-contexts | awk '/^\*/ {print $3}')
if [[ "${CURRENT_SERVER}" != "${BOOTSTRAP_CLUSTER}:6443" ]]; then
    exit_on_err 2 "Current context is not pointing the QE bootstrap cluster"
fi
log_ok "Correct cluster selected: ${CURRENT_SERVER}"

# List current pipelineruns
log_info "Listing all current PipelineRuns"
tkn pipelineruns list | head -30
echo

log_ok "Finished"