# Jenins in K8S
## Configured for K3D using the jenkinsci/blueocean image.

Run the `jenkins.sh` script (`source jenkins.sh`), and that should do everything for you. 
Take a look at this: https://github.com/KnowledgeHut-AWS/jenkins-lab-2-packer/tree/k8s for a basic example on how to create a kubernetes pipeline. Notice that this is the `k8s` branch, not `master`.


Note: the lab exercise is to get that packer repo actually working -- it's close, but not fully there yet.

Note2: Also, try to understand the jenkins.sh script, and the associated yaml files -- they're quite interesting.

Links:
Chart repo: https://github.com/helm/charts

Jenkins Chart: https://github.com/helm/charts/blob/master/stable/jenkins

Kubernetes Pipeline: https://www.jenkins.io/doc/pipeline/steps/kubernetes/

