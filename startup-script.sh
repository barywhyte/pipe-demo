#!/bin/bash

## Installing kubectl binaries (since we are using latest k8s GKE, use stable.txt from googleapis)
curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
chmod +x ./kubectl
mv ./kubectl /usr/local/sbin/

## SETUP HELM 
sudo apt-get update -y
sudo apt install apt-transport-https -y
sudo snap install helm --classic
sudo apt-get update -y

## Starting kube init steps
## Terraform Init Scripts ##

## Run gloud get-credentials (which gets the k8s certs to local node)
## Above command requires cluster_name & cluster_region so that kubectl command setup works with cluster that was setup (Hence run Export command)
echo "Kubectl being initialised" 
export cluster_name=$(gcloud container clusters list | grep -v NAME | awk 'NR==2{print $1}')
export cluster_zone=$(gcloud container clusters list | grep -v NAME | awk 'NR==2{print $2}')
gcloud container clusters get-credentials $cluster_name --region $cluster_zone 

## Adding Master Authorised Netowrk CIDR (of local jump-host)
export localIP=$(gcloud compute instances describe bastion-host --zone $cluster_zone --format='get(networkInterfaces[0].networkIP)')
gcloud container clusters update $cluster_name --region $cluster_zone --enable-master-authorized-networks --master-authorized-networks $localIP/32 

sudo chown -R ubuntu:ubuntu $HOME/.kube/
sudo chown -R ubuntu:ubuntu $HOME/.config/

#cd /tmp/sampleapp/ 
#helm install app /tmp/sampleapp/ -f values.yaml

    
