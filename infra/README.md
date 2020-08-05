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
11. You should now be using this new context for kubectl commands, use `kubectl get namespaces` to verify you are now in a barebones cluster. The only namespaces you should see are default, kube-node-lease, kube-public, and kube-system. You can also check your `~/.kube/config` and verify the `current-context` field is the correct cluster.
  
## Setting up your Cluster 
### For now, we will be setting up our cluster with YAML/Helm here rather than with the Kubernetes Terraform provider.
0. In infra/k8s, follow the directions in the README to push your starter docker image to Docker Hub for testing.
1. Install Nginx using Bitnami's Helm chart. See `~/infra/k8s/alpha/ingress/README.md`.
```
  a. helm repo add bitnami https://charts.bitnami.com/bitnami
  b. helm install ingress-nginx-v1 bitnami/nginx
```
2. Once the ingress controller is healthy, apply the ingress object with `kubectl apply -f k8s/alpha/ingress/frontend-ingress.yaml`
3. The book says we should deploy our docker image at this point, but as the Dockerfile currently stands, it errors out with:
```
Error: Redis connection to 127.0.0.1:6379 failed - connect ECONNREFUSED 127.0.0.1:6379
```
So we won't be doing that just yet. 
4. We can, however, deploy the `frontend-service.yaml` so that we don't have to later. Do that with `kubectl apply -f k8s/alpha/frontend/frontend-service.yaml`.
5. Create a configmap to set the 'journal entries per page' using `kubectl create configmap frontend-config --from-literal=journalEntries=10`.
  - ConfigMaps are useful for creating geographically specific configurations (maybe showing a happy easter banner in North America but nowhere else)
  - Alternatively, you can also create feature flags with configmaps - deploying or rolling back specific parts of your application. This would be useful for a Canary deployment, for example.
  - Going forward, we would want to create a new 'versioned' configMap (by simply naming it `frontend-config-v1` for example) such that any change we make would require a change to our manifest, and would thus trigger a rollout and maintain the declarative nature of our application.
6. Add an env var stanza to `frontend.yaml` to reference this config.
7. Create a secret for our test application: `kubectl create secret generic redis-password --from-literal=passwd=${RANDOM}`.
8. Bind the secret from 7 to your application by adding a volume to `frontend.yaml`.
---------------
  
Take customer inputs via questions pertaining to Architecture tradeoffs.
* What is your monthly budget?
  * Run some script to predict monthly costs based on resources we are provisioning.
  * This will determine the instance type we recommend, as well as what additional resources we can fit in the cluster.
* Is high throughput a priority?
  * This is generally something that has to be 'bought' through more expensive EC2's.
  * If the answer is no, we can save a lot of money by using smaller instances.
* Is low latency a priority?
  * If yes, geographical proximity to the end user is paramount, and thus we would want to provision a CDN like Cloudflare.

**To make deployments dynamic based on customer inputs:**
* Use a combo of jq in a shell script to grab env vars from bash, OR separate terraform files depending on certain things like if, based on the customer inputs, certain resources are included or excluded in the deployment and thus changes in the deployment are more substantial than string values that can be injected via jq.
