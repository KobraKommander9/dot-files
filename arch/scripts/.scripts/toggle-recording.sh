#!/bin/bash

OUTPUT_DIR="$HOME/Videos"
mkdir -p "$OUTPUT_DIR"
FILENAME="$OUTPUT_DIR/recording_$(date +'%Y-%m-%d_%H-%M-%S').mp4"

STATE_DIR="/tmp/wf-recorder-toggle"
mkdir -p "$STATE_DIR"
MODULE_FILE="$STATE_DIR/modules.txt"
PID_FILE="$STATE_DIR/wf-recorder.pid"
LIS_PID_FILE="$STATE_DIR/listener.pid"

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

create_null_sink() {
  local NS_ID=$(load_module module-null-sink sink_name=recording_sink sink_properties=device.description=RecordingSink)
  echo "$NS_ID" >"$MODULE_FILE"
}

loop_all_sinks_and_mics() {
  unload_modules
  create_null_ink

  while read -r SINK; do
    local LOOP_ID=$(load_module module-loopback source="$SINK" sink=recording_sink latency_msec=1)
    echo "$LOOP_ID" >>"$MODULE_FILE"
  done < <(pactl list short sinks | awk '{print $2 ".monitor"}')

  while read -r SRC; do
    local LOOP_ID=$(load_module module-loopback source="$SRC" sink=recording_sink latency_msec=1)
    echo "$LOOP_ID" >>"$MODULE_FILE"
  done < <(pactl list short sources | awk '$2 !~ /\.monitor$/ {print $2}')
}

start_recording() {
  loop_all_sinks_and_mics

  wf-recorder -f "$FILENAME" -c libx264 -r 60 --audio=recording_sink.monitor &
  echo $! >"$PID_FILE"

  notify-send "🎥 Recording started" "File: $FILENAME"
}

get_active_mic() {
  local MIC_ID, MIC_NAME

  MIC_ID=$(pactl list short source-outputs | awk '{print $2; exit}')
  if [ -n "$MIC_ID" ]; then
    MIC_NAME=$(pactl list short sources | awk -v id="$MIC_ID" '$1==id {print $2}')
  fi

  if [ -z "$MIC_NAME" ]; then
    MIC_NAME=$(pactl get-default-source)
  fi

  echo "$MIC_NAME"
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

start_listener() {
  if [[ ! -f "$LIS_PID_FILE" ]] || ! kill -0 "$(cat "$LIS_PID_FILE")" 2>/dev/null; then
    (
      pactl subscribe | while read -r event; do
        if [[ $event == *"New"* ]] || [[ $event == *"Removed"* ]]; then
          if [[ -f "$PID_FILE" ]]; then
            loop_all_sinks_and_mics
            notify-send "🔄 Updated loopbacks for all sinks"
          fi
        fi
      done
    ) &
    echo $! >"$LIS_PID_FILE"
  fi
}

if [[ ! -f "$LIS_PID_FILE" ]] || ! kill -0 "$(cat "$LIS_PID_FILE")" 2>/dev/null; then
  start_listener
  start_recording
else
  toggle_recording
fi
