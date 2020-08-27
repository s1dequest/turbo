Connect via `kubectl port-forward es-cluster-0 9200:9200 --namespace=kube-logging`
Check connection with `curl http://localhost:9200/_cluster/state?pretty`
Connect to kibana `kubectl port-forward kibana-xxx 5601:5601 --namespace=kube-logging`
Nav to `http://localhost:5601`
