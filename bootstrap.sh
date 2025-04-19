#!/bin/bash
set -e

echo "Створення PersistentVolume..."
kubectl apply -f .infrastructure/pv.yaml

echo "Створення PersistentVolumeClaim..."
kubectl apply -f .infrastructure/pvc.yaml

echo "Створення об’єкта Deployment..."
kubectl apply -f .infrastructure/deployment.yaml