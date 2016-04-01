### Defaults
_sbp_git_color_bg=${_sbp_git_color_bg:-$_sbp_color_green}
_sbp_git_color_fg=${_sbp_git_color_fg:-$_sbp_color_dgrey}
_sbp_git_max_length=${_sbp_git_max_length:-"20"}

function _sbp_generate_git_segment() {
  [[ -n "$(git rev-parse --git-dir 2> /dev/null)" ]] || return 0
  local git_head git_state
  if type __git_ps1 &>/dev/null; then
    git_ps1="$(__git_ps1 '%s')"
    git_head=$(cut -d' ' -f1 <<< "$git_ps1")
    if [[ ! "$git_head" == "$git_ps1" ]]; then
      git_state=" $(cut -d' ' -f2- <<< "$git_ps1")"
    fi
  else
    git_head=$(sed -e 's,.*/\(.*\),\1,' <(git symbolic-ref HEAD 2>/dev/null || git rev-parse --short HEAD))
    git_state=" $(git status --porcelain | sed -Ee 's/^(.M|M.|.R|R.) .*/\*/' -e 's/^(.A|A.) .*/\+/' -e 's/^(.D|D.) .*/\-/' | grep -oE '^(\*|\+|\?|\-)' | sort -u | tr -d '\n')"
  fi

  git_head_room=$(( _sbp_git_max_length - ${#git_state} - 2 ))
  git_head=${git_head:0:$git_head_room}

  _sbp_segment_new_color_fg="$_sbp_git_color_fg"
  _sbp_segment_new_color_bg="$_sbp_git_color_bg"
  _sbp_segment_new_value=" ${git_head}${git_state} "
  _sbp_segment_new_create
}
