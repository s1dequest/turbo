# Aquasec Open-Source Demo
### kube-bench
**"kube-bench is a Go application that checks whether Kubernetes is deployed securely by running the checks documented in the CIS Kubernetes Benchmark."**
* In AWS ECR, deploy your sample container to your cluster.
* Run the kube-bench job on a Pod in your Cluster: `kubectl apply -f kube-bench.yaml`
* `kubectl describe jobs kube-bench`
* `kubectl logs <pod-name>`

### trivy
**"A Simple and Comprehensive Vulnerability Scanner for Containers and other Artifacts, Suitable for CI."**
* Scan container images as a part of CI/CD by adding a scan step to the Dockerfile:
```
RUN apk add curl \
    && curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/master/contrib/install.sh | sh -s -- -b /usr/local/bin \
    && trivy filesystem --exit-code 0 --severity MEDIUM,HIGH --no-progress /
```
* In ~/infra/k8s/alpha/ `docker build -t vulnerability-test .`
* Change `exit-code 1` to demonstrate build failure.

### kube-hunter
**"kube-hunter hunts for security weaknesses in Kubernetes clusters. The tool was developed to increase awareness and visibility for security issues in Kubernetes environments."**
* Hunt for local pod & network interface vulnerabilities:
  * `kubectl create -f ./hunter-pod.yaml`, `hunter-interface.yaml`
  * Find pod name with `kubectl describe job kube-hunter-pod`, `kube-hunter-interface`
  * `kubectl logs <pod-name>`
