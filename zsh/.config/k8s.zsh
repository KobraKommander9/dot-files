#!/bin/bash

# linkerd
export PATH=$PATH:$HOME/.linkerd2/bin/

# Kubernetes environment switching
export KUBE_PATH="${HOME}/.kube"
function switch_context() {
    export KUBE=$1
    export CLOUDSDK_CONTAINER_CLUSTER=$2
    export CLOUDSDK_ACTIVE_CONFIG_NAME=$3
    export KUBECONFIG="${KUBE_PATH}/${KUBE}.conf"
    echo $KUBECONFIG
    [[ -n ${3} ]] && gcloud config configurations activate $3
}

alias dev='switch_context dev dev-1 dev'
alias staging='switch_context staging staging-1 staging'
alias bom='switch_context bom bom-1 bom'
alias cbf='switch_context cbf cbf-1 cbf'
alias chs='switch_context chs chs-1 chs'
alias fra='switch_context fra fra-1 fra'
alias lon='switch_context lon lon-1 lon'
alias syd='switch_context syd syd-1 syd'
alias yul='switch_context yul yul-1 yul'

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

# Exec into the devclone pod
mountdc() {
  NAME="dev-$(whoami | tr '.' '-')"
  POD=$(kubectl -n default get pods | grep -E $NAME | sed 1q | awk '{print $1;}')
  if [[ ! $POD ]]; then
    echo -e "\e[1m\e[31mNo devclone pod found for $(whoami | tr '.' '-'), exiting\e[0m"
  else
    CONTAINER="${POD:${#NAME}+1:-17}"
    kubectl exec -n default $POD -c $CONTAINER -it -- zsh
  fi
}

# Exec into omni db
pgomni() {
  kpg $DEV_OMNI_DB_POD $DEV_OMNI_DB_NAME $DEV_OMNI_DB_USER
}

pgskunk() {
  kpg $DEV_SKUNK_DB_POD $DEV_SKUNK_DB_NAME $DEV_SKUNK_DB_USER
}

# Exec into pod and run psql
kpg() {
  kubectl exec $1 -it -- psql -h $2 -U $3
}
