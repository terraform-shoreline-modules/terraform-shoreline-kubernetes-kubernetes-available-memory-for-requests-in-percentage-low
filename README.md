
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Kubernetes - Available Memory for Requests in percentage Low
---

This incident type pertains to a situation where the available memory for requests in percentage is low in a Kubernetes cluster. It means that the resource limit for a container has been exceeded, and this can result in performance issues and potentially cause the application to crash. This incident requires immediate attention and resolution to ensure the stability and availability of the affected system.

### Parameters
```shell
# Environment Variables

export POD_NAME="PLACEHOLDER"

export CONTAINER_NAME="PLACEHOLDER"

export NAMESPACE="PLACEHOLDER"

export DEPLOYMENT="PLACEHOLDER"

```

## Debug

### Check if any nodes are in NotReady state
```shell
kubectl get nodes -o wide | grep -v Ready
```

### Check if any pods are in the Pending state
```shell
kubectl get pods --all-namespaces | grep Pending
```

### Check the memory usage of all pods in the default namespace
```shell
kubectl top pods
```

### Check the memory usage of a specific pod in the default namespace
```shell
kubectl top pod ${POD_NAME}
```

### Check the memory usage of all containers in a specific pod in the default namespace
```shell
kubectl top pod ${POD_NAME} --containers
```

### Check the resource requests and limits for all pods in the default namespace
```shell
kubectl describe pods | grep -A 5 "Limits"
```

### Check the resource requests and limits for a specific pod in the default namespace
```shell
kubectl describe pod ${POD_NAME} | grep -A 5 "Limits"
```

### Check the current memory usage and available memory for each node in the cluster
```shell
kubectl describe nodes | grep -A 5 "Allocatable\|Capacity"
```

## Repair

### Optimize memory usage of applications running on the cluster by tuning their memory requests and limits.
```shell
bash

#!/bin/bash



# Define the namespace and deployment name

NAMESPACE=${NAMESPACE}

DEPLOYMENT=${DEPLOYMENT}



# Get the current memory requests and limits for the deployment

MEMORY_REQUEST=$(kubectl get deploy -n $NAMESPACE $DEPLOYMENT -o jsonpath='{.spec.template.spec.containers[0].resources.requests.memory}')

MEMORY_LIMIT=$(kubectl get deploy -n $NAMESPACE $DEPLOYMENT -o jsonpath='{.spec.template.spec.containers[0].resources.limits.memory}')



# Calculate the recommended memory requests and limits based on usage statistics

MEMORY_USAGE=$(kubectl top pod -n $NAMESPACE | grep $DEPLOYMENT | awk '{print $3}')

MEMORY_RECOMMENDED=$((MEMORY_USAGE * 2))Mi



# Update the deployment with the recommended memory requests and limits

kubectl patch deployment -n $NAMESPACE $DEPLOYMENT -p '{"spec":{"template":{"spec":{"containers":[{"name":"'$DEPLOYMENT'","resources":{"requests":{"memory":"'$MEMORY_RECOMMENDED'"},"limits":{"memory":"'$MEMORY_RECOMMENDED'"}}}]}}}}'


```

### Increase available memory on the Kubernetes cluster by adding more nodes or increasing the memory allocated to existing nodes.
```shell
#AWS

aws eks update-nodegroup-config --cluster-name <cluster-name> --nodegroup-name <nodegroup-name> --scaling-config minSize=<min-size>,maxSize=<max-size>,desiredSize=<desired-size>

#Azure

az aks nodepool scale --resource-group <resource-group-name> --cluster-name <cluster-name> --name <nodepool-name> --node-count <new-node-count>

# GCP 

gcloud container clusters resize <cluster-name>  --size=<new-node-count>  --zone=<zone> 

```