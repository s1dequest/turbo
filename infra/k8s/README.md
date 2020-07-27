# Deploying our application via Kubernetes
**The following assumes you've already set up a cluster using the steps from ~/infra/tf.**  
  
## First, Let's Build a Stateful Sample App
We will use this app as a test platform for additional services/best practices we implement around/in kubernetes, documenting as we go.

### Sample App 'Alpha'
```
      [Ingress HTTP Load Balancer]
        |                       |
[API Server Svc]      [Static File Server Svc]
      | | |
[API Pods],[],...     [Static File Pods],[],...
        |
       _|______________
      |                |
[Redis Write Svc]   [Redis Read Svc]
      |                |
      |________________|_[Redis Pods],[],...
```
* **Techstack & Basic Architecture**
  * Diagram above. `/api` on the url hits the API path, and the base url hits the static file server.
* **App Code Deployment**
  * Build/tag/push steps (to be added/automated to build pipeline)
    * `docker build -t alpha:v0 --build-arg GIT_COMMIT=$(git log -1 --format=%h) .`
    * `docker inspect alpha:v0 | jq '.[].ContainerConfig.Labels'`
    * `docker tag alpha:v0 s1dequest/alpha:v0-${GIT_COMMIT}`
    * `docker push s1dequest/alpha:v0-${GIT_COMMIT}`
