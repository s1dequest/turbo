`kubectl create -f kube-logging.yaml`
Confirm with `kubectl get namespaces`
`kubectl create -f elasticsearch_svc.yaml`
Confirm with `kubectl get services --namespace=kube-logging`
Create statefulset `kubectl create -f elasticsearch_ss.yaml`
Follow rollout with `kubectl rollout status sts/es-cluster --namespace=kube-logging`
Connect via `kubectl port-forward es-cluster-0 9200:9200 --namespace=kube-logging`
Check connection with `curl http://localhost:9200/_cluster/state?pretty`
`kubectl create -f kibana.yaml`
Connect to kibana `kubectl port-forward kibana-866c457776-j98t5 5601:5601 --namespace=kube-logging`
Nav to `http://localhost:5601`
`kubectl create -f fluentd.yaml`
