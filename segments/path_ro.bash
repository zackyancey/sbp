#! /usr/bin/env bash

segment_direction=$3

if [[ ! -w "$PWD" ]] ; then
  segment_value=""
  pretty_print_segment "$settings_path_color_readonly_fg" "$settings_path_color_readonly_bg" " ${segment_value}" "$segment_direction"
fi
