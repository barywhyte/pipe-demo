# PIPEDRIVE INFRA DEMO
## This entire repository demonstrate the following points:
* Ochestrate the deployment of a simple python app, packaged with helm, that expose root endpoint protected with an API key
* Deploy a private GKE cluster
* Deploy a bastion host to manage the private cluster.
* Deploy Cloud Endpoints as API Gateway Management System.

## Prerequisites 
To be able to successfully reproduce same result, the entire stack is deployed with terraform on a Linux host machine. You need the following:
* Google Cloud Project with billing enabled for it. https://console.cloud.google.com
* Log into Google Cloud Console and create a service account with editor role (This is too extreme for terraform but it make sure you don't run into permission issue with this demo. It's just for this demo). Download the service account key and save it securely
* Your local laptop (I used ubuntu 20.04) with Terraform v0.14.3. https://www.terraform.io/docs/cli/install/apt.html
* Download and install Google Cloud SDK on your local laptop. https://cloud.google.com/sdk/docs/install
* Make sure you have an existing bucket on Google Cloud to save the terraform state. This is good for team collaboration. In this demo, I created bucket and named it `pipe-terraform-state` in the `main.tf` file.

## Note
   There are only three manual steps in this demo:
   * service account creation
   * bucket creation to remotely save terraform state
   * Privately generated ssh keys for terraform to remotely run shell script and access bastion host to deploy helm appliaction

## Deployment
### Login on the google cloud
```
gcloud auth login
```
### Run that extra command if you are inside a google cloud instance
```
gcloud auth application-default login
```
### Set Google Cloud Project
```
gcloud config set project `project_id
```

* Clone this repo:
```
git clone https://github.com/barywhyte/pipe-demo.git
terraform init
terraform plan -out=demo.tfplan
terraform apply demo.tfplan
```

### Post Deployment
* SSH into the bastion host using the IP address outputed on the screen: 
  ```
  ssh ubuntu@IP
  cd /tmp/sampleapp
  helm install app . -f values.yaml
  kubectl get po
  kubectl get svc # to retrieve the loadbalancer
  ```
  
## Challenges
   I have not been able to achieve the main objectives of this demo which are:

     * expose two endpoints from a rest API
     * Track API usage statistics with API gateway system.
     
#### While the the API gateway system was successfully deployed, I ran into problem with google runtime sidecar which is mean to intercept all API requests and validate them with API key. Secondly, I didn't quite understand how best to expose those container result endpoints for external viewing via LoadBalancer as this is usually done with ```kubectl describe``` command.

The error that emanated from API gateway system has to do with inability of ESPv2 google runtime image to mount service account key into runtime's pod which is what you see when you run 
```
kubectl apply -f esp-failed.yaml
kubectl logs pod-name -c esp
  
  ```
  inside the bastion host
