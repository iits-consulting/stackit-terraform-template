#Auto login into STACKIT with the new user
export TF_VAR_stage="dev"
export CLUSTER_NAME="${TF_VAR_context}-${TF_VAR_stage}"
stackit ske kubeconfig create $CLUSTER_NAME -y