# requires: kubectl
# env: DEV_OMNI_DB_POD, DEV_OMNI_DB_NAME, DEV_OMNI_DB_USER
# env: DEV_BILLING_DB_POD, DEV_BILLING_DB_NAME, DEV_BILLING_DB_USER

# Exec into pod and run psql
kpg() {
    kubectl exec $1 -it -- psql -h $2 -U $3
}

# Port forward a pod, `pfs service` will port-forward service-xxxxxxxxxx-xxxxx at localhost:50051
pfs() {
    POD=$(kubectl -n default get pods | grep -E "^$1-\S{10}-\S{5}\s+(.*?)$" | sed 1q | awk '{print $1;}')

    if [[ $2 -eq 0 ]]; then
        echo -e "\e[33mNo port specified, defaulting to 50051...\e[0m"
        PORT="50051:50051"
    else
        PORT="$2:$2"
    fi

    echo -e "\e[36m\e[1mForwarding $POD\e[0m"
    kubectl -n default port-forward $POD $PORT
}

pgbilling() {
    kpg "$DEV_BILLING_DB_POD" "$DEV_BILLING_DB_NAME" "$DEV_BILLING_DB_USER"
}

pgomni() {
    kpg "$DEV_OMNI_DB_POD" "$DEV_OMNI_DB_NAME" "$DEV_OMNI_DB_USER"
}
