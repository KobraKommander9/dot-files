case "$(uname)" in
  Darwin)
    export ANDROID_HOME=$HOME/Library/Android/sdk
    export QT_QPA_PLATFORM=cocoa
    ;;
  *)
    export ANDROID_HOME=$HOME/Android/Sdk
    export QT_QPA_PLATFORM=wayland
    ;;
esac

export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools
