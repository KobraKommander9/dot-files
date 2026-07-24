# requires: cargo

if [[ $(uname) != "Darwin" ]]; then
    export CARGO_HOME="${CARGO_HOME:-$HOME/.cargo}"
    export PATH=$PATH:$CARGO_HOME/bin
fi
