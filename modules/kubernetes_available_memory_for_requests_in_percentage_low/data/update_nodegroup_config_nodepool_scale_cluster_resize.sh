#AWS

aws eks update-nodegroup-config --cluster-name <cluster-name> --nodegroup-name <nodegroup-name> --scaling-config minSize=<min-size>,maxSize=<max-size>,desiredSize=<desired-size>

#Azure

az aks nodepool scale --resource-group <resource-group-name> --cluster-name <cluster-name> --name <nodepool-name> --node-count <new-node-count>

# GCP 

gcloud container clusters resize <cluster-name>  --size=<new-node-count>  --zone=<zone>