function _sbp_print_usage() {
  echo "Usage: sbp <command>"
  echo ""
  echo "Commands:"
  echo "segments - List all available segments"
  echo "hooks    - List all available hooks"
  echo "colors   - List all defined colors"
  echo "reload   - Reload SBP and user settings"
  return 1
}

function _sbp_list_segments() {
  for segment in "$sbp_path"/segments/*.bash; do
    script="${segment##*/}"
    echo "${script/.bash}"
  done
}

function _sbp_list_hooks() {
  for hook in "$sbp_path"/hooks/*.bash; do
    script="${hook##*/}"
    echo "${script/.bash/}"
  done
}

function _sbp_list_colors() {
  for color_name in $(grep -Eo '_sbp_color_[a-z]+' "${sbp_path}"/helpers/colors.bash); do
    color_number="${!color_name}"
    color_escapes=$(print_color_escapes "$color_number")
    echo -e "${color_escapes}${color_name}${_sbp_color_reset}"
  done
}

function reload_settings() {
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
    *)
      _sbp_print_usage
      ;;
  esac
}

function _sbp() {
  local cur words
  _get_comp_words_by_ref cur
  words=('segments' 'hooks' 'colors' 'reload' 'help')
  COMPREPLY=( $( compgen -W "${words[*]}" -- "$cur") )
}

complete -F _sbp sbp
