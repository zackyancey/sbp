#! /usr/bin/env bash

segment_direction=$3

path_value=
wdir=${PWD/${HOME}/\~}

if [[ "${#wdir}" -gt "$settings_path_max_length" ]]; then
  wdir="$(dirname "${wdir}" | sed -e "s;\(/.\)[^/]*;\1;g")/$(basename "${wdir}")"
fi

IFS=/ read -r -a wdir_array <<<"${wdir}"
if [[ $settings_path_disable_sep -eq 0 && "${#wdir_array[@]}" -gt 1 ]]; then
  segment_seperator=$(pretty_print_segment "$settings_path_color_sep" "$settings_path_color_bg" "$settings_char_path")
  for i in "${!wdir_array[@]}"; do
    dir=${wdir_array["$i"]}
    if [[ -n ${dir} ]]; then
      segment_value=$(pretty_print_segment "$settings_path_color_fg" "$settings_path_color_bg" " $dir ")
      [[ "$(( i + 1 ))" -eq "${#wdir_array[@]}" ]] && unset segment_seperator
      path_value="${path_value}${segment_value}${segment_seperator}"
    fi
  done
else
  path_value=" $wdir"
fi

pretty_print_segment "$settings_path_color_fg" "$settings_path_color_bg" "${path_value}" "$segment_direction"

