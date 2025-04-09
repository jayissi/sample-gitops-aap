#!/bin/bash

oc adm groups new cluster-admins admin

cat << EOF | oc apply --wait -f -
---
apiVersion: v1
kind: Namespace
metadata:
  labels:
    kubernetes.io/metadata.name: openshift-gitops-operator
  name: openshift-gitops-operator
spec:
  finalizers:
  - kubernetes
---
apiVersion: operators.coreos.com/v1
kind: OperatorGroup
metadata:
  name: openshift-gitops-operator
  namespace: openshift-gitops-operator
spec:
  upgradeStrategy: Default
---
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  name: openshift-gitops-operator
  namespace: openshift-gitops-operator
spec:
  channel: latest
  name: openshift-gitops-operator
  source: redhat-operators
  sourceNamespace: openshift-marketplace
EOF

sleep 90

oc patch argocds.argoproj.io openshift-gitops \
  -n openshift-gitops \
  --type merge \
  -p '{"spec":{"extraConfig":{"resource.customizations":"argoproj.io/Application:\n  health.lua: |\n    hs = {}\n    hs.status = \"Progressing\"\n    hs.message = \"\"\n    if obj.status ~= nil then\n      if obj.status.health ~= nil then\n        hs.status = obj.status.health.status\n        if obj.status.health.message ~= nil then\n          hs.message = obj.status.health.message\n        end\n      end\n    end\n    return hs"}}}'

#oc patch argocds.argoproj.io openshift-gitops \
#  -n openshift-gitops \
#  --type merge \
#  -p '{"spec":{"rbac":{"defaultPolicy":"","policy":"g, system:cluster-admins, role:admin\ng, cluster-admins, role:admin\ng, $OPENSHIFT_GROUP, role:admin"}}}'

sleep 30

helm template app-of-apps | oc apply -f -
