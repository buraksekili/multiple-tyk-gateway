helm uninstall -n tyk-operator-system tyk-operator
helm uninstall -n tyk redis tyk-headless
kubectl delete ns tyk tyk-operator-system cert-manager