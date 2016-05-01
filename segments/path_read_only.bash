#! /usr/bin/env bash

if [[ ! -w "$PWD" ]] ; then
  segment_value=""
  "${sbp_path}/helpers/segments.bash" 'segment' "$settings_path_color_readonly_fg" "$settings_path_color_readonly_bg" " ${segment_value}"
fi
