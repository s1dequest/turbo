#!/bin/bash
echo
echo "Applying ingress object for directing traffic into our sample app..."
kubectl apply -f alpha/ingress/frontend-ingress.yaml  

echo
echo "Applying frontend service to load balance requests to the frontend deployment..."
kubectl apply -f alpha/frontend/frontend-service.yaml

echo
echo "Creating configmap for frontend..."
kubectl create configmap frontend-config --from-literal=journalEntries=10.  

echo
echo "Creating a password for redis using built-in random string generator..."
kubectl create secret generic redis-passwd --from-literal=passwd=${RANDOM}  

echo
echo "Creating configmap to help launch redis..."
cd alpha/redis  
kubectl create configmap redis-config --from-file=launch.sh=launch.sh

echo
echo "Applying frontend replicated deployment..."
cd ../../
kubectl apply -f alpha/frontend/frontend.yaml

echo
echo "Applying redis services and statefulset..."
kubectl apply -f alpha/redis/redis-headless.yaml 
kubectl apply -f alpha/redis/redis-service.yaml
kubectl apply -f alpha/redis/redis-ss.yaml

echo
echo "Applying frontend static fileserver service and deployment..."
kubectl apply -f alpha/fileserver/fileserver.yaml  
kubectl apply -f alpha/fileserver/fileserver-service.yaml   

echo "... Done! Run 'kubectl get pods' to check everything is running as expected."
echo "If there are any problems, go to 's1dequest/k8sTroubleshooting' and follow the steps there."
