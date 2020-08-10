## Initial Provisioning of Infrastructure via Terraform:
### Reference: https://learn.hashicorp.com/terraform/getting-started/build
1. From /turbo/, `cd infra/tf/`
2. To initialize your terraform backend locally: `terraform init`
3. Format your terraform into a readable and consistent form: `terraform fmt`
4. Validate the your terraform before applying: `terraform validate`
5. Check the state of your state: `terraform plan`
6. Make the changes we output from above: `terraform apply`
7. To inspect your state, check the file terraform writes to: `terraform.tfstate`. This file contains the IDs and properties of the resources we've created so that it can manage or destroy those resources going forward. **STORE THIS FILE REMOTELY IN PROD**; it both ensures security and enables collaboration.
8. Inspect current state in the terminal with: `terraform show`
9. Manually manage state using: `terraform state`, ex: to list resources managed by terraform, run `terraform state list`.
10. Update your `kubeconfig` to use your new cluster by running: `aws eks --region ${REGION} update-kubeconfig --name ${CLUSTER_NAME}-${RANDOM_STRING}` 
11. You should now be using this new context for kubectl commands, use `kubectl get namespaces` to verify you are now in a barebones cluster. `kubectl get nodes -o wide` to verify your master node can see the worker pool we've created. The only namespaces you should see are default, kube-node-lease, kube-public, and kube-system. You can also check your `~/.kube/config` and verify the `current-context` field is the correct cluster.
  
## Setting up your Cluster with a Stateful App. 
### For now, we will be setting up our cluster with YAML/Helm here rather than with the Kubernetes Terraform provider.
0. In infra/k8s, follow the directions in the README to push your starter docker image to Docker Hub for testing. Do the same for the fileserver docker image.
1. Install Nginx using Bitnami's Helm chart. See `~/infra/k8s/alpha/ingress/README.md`.
  - `helm repo add bitnami https://charts.bitnami.com/bitnami`  
  - `helm install ingress-nginx-v1 bitnami/nginx`  
2. Once the ingress controller is healthy apply the ingress object.
  - `kubectl apply -f k8s/alpha/ingress/frontend-ingress.yaml`  
3. The book says we should deploy our docker image at this point, but as the Dockerfile currently stands, it errors out with:
```
Error: Redis connection to 127.0.0.1:6379 failed - connect ECONNREFUSED 127.0.0.1:6379
```
So we won't be doing that just yet.  
4. We can, however, deploy the `frontend-service.yaml` so that we don't have to later.  
  - `kubectl apply -f k8s/alpha/frontend/frontend-service.yaml`  
5. Create a configmap to set the 'journal entries per page'.  
  - `kubectl create configmap frontend-config --from-literal=journalEntries=10`.  
  - ConfigMaps are useful for creating geographically specific configurations (maybe showing a happy easter banner in North America but nowhere else)  
  - Alternatively, you can also create feature flags with configmaps - deploying or rolling back specific parts of your application. This would be useful for a Canary deployment, for example.  
  - Going forward, we would want to create a new 'versioned' configMap (by simply naming it `frontend-config-v1` for example) such that any change we make would require a change to our manifest, and would thus trigger a rollout and maintain the declarative nature of our application.  
6. The env var is referenced in the deployment with the `env: ...` stanza in `frontend.yaml`.  
7. Create a secret for our test application.  
  - `kubectl create secret generic redis-password --from-literal=passwd=${RANDOM}`  
8. The secret is bound to the deployment via the a volume stanza in `frontend.yaml`.  
9. Create a configmap of the launch script for redis.   
  - `cd k8s/alpha/redis`  
  - `kubectl create configmap redis-config --from-file=launch.sh=launch.sh`  
10. As with above, the configmap is used in the redis statefulset via the `volume` and `volumeMounts` stanzas that reference it.  
11. Apply the kubernetes objects for the static file hosting server. This is similar to the steps we performed above for creating deployment objects, services, and adding to the ingress object.  
  - `kubectl apply -f k8s/alpha/fileserver/fileserver.yaml`  
  - `kubectl apply -f k8s/alpha/fileserver/fileserver-service.yaml`   

