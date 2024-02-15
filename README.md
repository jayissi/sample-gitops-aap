# Deploy Applications with OpenShift GitOps (Argo CD)

This project assist users in deploying Ansible Automation Platform (AAP) and/or Private Automation Hub (PAH) operator(s) using Red Hat Advanced Cluster Management (RHACM) policies to Argo CD on Openshift 4.x.

<br>

**_gitops_** directory contains the Argo CD manifests to deploy AAP's Helm chart. \
**_aap-operator-policy_** directory contains the Helm chart for deploying Automation Controller and Automation Hub operator via RHACM Policy.

<br>
<br>

> [!IMPORTANT]  
> Red Hat Advanced Cluster Management operator installation and configuration is **_required_** prior to the steps below.

<br>

## Deploy Ansible Automation Platform Operator

```bash
helm template gitops | oc create -f -
```

## Undeploy Ansible Automation Platform Operator

```bash
helm template gitops | oc delete -f -
```
