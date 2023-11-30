#!/bin/bash

LANG=C
SLEEP_SECONDS=30

echo ""
echo "Installing RHACM Operator."

kustomize build bootstrap/advanced-cluster-management/operator/overlays/release-2.8 | oc apply -f -

echo "Pause $SLEEP_SECONDS seconds for the creation of the rhacm-operator..."
sleep $SLEEP_SECONDS

echo "Waiting for operator to start"
until oc get deployment multiclusterhub-operator -n open-cluster-management
do
  sleep 10;
done

oc apply -k infra/clustergroup
# echo "Installing the MultiClusterHub"

# kustomize build bootstrap/advanced-cluster-management/instance/base/kustomization.yaml | oc apply -f -

# echo "Waiting for hub to be installed"

# until [[ $(oc get multiclusterhub multiclusterhub -n open-cluster-management -o jsonpath='{.status.phase}') == 'Running' ]]
# do
#   echo "Waiting for hub, current status:"
#   oc get multiclusterhub multiclusterhub -n open-cluster-management
#   sleep 10
# done

# echo "Installing policies and initial secrets"


# # ACM POLICIES

# - deploy Gitops
#      - argocd instance 1 + customization
#      - argocd instance 2 + customization
# - deploy 

# kustomize build bootstrap/secrets/base | oc apply -f -
# kustomize build bootstrap/policies/overlays/default --enable-alpha-plugins | oc apply -f -

# echo "Labeling cluster with 'gitops: local.home'"
# oc label managedcluster local-cluster gitops=local.hub --overwrite=true

# echo "Check policy compliance with the following command:"
# echo "  oc get policy -A"

# echo "Once GitOps configuration is complete you may need to run the following to fix Unknown status\n"
# echo "  oc delete secret local-cluster-import -n local-cluster\n"