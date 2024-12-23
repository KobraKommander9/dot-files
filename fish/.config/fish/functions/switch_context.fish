#!/usr/bin/env fish

set -gx KUBE_PATH $HOME/.kube

function switch_context -d "switch k8s context"
    set -gx KUBE $argv[1]
    set -gx CLOUDSDK_CONTAINER_CLUSTER $argv[2]
    set -gx CLOUDSDK_ACTIVE_CONFIG_NAME $argv[3]
    set -gx KUBECONFIG $KUBE_PATH/$KUBE.conf
    linkerd_version

    if test -n $argv[3]
        gcloud config configurations activate $argv[3]
    end
end
