#! /usr/bin/env bash

function generate_escaped_colors() { # prints ansi escape codes for fg and bg (optional)
  local fg_code fg_escaped bg_code bg_escaped
  fg_code=$1
  bg_code=$2
  [[ "$fg_code" -lt 0 ]] || fg_escaped="\[\e[38;5;${fg_code}m\]"
  [[ "$bg_code" -lt 0 ]] || bg_escaped="\[\e[48;5;${bg_code}m\]"

  if [[ -z "$bg_escaped" ]]; then
    printf '%s' "${color_reset}${fg_escaped}"
  elif [[ -z "$fg_escaped" ]]; then
    printf '%s' "${color_reset}${bg_escaped}"
  else
    printf '%s' "${fg_escaped}${bg_escaped}"
  fi
}

function segment() {
  segment_color_fg="$1"
  segment_color_bg="$2"
  segment_value="$3"

  segment_color=$(generate_escaped_colors "$segment_color_fg" "$segment_color_bg")
  printf '%s' "${segment_color}${segment_value}"
}

function seperator() {
  local from_color=$1
  local to_color=$2
  local direction=$3

  [[ -z "$from_color" ]] && return 0 # Can't make seperator without a previous segment

  if [[ "$direction" == "right" ]]; then
    segment "$from_color" "$to_color" "$settings_char_segment"
  else
    segment "$to_color" "$from_color" "$settings_char_segrev"
  fi
}

"$1" "$2" "$3" "$4"
