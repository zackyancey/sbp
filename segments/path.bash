#! /usr/bin/env bash

if [[ -f "$settings_powerline_disable_file" ]]; then
  settings_char_segment=" "
  settings_char_path="/"
  settings_char_ready=">"
  settings_char_segrev=" "
else
  settings_char_segment=''
  settings_char_path=''
  settings_char_ready='➜'
  settings_char_segrev=''
fi

path_value=
wdir=${PWD/$HOME/\~}

if [[ "${#wdir}" -gt "$settings_path_max_length" ]]; then
  wdir="$(dirname "${wdir}" | sed -e "s;\(/.\)[^/]*;\1;g")/$(basename "${wdir}")"
fi

IFS=/ read -r -a wdir_array <<<"$wdir"
if [[ $settings_path_disable_sep -eq 0 && "${#wdir_array[@]}" -gt 1 ]]; then
  segment_seperator=$("${sbp_path}/helpers/segments.bash" 'segment' "$settings_path_color_sep" "$settings_path_color_bg" "$settings_char_path")
  for i in "${!wdir_array[@]}"; do
    dir=${wdir_array["$i"]}
    segment_value=$("${sbp_path}/helpers/segments.bash" 'segment' "$settings_path_color_fg" "$settings_path_color_bg" " $dir ")
    [[ "$(( i + 1 ))" -eq "${#wdir_array[@]}" ]] && unset segment_seperator
    path_value="${path_value}${segment_value}${segment_seperator}"
  done
  printf '%s' "$path_value"
else
  path_value=" $wdir"
  "${sbp_path}/helpers/segments.bash" 'segment' "$settings_path_color_fg" "$settings_path_color_bg" "${path_color}${path_value} "
fi

