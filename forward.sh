if [[ $# -eq 0 ]]; then
    echo "forwarding GW service 8080":
    kubectl port-forward svc/gateway-svc-tyk-headless 8080:443 -n tyk
fi


if [[ $1 -eq 1 ]]; then
    POD1=$(kubectl get po -n tyk -l release=tyk-headless -o jsonpath="{.items[0].metadata.name}") 
    echo "Forwarding Gateway Pod 1 on 8081 ($POD1)"
    kubectl port-forward pod/$POD1 8081:8080 -n tyk
elif [[ $1 -eq 2 ]]; then
    POD2=$(kubectl get po -n tyk -l release=tyk-headless -o jsonpath="{.items[1].metadata.name}") 
    echo "Forwarding Gateway Pod 2 on 8082 ($POD2)"
    kubectl port-forward pod/$POD2 8082:8080 -n tyk
fi