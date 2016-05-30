function _sbp_print_usage() {
  cat << EOF
  Usage: sbp <command>

  Commands:
  segments  - List all available segments
  hooks     - List all available hooks
  colors    - List all defined colors
  reload    - Reload SBP and user settings
EOF
  return 1
}

function _sbp_list_segments() {
  # shellcheck source=helpers/environment.bash
  source "${sbp_path}/helpers/environment.bash"
  # shellcheck source=helpers/formatting.bash
  source "${sbp_path}/helpers/formatting.bash"

  load_config

  local command_time=900
  local exit_code=0
  for segment in "$sbp_path"/segments/*.bash; do
    segment_name="${segment##*/}"
    segment_value=$("${sbp_path}/segments/${segment_name}" "$exit_code" "$command_time")
    segment_seperator=$(pretty_print_seperator "$(get_current_bg_color "$segment_value")" "-1" "right")
    echo -e "${segment_name}: ${segment_value}${segment_seperator}${color_reset}" | sed -e 's/\\\[//g' -e 's/\\\]//g'
  done
}

function _sbp_list_hooks() {
  for hook in "$sbp_path"/hooks/*.bash; do
    script="${hook##*/}"
    echo "${script/.bash/}"
  done
}

function _sbp_list_colors() {
  # shellcheck source=helpers/color.bash
  source "${sbp_path}/helpers/color.bash"
  for color_name in $(grep -Eo 'settings_color_[a-z]+' "${sbp_path}"/helpers/config.bash | sort -u); do
    color_number="${!color_name}"
    [[ "$color_number" -ge 0 ]] && echo -e "\e[38;5;${color_number}m \$${color_name}\e[00m"
  done
}

function _sbp_reload() {
  # shellcheck source=/dev/null
  source "$sbp_path"/sbp.bash
}

function sbp() {
  case $1 in
    segments) # Show all available segments
      _sbp_list_segments
      ;;
    hooks) # Show all available hooks
      _sbp_list_hooks
      ;;
    colors) # Show all defined colors
      _sbp_list_colors
      ;;
    reload) # Reload settings and SBP
      _sbp_reload
      ;;
    powerline) # Toggle use of powerline fonts
      _sbp_toggle_powerline
      ;;
    *)
      _sbp_print_usage
      ;;
  esac
}

function _sbp() {
  local cur words
  _get_comp_words_by_ref cur
  words=('segments' 'hooks' 'colors' 'reload' 'help' 'powerline')
  COMPREPLY=( $( compgen -W "${words[*]}" -- "$cur") )
}

complete -F _sbp sbp
