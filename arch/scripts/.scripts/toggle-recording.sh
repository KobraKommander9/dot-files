#!/bin/bash

OUTPUT_DIR="$HOME/Videos"
mkdir -p "$OUTPUT_DIR"

FILENAME="$OUTPUT_DIR/recording_$(date +'%Y-%m-%d_%H-%M-%S').mp4"

load_module() {
  pactl load-module "$@" || true
}

# Paths for temp storage
STATE_DIR="/tmp/wf-recorder-toggle"
mkdir -p "$STATE_DIR"

MODULE_FILE="$STATE_DIR/modules.txt"
PID_FILE="$STATE_DIR/pid.txt"

if pgrep -x "wf-recorder" >/dev/null; then
  pkill -INT -x wf-recorder

  if [ -f "$MODULE_FILE" ]; then
    while read -r mid; do
      pactl unload-module "$mid" >/dev/null 2>&1 || true
    done <"$MODULE_FILE"
    rm -f "$MODULE_FILE"
  fi

  rm -f "$PID_FILE"
  notify-send "Screen Recording" "Stopped"
else
  DEFAULT_SINK=$(pactl info | awk -F': ' '/Default Sink/ {print $2}')
  DEFAULT_SOURCE=$(pactl info | awk -F': ' '/Default Source/ {print $2}')

  # Create null sink for mixing
  NS_ID=$(load_module module-null-sink sink_name=recording_sink sink_properties=device.description=RecordingSink)
  echo "$NS_ID" >>"$MODULE_FILE"

  # Loop back system audio into it
  LB1_ID=$(load_module module-loopback source="${DEFAULT_SINK}.monitor" sink=recording_sink latency_msec=1)
  echo "$LB1_ID" >>"$MODULE_FILE"

  # Loop back microphone into it
  LB2_ID=$(load_module module-loopback source="$DEFAULT_SOURCE" sink=recording_sink latency_msec=1)
  echo "$LB2_ID" >>"$MODULE_FILE"

  # Record from the mixed sink
  wf-recorder -f "$FILENAME" -c libx264 -r 60 --audio=recording_sink.monitor &
  echo $! >"$PID_FILE"

  notify-send "Screen Recording" "Started: $FILENAME"
fi
