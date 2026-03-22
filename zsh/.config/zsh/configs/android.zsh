export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools

case "$(uname)" in
  Darwin)
    export QT_QPA_PLATFORM=cocoa
    ;;
  *)
    export QT_QPA_PLATFORM=wayland
    ;;
esac
