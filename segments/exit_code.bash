#! /usr/bin/env bash

segment_direction=$3

return_code=$1
if [[ -z "$return_code" ]]; then
  return_code=0
fi

if [[ "$return_code" -ne 0 && "$return_code" -ne 130 ]]; then
  segment_value="${return_code}"
  pretty_print_segment "$settings_command_color_primary_error" "$settings_command_color_secondary_error" "${segment_value}" "$segment_direction"
fi
