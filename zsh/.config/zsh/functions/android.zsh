# requires: emulator

runemu() {
    if [ -z "$1" ]; then
        echo "Error: Please provide an AVD name."
        echo "----------------------------------"
        echo "Available Virtual Devices (AVDs):"
        emulator -list-avds
        return 1
    fi

    echo "Launching AVD: $1..."

    env QT_QPA_PLATFORM=xcb \
        FONTCONFIG_FILE=/dev/null \
        __NV_PRIME_RENDER_OFFLOAD=1 \
        __GLX_VENDOR_LIBRARY_NAME=nvidia \
        ANDROID_ADB_SERVER_PATH="$ANDROID_HOME/platform-tools/adb" \
        emulator -avd "$1" -gpu host
}
