#!/bin/bash

kubectl delete deployments fileserver

kubectl delete service redis-write
kubectl delete service redis
kubectl delete statefulsets redis

kubectl delete deployments frontend

kubectl delete configmap redis-config

kubectl delete secret redis-passwd  

kubectl delete configmap frontend-config

kubectl delete service frontend
kubectl delete ingress frontend-ingress  
























