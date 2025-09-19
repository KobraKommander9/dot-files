#!/bin/bash

OUTPUT_DIR="$HOME/Videos"
mkdir -p "$OUTPUT_DIR"
FILENAME="$OUTPUT_DIR/recording_$(date +'%Y-%m-%d_%H-%M-%S').mp4"

STATE_DIR="/tmp/wf-recorder-toggle"
mkdir -p "$STATE_DIR"
LIS_PID_FILE="$STATE_DIR/listener.pid"
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

create_mic_sink() {
  if ! pactl list short sinks | grep -q '^.*\smic_sink\s'; then
    local SINK_ID=$(load_module module-null-sink sink_name=mic_sink sink_properties=device.description=MicSink)
    echo "$SINK_ID" >>"$MODULE_FILE"
  fi

  local MIC=$(pactl get-default-source)
  if ! pactl list short modules | grep -q "source=$MIC" | grep -q "sink=mic_sink"; then
    local MIC_ID=$(load_module module-loopback source="$MIC" sink=mic_sink latency_msec=1)
    echo "$MIC_ID" >>"$MODULE_FILE"
  fi
}

create_system_sink() {
  if ! pactl list short sinks | grep -q '^.*\ssystem_sink\s'; then
    local SINK_ID=$(load_module module-null-sink sink_name=system_sink sink_properties=device.description=SystemSink)
    echo "$SINK_ID" >>"$MODULE_FILE"
  fi

  pactl list short sinks | awk '{print $2 ".monitor"}' | while read -r SRC; do
    if ! pactl list short modules | grep -q "source=$SRC" | grep -q "sink=system_sink"; then
      local LOOP_ID=$(load_module module-loopback source="$SRC" sink=system_sink latency_msec=1)
      echo "$LOOP_ID" >>"$MODULE_FILE"
    fi
  done
}

start_recording() {
  unload_modules
  create_mic_sink
  create_system_sink

  local MIC_MON=$(pactl list short sources | awk '/mic_sink.monitor/ && /RUNNING/ {print $2; exit}')
  local SYS_MON=$(pactl list short sources | awk '/system_sink.monitor/ && /RUNNING/ {print $2; exit}')

  wf-recorder -f "$FILENAME" -c libx264 -r 60 \
    --audio="$MIC_MON" \
    --audio="$SYS_MON" &
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

start_listener() {
  if [[ ! -f "$LIS_PID_FILE" ]] || ! kill -0 "$(cat "$LIS_PID_FILE")" 2>/dev/null; then
    (
      pactl subscribe | while read -r event; do
        if [[ $event == *"New sink"* ]] || [[ $event == *"Removed sink"* ]]; then
          if [[ -f "$PID_FILE" ]]; then
            create_system_sink
            notify-send "🔄 Updated system audio sink loopbacks"
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
