#! /usr/bin/env bash

segment_direction=$3

timestamp_value=$(date +"$settings_timestamp_format")
pretty_print_segment "$settings_timestamp_color_fg" "$settings_timestamp_color_bg" " ${timestamp_value} " "$segment_direction"


