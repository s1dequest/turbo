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
