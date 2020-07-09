# turbo 🏎️💨_____🚗_🚗_🚗
### Turbocharged, Hands-free, CI/CD 

#### The idea:
* Have Code you want to Deploy? Use _**turbo**_: a fully formed, automated, end-to-end app deployment system. 
  * Roadway:
    0. Deploy an empty EKS Cluster to send the code to.
    1. Code 
    2. => Container (Dockerfile)
    3. => Jenkins build and send Dockerhub 
    4. => AWS EKS
    5. => One of my domains

#### The Cluster:
* Before we deploy we need a cluster. Use a infrastructure as code and simple bash scripts to automate creation and testing functionality of an AWS EKS cluster.
* **Tech Stack**
  * AWS - CLI, EKS
  * Terraform
  * Bash

#### The Code:
* The focus should be on the Pipeline, so this will be nothing fancy. Just some simple HTML and with a mongoDB to demo persistent storage.
* **Tech Stack:**
  * HTML/CSS
  * MongoDB
  
#### Containerization:
* Since we want to automate/show intra-cluster communication between Pods, we will build two containers from our code. One for the front-end, the other for Mongo.
* So, we will have two small Dockerfiles to push to DockerHub.
* Dockerfiles will include Versioning/Tagging, and a unique SHA from the Commit ID for each build.
* **Tech Stack:**
  * GitHub
  * Docker & Dockerfiles

#### DockerHub
* There is no need for a private container registry in this case, for most people DockerHub would suffice.
* To build and validate the containers, we need some remote code build tool. Most organizations seem to use Jenkins, so we will use it too.
* Commits to `master` in the frontend and/or Mongo repo's will automatically trigger a Jenkins pipeline. Jenkins will validate/build the code, containerize them, then send the containers to DockerHub.
* **Tech Stack**
  * Jenkins

#### AWS EKS
* Our AWS EKS cluster will be watching the DockerHub registry. Basically, it will be checking continuously whether the version tag and/or commit SHA of the containers its running are = to the most recent ones in Docker Hub. If it isn't, a Rolling Update will be triggered on the cluster. The Rolling Update will be such that perceived customer downtime is 0, but the rollout itself is still fast.