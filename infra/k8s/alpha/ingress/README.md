### Ingress installed with Nginx Helm Chart
`helm repo add bitnami https://charts.bitnami.com/bitnami`
```
$ helm install ingress-nginx-v1 bitnami/nginx
NAME: ingress-nginx-v1
LAST DEPLOYED: Fri Jul 31 12:11:06 2020
NAMESPACE: default
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
Get the NGINX URL:

  NOTE: It may take a few minutes for the LoadBalancer IP to be available.
        Watch the status with: 'kubectl get svc --namespace default -w ingress-nginx-v1'

  export SERVICE_IP=$(kubectl get svc --namespace default ingress-nginx-v1 --template "{{ range (index .status.loadBalancer.ingress 0) }}{{.}}{{ end }}")
  echo "NGINX URL: http://$SERVICE_IP/"
```
