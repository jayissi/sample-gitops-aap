# Deploy Applications with OpenShift GitOps (Argo CD)

*operator* directory contains a Helm chart for the application that will be
deployed. *gitops* directory contains the Argo CD manifests to deploy the Helm chart.


## Deploy

```bash
helm template gitops | oc create -f -
```

## Undeploy

```bash
helm template gitops | oc delete -f -
```
