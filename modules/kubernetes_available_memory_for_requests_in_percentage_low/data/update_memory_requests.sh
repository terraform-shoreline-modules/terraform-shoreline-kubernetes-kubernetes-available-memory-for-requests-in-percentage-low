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