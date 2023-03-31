run() {
    "$@"
    RESULT=$?
    if [ $RESULT -ne 0 ]; then
    echo "\tFailed to run the command: $@"
    exit $RESULT
    fi
}

installTykOSS() {
    echo 'Creating a namespace for Tyk OSS'
    kubectl create ns tyk

    echo '\nInstalling Redis'
    run helm install redis tyk-helm/simple-redis -n tyk
    checkResult

    run kubectl rollout status deployment/redis -n tyk

    echo '\nInstalling Tyk Gateway'
    # run helm install tyk-headless ./charts/tyk-headless -f ./tyk-headless-values.yaml -n tyk
    run helm install tyk-headless ./charts/tyk-headless -n tyk

    run kubectl rollout status deployment/gateway-tyk-headless -n tyk

    echo "\ntyk-headless installed successfully"
}

installCertManager() {
    # Create a namespace called cert-manager
    kubectl create ns cert-manager

    # Install cert-manager
    # run kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.10.0/cert-manager.yaml -n cert-manager
    run kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v1.8.0/cert-manager.yaml


    # Wait for cert-manager to be ready
    run kubectl rollout status deployment/cert-manager -n cert-manager
    run kubectl rollout status deployment/cert-manager-cainjector -n cert-manager
    run kubectl rollout status deployment/cert-manager-webhook -n cert-manager

    echo "\tcert-manager installed"
}

installTykOperator() {
    kubectl create ns tyk-operator-system

    kubectl create secret -n tyk-operator-system generic tyk-operator-conf --from-literal "TYK_AUTH=CHANGEME" --from-literal "TYK_ORG=foo" --from-literal "TYK_URL=http://gateway-svc-tyk-headless.tyk.svc.cluster.local:443" --from-literal "TYK_TLS_INSECURE_SKIP_VERIFY=true" --from-literal "TYK_MODE=ce"

    run helm install tyk-operator tyk-helm/tyk-operator -n tyk-operator-system
}

check_executable() {
    printf 'checking %s dependency ... ' "$1"
    if ! [ -x "$(command -v $1)" ];
    then
        echo "$1 does not exists" 1>&2
        exit 1 
    fi
    echo "done!"
}


main() {
    # Check dependencies used by this script
    check_executable kubectl
    check_executable helm

    run helm repo add tyk-helm https://helm.tyk.io/public/helm/charts/
    helm repo update

    # Install tyk-headless 
    installTykOSS

    # install cert-manager
    installCertManager

    # install tyk-operator
    installTykOperator
}

main
