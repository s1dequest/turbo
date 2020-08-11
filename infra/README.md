## Initial Provisioning of Infrastructure via Terraform:
### Reference: https://learn.hashicorp.com/terraform/getting-started/build
0. Skip steps 1-11 by running `./install.sh`
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

#### Once this is complete, proceed to the readme in ~/infra/k8s.
