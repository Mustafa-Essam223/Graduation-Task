![main](https://github.com/Mustafa-Essam223/Infra-repo/assets/40956565/24bf6d3a-cbec-444d-b191-59669f1a6a0e)

# Final-Task 
### Jenkins & backend-application deployment on eks cluster  
### you can get my infrastructure by cloning my repositry 
```
git clone https://github.com/Mustafa-Essam223/Infra-repo
cd Infra-repo/infrastructure/
```

### Create infrastructure using terraform with its all associations and dependencies and network
```
terraform init 
terraform plan 
terraform apply 
```
## connect to the public ec2 (Jumb-Host) via console connect

### Using Jumb-Host you can access the cluster using command
```
aws eks --region us-east-1 update-kubeconfig --name eks-cluster
```
### apply k8s files inside the cluster to deploy jenkins
```
git clone https://github.com/Mustafa-Essam223/Infra-repo
kubectl apply -f k8s_file
```
### get the initialAdminPassword of jenkins from pod logs 
```
kubectl get po -n jenkins
kubectl logs -f -n jenkins <pod-name>
```
### now you can access Jenkins GUI using LoadBalancer DNS name
- sign in by the password
- create your pipeline, to access my repo and apply CD pipelines on it you can use the link [https://github.com/Mustafa-Essam223/App-repo]
### to access my web-app apply the resources listed in the repo
```
1. kubectl apply -f backend-namespace.yml
2. kubectl apply -f deployment.yaml
3. kubectl apply -f LoadBalancer.yaml
```
### you can view the app using the new LoadBalancer DNS name

