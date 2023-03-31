if [[ $# -eq 0 ]]; then
    POD=$(kubectl get pod -l control-plane=tyk-operator-controller-manager -n tyk-operator-system -o name) 
    kubectl logs -n tyk-operator-system ${POD} -c manager -f
fi


if [[ $1 -eq 1 ]]; then
    POD1=$(kubectl get po -n tyk -l release=tyk-headless -o jsonpath="{.items[0].metadata.name}") 
    kubectl logs -n tyk ${POD1} -f
elif [[ $1 -eq 2 ]]; then
    POD2=$(kubectl get po -n tyk -l release=tyk-headless -o jsonpath="{.items[1].metadata.name}") 
    kubectl logs -n tyk ${POD2} -f
fi
