# requires: nvm

[[ -d "$HOME/.nvm" ]] || return
export NVM_DIR="$HOME/.nvm"

_nvm_default_node="$NVM_DIR/alias/default"
if [[ -f "$_nvm_default_node" ]]; then
    _nvm_version=$(cat "$_nvm_default_node")
    while [[ -f "$NVM_DIR/alias/$_nvm_version" ]]; do
        _nvm_version=$(cat "$NVM_DIR/alias/$_nvm_version")
    done
    export PATH="$NVM_DIR/versions/node/$_nvm_version/bin:$PATH"
fi
unset _nvm_default_node _nvm_version

nvm() {
    unfunction nvm
    [[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
    nvm "$@"
}
