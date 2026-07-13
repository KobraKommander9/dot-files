# requires: qmk
# env: QMK_USERSPACE

function qmk-vial() {
    QMK_HOME="$QMK_USERSPACE/firmware/vial" qmk "$@"
}

function qmk-zsa() {
    QMK_HOME="$QMK_USERSPACE/firmware/zsa" qmk "$@"
}
