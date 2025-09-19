#!/bin/bash

OUTPUT_DIR="$HOME/Videos"
mkdir -p "$OUTPUT_DIR"
FILENAME="$OUTPUT_DIR/recording_$(date +'%Y-%m-%d_%H-%M-%S').mp4"

STATE_DIR="/tmp/wf-recorder-toggle"
mkdir -p "$STATE_DIR"
MODULE_FILE="$STATE_DIR/modules.txt"
PID_FILE="$STATE_DIR/wf-recorder.pid"

load_module() {
  pactl load-module "$@" || true
}

unload_modules() {
  if [[ -f "$MODULE_FILE" ]]; then
    while read -r mid; do
      pactl unload-module "$mid" >/dev/null 2>&1 || true
    done <"$MODULE_FILE"
    rm -f "$MODULE_FILE"
  fi
}

cleanup_old_sink() {
  for src in $(pactl list short sources | awk '$2 ~ /record_mix/ {print $2}'); do
    local MODULE=$(pactl list short sources | awk -v s="$src" '$2==s {print $1}')
    pactl unload-module "$MODULE" 2>/dev/null || true
  done
}

create_record_mix() {
  unload_modules
  cleanup_old_sink
  >"$MODULE_FILE"

  local SINK_ID=$(load_module module-null-sink sink_name=record_mix sink_properties=device.description=RecordMix)
  echo "$SINK_ID" >>"$MODULE_FILE"

  local MIC=$(pactl get-default-source)
  local MIC_LOOP=$(load_module module-loopback source="$MIC" sink=record_mix latency_msec=1)
  echo "$MIC_LOOP" >>"$MODULE_FILE"

  for SRC in $(pactl list short sources | awk '$2 ~ /monitor/ && $2 !~ /record_mix/ {print $2}'); do
    local LOOP_ID=$(load_module module-loopback source="$SRC" sink=record_mix latency_msec=1)
    echo "$LOOP_ID" >>"$MODULE_FILE"
  done
}

start_recording() {
  create_record_mix

  wf-recorder -f "$FILENAME" -c libx264 -r 60 --audio=record_mix.monitor &
  echo $! >"$PID_FILE"

  notify-send "🎥 Recording started" "File: $FILENAME"
}

stop_recording() {
  if [[ -f $PID_FILE ]]; then
    kill -INT "$(cat "$PID_FILE")"
    rm "$PID_FILE"
  fi

  unload_modules
  notify-send "🛑 Recording stopped" "Saved to: $FILENAME"
}

toggle_recording() {
  if [[ -f "$PID_FILE" ]]; then
    stop_recording
  else
    start_recording
  fi
}

toggle_recording
