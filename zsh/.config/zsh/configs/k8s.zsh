# requires: linkerd, kubectl

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

alias k=kubectl
compdef k=kubectl

alias dev='switch_context dev dev-1 dev'
alias staging='switch_context staging staging-1 staging'
alias bom='switch_context bom bom-1 bom'
alias cbf='switch_context cbf cbf-1 cbf'
alias chs='switch_context chs chs-1 chs'
alias fra='switch_context fra fra-1 fra'
alias lon='switch_context lon lon-1 lon'
alias syd='switch_context syd syd-1 syd'
alias yul='switch_context yul yul-1 yul'
