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
  
### Setting up your Cluster with a Sample Stateful App. 
0. If you want to use your own version of the test app, or deploy another image entirely, follow these steps:
    - `docker build -t alpha:v0 --build-arg GIT_COMMIT=$(git log -1 --format=%h) .` Change alpha:v0 to whatever name you want. Make sure to do the same in the following steps.
    - `docker inspect alpha:v0 | jq '.[].ContainerConfig.Labels'`
    - `docker tag alpha:v0 s1dequest/alpha:v0-${GIT_COMMIT}`
    - `docker tag alpha:v0 s1dequest/alpha:latest` It's a best practice to tag your image twice, one that is uniquely versioned, and the other generic (latest) such that users can set their deployment to always use the latest version of the app code.
    - `docker push s1dequest/alpha:v0-${GIT_COMMIT}` For more uniqueness, this adds the git commit sha to the end of your version tag.
    - `docker push s1dequest/alpha:latest`
1. Make sure you've already run the `./install.sh` script from /infra/README.md to automatically build your EKS cluster with Terraform, add the credentials to your kubeconfig, and install an nginx ingress controller on the cluster.
    - `kubectl get pods` Should show a healthy ingress pod on your cluster.
2. Once the ingress controller is healthy apply the ingress object.
    - `kubectl apply -f alpha/ingress/frontend-ingress.yaml`  
3. The book says we should deploy our docker image at this point, but as the Dockerfile currently stands, it errors out with `Error: Redis connection to 127.0.0.1:6379 failed - connect ECONNREFUSED 127.0.0.1:6379`so we won't be doing that just yet.  
4. We can, however, deploy the `frontend-service.yaml` so that we don't have to later.  
    - `kubectl apply -f alpha/frontend/frontend-service.yaml`  
5. Create a configmap to set the 'journal entries per page'.  
    - `kubectl create configmap frontend-config --from-literal=journalEntries=10`.  
    - ConfigMaps are useful for creating geographically specific configurations (maybe showing a happy easter banner in North America but nowhere else)  
    - Alternatively, you can also create feature flags with configmaps - deploying or rolling back specific parts of your application. This would be useful for a Canary deployment, for example.  
    - Going forward, we would want to create a new 'versioned' configMap (by simply naming it `frontend-config-v1` for example) such that any change we make would require a change to our manifest, and would thus trigger a rollout and maintain the declarative nature of our application.  
6. The env var is referenced in the deployment with the `env: ...` stanza in `frontend.yaml`.  
7. Create a secret for our test application.  
    - `kubectl create secret generic redis-passwd --from-literal=passwd=${RANDOM}`  
8. The secret is bound to the deployment via the a volume stanza in `frontend.yaml`.  
9. Create a configmap of the launch script for redis.   
    - `cd alpha/redis`  
    - `kubectl create configmap redis-config --from-file=launch.sh=launch.sh`  
10. As with above, the configmap is used in the redis statefulset via the `volume` and `volumeMounts` stanzas that reference it.  
11. Apply the frontend deployment.
    - `cd ../../` (back to ~/infra/)
    - `kubectl apply -f alpha/frontend/frontend.yaml`
12. Apply the redis objects.
    - `kubectl apply -f alpha/redis/redis-headless.yaml`
    - `kubectl apply -f alpha/redis/redis-service.yaml`
    - `kubectl apply -f alpha/redis/redis-ss.yaml`
13. Apply the kubernetes objects for the static file hosting server. This is similar to the steps we performed above for creating deployment objects, services, and adding to the ingress object.  
    - `kubectl apply -f alpha/fileserver/fileserver.yaml`  
    - `kubectl apply -f alpha/fileserver/fileserver-service.yaml`   

