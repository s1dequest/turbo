#!/bin/bash

read -p 'Add a name for the client CSR (this will be added to the metadata): ' csr_name

name="${1:-my-user}"
csr="${2}"

cat <<EOF | kubectl create -f -
apiVersion: certificates.k8s.io/v1beta1
kind: CertificateSigningRequest
metadata:
  name: ${csr_name}
spec:
  groups:
  - system:authenticated
  request: $(cat ${csr} | base64 | tr -d '\n')
  usages:
  - digital signature
  - key encipherment
  - client auth
EOF

echo
echo "Approving signing request..."
kubectl certificate approve ${csr_name}

echo
echo "Downloading certificate..."
kubectl get csr ${csr_name} -o jsonpath='{.status.certificate}' \
  | base64 --decode > $(basename ${csr} .csr).crt

echo
echo "Cleaning Up"
kubectl delete csr ${csr_name}

echo "Add the following to the 'users' list in your kubeconfig:
- name: ${name}
  user:
    client-certificate: ${PWD}/$(basename ${csr} .csr).crt
    client-key: ${PWD}/$(basename ${csr} .csr)-key.pem
Next you should add a rolebinding for this user in the namespace they will be using."
