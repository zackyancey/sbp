### Defaults
_sbp_python_virtual_env_bg=${_sbp_python_virtual_env_bg:-$_sbp_color_dgreen}
_sbp_python_virtual_env_fg=${_sbp_python_virtual_env_fg:-$_sbp_color_white}

function _sbp_generate_python_virtual_env_segment {
  local command_value
  if [[ $VIRTUAL_ENV ]]; then
    command_value="${VIRTUAL_ENV##*/}"

    _sbp_segment_new_color_bg="$_sbp_python_virtual_env_bg"
    _sbp_segment_new_color_fg="$_sbp_python_virtual_env_fg"
    _sbp_segment_new_length="$(( ${#command_value} + 2 ))"
    _sbp_segment_new_value=" ${command_value} "
    _sbp_segment_new_create
  fi
}
