#!/bin/bash
sudo hostnamectl set-hostname ${nodename} &&
curl -sfL https://get.k3s.io | sh -s - server \
--write-kubeconfig-mode 644 \
--tls-san=$(curl http://169.254.169.254/latest/meta-data/public-ipv4)

#add public ip to the certificate with in our k3s installation so we can access kubernetes resources 
#on it's public ip, instead of it's internal ip - dope

NewFile=si3mshady_strayaway.yml
(
cat <<'DEPLOYMENT'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: strayaway
spec:
  replicas: 2
  selector:
    matchLabels:
      # manage pods with the label app: si3mshady/strayaway
      si3mshady: strayaway
  template:
    metadata:
      labels:
        si3mshady: strayaway
    spec:
      containers:
      - name: strayaway
        image: si3mshady/strayaway
        ports:
        - containerPort: 888
          hostPort: 5000
DEPLOYMENT
) > $NewFile

kubectl apply -f $NewFile
