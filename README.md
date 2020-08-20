# turbo 🏎️💨_____🚗_🚗_🚗
### Turbocharged, Hands-free, CI/CD 
**THIS IS A WORK IN PROGRESS.**  
And thus, you probably shouldn't try to use it yet. I still have a lot of things to add and figure out.
  
#### The idea:
* Want to optimize development by automatically building and destroying individual dev clusters daily? Use _**turbo**_: a fully formed, automated, end-to-end app deployment system. 
  * Basic Roadway: AWS Lambda script is runs on a cron schedule, for each of your devs, it...
    * => Hits a CI/CD tool, like Jenkins, which kicks off...
    * => Terraform scripts to deploy an empty EKS Cluster,
    * => Deployment of Kubernetes objects for securely running and exposing development environment, 
    * => A Slack message including cluster credentials, endpoints, and other relevant information.
  * Proceed to `~/infra/README.md` to get started in the nitty gritty as the project currently stands.
  
#### The Cluster:
* Before we deploy we need a cluster. Use a infrastructure as code and simple bash scripts to automate creation and testing functionality of an AWS EKS cluster.
* **Tech Stack**
  * AWS - CLI, EKS
  * Terraform
  * Bash
* Our AWS EKS cluster will be watching the DockerHub registry. Basically, it will be checking continuously whether the version tag and/or commit SHA of the containers its running are = to the most recent ones in Docker Hub. If it isn't, a Rolling Update will be triggered on the cluster. The Rolling Update will be such that perceived customer downtime is 0, but the rollout itself is still fast.

#### The Sample Code:
* The focus is be on the Pipeline, so this will be nothing fancy. It's just to demostrate how one would hook an app up to the cluster.
* **Tech Stack:**
  * HTML/CSS
  * Redis and/or MongoDB to demo statefulness.
