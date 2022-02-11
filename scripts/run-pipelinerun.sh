#!/usr/bin/env bash

# Import some functions
source "$(dirname -- ${BASH_SOURCE[0]})/../lib/bash_functions.sh"

# Check dependencies
check_dependencies "oc kubectl tkn"

# tkn pipeline start flexy-uninstall -n devtools-gitops -p CLUSTER_NAME=gitops-4912a -w name=flexy-secrets,secret=flexy -w name=install-dir,claimName=install-dir --showlog
log_info "Running PipelineRun"
log_ok "Finished"