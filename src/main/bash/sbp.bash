#################################
#   Simple Bash Prompt (SBP)    #
#################################

base_folder="$HOME/src/sbp/src/main/bash"
# shellcheck source=helpers/imports.bash
source "$base_folder"/helpers/imports.bash

config_file="$HOME/.sbp"
if [[ -f "$config_file" ]]; then
  # shellcheck source=/dev/null
  source "$config_file"
else
  _sbp_prompt_trigger_hooks=('timer' 'alert')
  _sbp_prompt_left_segments=('host' 'path' 'git')
  _sbp_prompt_right_segments=('command' 'timestamp')
  _sbp_prompt_ready_color="$_sbp_color_dgrey"
fi

function _sbp_generate_segments() {
  _sbp_prompt_left_length=0
  _sbp_prompt_left_value=
  _sbp_prompt_right_length=0
  _sbp_prompt_right_value=
  _sbp_prompt_current_color=
  _sbp_segment_sep_orientation=right

  for seg in "${_sbp_prompt_left_segments[@]}"; do
    "_sbp_generate_${seg}_segment"
  done

  _sbp_segment_sep_orientation=left
  left_current_color=$_sbp_prompt_current_color
  _sbp_prompt_current_color=$_sbp_filler_color_bg

  for seg in "${_sbp_prompt_right_segments[@]}"; do
    "_sbp_generate_${seg}_segment"
  done

  _sbp_prompt_current_color=$left_current_color
  _sbp_segment_sep_orientation=right
  _sbp_generate_filler_segment
}

function _sbp_perform_trigger_hooks() {
  for hook in "${_sbp_prompt_trigger_hooks[@]}"; do
    "_sbp_trigger_${hook}_hook"
  done
}

function set_prompt {
  _sbp_current_exec_result=$?
  _sbp_current_exec_value=$(HISTTIMEFORMAT='' history 1 | awk '{print $2}' | cut -c1-10 )

  _sbp_perform_trigger_hooks
  _sbp_generate_segments
  PS1="\n${_sbp_prompt_left_value}${_sbp_prompt_right_value}${_sbp_color_reset}\n$(print_color_escapes ${_sbp_prompt_ready_color}) ${_sbp_char_ready} ${_sbp_color_reset}"
}

[[ "$PROMPT_COMMAND" == *set_prompt* ]] ||  export PROMPT_COMMAND="set_prompt;$PROMPT_COMMAND"
