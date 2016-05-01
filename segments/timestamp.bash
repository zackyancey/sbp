#! /usr/bin/env bash

timestamp_value=$(date +"$settings_timestamp_format")
"${sbp_path}/helpers/segments.bash" 'segment' "$settings_timestamp_color_fg" "$settings_timestamp_color_bg" " ${timestamp_value} "
