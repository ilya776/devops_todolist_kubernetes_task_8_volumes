#!/bin/bash
set -e

echo "Створення PersistentVolume..."
kubectl apply -f pv.yml

echo "Створення PersistentVolumeClaim..."
kubectl apply -f pvc.yml

echo "Створення об’єкта Deployment..."
kubectl apply -f deployment.yml

echo "Успішно розгорнуто всі ресурси."
