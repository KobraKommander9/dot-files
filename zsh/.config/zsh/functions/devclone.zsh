# requires: kubectl, tar, grep, sed

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

# Copy config copies the nvim config to the devclone.
copy_config() {
  if find ~/.config/nvim -type l -print -quit | grep --color -q .; then
    printf "Warning: this will dereference symlinks and copy the files they point to\n" >&2
  fi

  tar -chvf nvim.tar ~/.config/nvim >/dev/null

  local pod=$(kubectl get po -l tcn.com/development.owner=$(id -nu | sed 's/\./-/g') -o custom-columns=name:.metadata.name --no-headers=true)
  if [[ -z "$pod" ]]; then
    echo "Error: No development pod found." >&2
    rm nvim.tar
    return 1
  fi

  printf "Copying nvim config to %s\n" "$pod"
  kubectl cp nvim.tar "$pod":/home/vscode/.config
  kubectl exec "$pod" -- tar -xvf /home/vscode/.config/nvim.tar --strip-components=3 -C /home/vscode/.config

  rm nvim.tar
}
