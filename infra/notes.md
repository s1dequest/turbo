
To-do  
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