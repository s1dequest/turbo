#!/bin/bash

read -p 'Name your namespace: ' ns
echo "Creating namespace ${ns}..."
kubectl create namespace ${ns}

read -p 'Would you like to add annotation? (y/n): ' add
while [[ $add == "y" ]];
  do
    read -p 'Annotation Key: ' key
    read -p 'Annotation Value: ' val
    kubectl annotate namespace ${ns} ${key}=${val}
    read -p 'Would you like to add another annotation? (y/n): ' add
done
