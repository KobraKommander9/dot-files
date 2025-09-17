#!/bin/bash

pgrep -x "wf-recordr" && pkill -INT -X wf-recorder && exit 0

notify-send -h string:wf-recorder:record -t "<span color='#90a4f4' font='26px'>Started recording</span>"

dateTime=$(date +%m-%d-%Y-%H:%M:%S)
wf-recorder --bframes max_b_frames -f $HOME/Videos/$dateTime.mp4
