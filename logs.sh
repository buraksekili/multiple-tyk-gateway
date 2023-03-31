POD=$(kubectl get pod -l control-plane=tyk-operator-controller-manager -n tyk-operator-system -o name) 
kubectl logs -n tyk-operator-system ${POD} -c manager -f