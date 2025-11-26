#!/bin/bash

echo " Installing Metrics Server..."
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

echo " Patching Metrics Server for KIND..."
kubectl patch deployment metrics-server -n kube-system \
  --type='json' \
  -p='[
        {"op": "add", "path": "/spec/template/spec/containers/0/args/-", "value": "--kubelet-insecure-tls"},
        {"op": "add", "path": "/spec/template/spec/containers/0/args/-", "value": "--kubelet-preferred-address-types=InternalIP,ExternalIP,Hostname"}
      ]'

echo " Waiting for Metrics Server to become ready..."
kubectl rollout status deployment metrics-server -n kube-system

echo " Checking Node Metrics..."
kubectl get --raw "/apis/metrics.k8s.io/v1beta1/nodes" | jq .

echo " Checking Pod Metrics..."
kubectl get --raw "/apis/metrics.k8s.io/v1beta1/pods" | jq .

echo " Checking HPA..."
kubectl get hpa

echo " Metrics Server setup complete!"
