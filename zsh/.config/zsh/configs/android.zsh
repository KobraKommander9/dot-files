case "$(uname)" in
    Darwin)
        export ANDROID_HOME=$HOME/Library/Android/sdk
        export QT_QPA_PLATFORM=cocoa
        ;;
    *)
        export ANDROID_HOME=$HOME/Android/Sdk
        export QT_QPA_PLATFORM="wayland;xcb"
        export _JAVA_AWT_WM_NONREPARENTING=1
        export ANDROID_EMULATOR_USE_SYSTEM_LIBS=1
        ;;
esac

export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools
