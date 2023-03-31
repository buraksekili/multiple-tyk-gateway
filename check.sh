POD1=$(kubectl get po -n tyk -l release=tyk-headless -o jsonpath="{.items[0].metadata.name}") 
echo "FIRST POD"
kubectl exec -n tyk $POD1 -c gateway-tyk-headless  -- sh -c "ls /mnt/tyk-gateway/apps"

POD2=$(kubectl get po -n tyk -l release=tyk-headless -o jsonpath="{.items[1].metadata.name}") 
echo "\nSECOND POD"
kubectl exec -n tyk $POD2 -c gateway-tyk-headless  -- sh -c "ls /mnt/tyk-gateway/apps"

echo "\nK8s Node (Persistent Storage)"
docker exec kind-worker ls -l /mnt