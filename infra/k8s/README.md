# Deploying our application via Kubernetes
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
* 