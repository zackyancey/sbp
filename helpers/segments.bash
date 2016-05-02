#! /usr/bin/env bash

function generate_escaped_colors() { # prints ansi escape codes for fg and bg (optional)
  local fg_code=$1
  local bg_code=$2
  local fg_escaped="${color_reset}"
  local bg_escaped="${color_reset}"
  [[ "$fg_code" -lt 0 ]] || fg_escaped="\[\e[38;5;${fg_code}m\]"
  [[ "$bg_code" -lt 0 ]] || bg_escaped="\[\e[48;5;${bg_code}m\]"

  printf '%s' "${fg_escaped}${bg_escaped}"
}

function segment() {
  local segment_color_fg="$1"
  local segment_color_bg="$2"
  local segment_value="$3"

  printf '%s' "$(generate_escaped_colors "$segment_color_fg" "$segment_color_bg")${segment_value}"
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
