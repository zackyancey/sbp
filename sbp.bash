#################################
#   Simple Bash Prompt (SBP)    #
#################################

##  sbp.bash
##    -> Get shell status
##      -> Call Prompt generater <status>
##  helpers/prompt.bash
##    -> Parse config
##      -> For each config adapt to prompt
##          <- Return complete prompt
##      -> Set the prompt
##      -> Exit

_sbp_previous_history_id=
export sbp_path
#shellcheck source=helpers/settings.bash
source "${sbp_path}/helpers/settings.bash"

function _sbp_debugger_start() {
  timer_start=$(gdate +'%s%3N')
}

function _sbp_debugger_stop() {
  timer_stop=$(gdate +'%s%3N')
  timer_spent=$(( timer_stop - timer_start))
  >&2 echo "Time spent on generating prompt: $timer_spent"
}

function _sbp_set_prompt {
  local command_exit_code=$?
  [[ "$SBP_DEBUG" -eq 1 ]] && _sbp_debugger_start
  local last_history command_started command_ended command_time last_history_id
  command_ended=$(date +'%s')
  last_history=$(HISTTIMEFORMAT='%s ' history 1)
  command_started=$(awk '{print $2}' <<< "$last_history")
  command_time=$(( command_ended - command_started ))
  last_history_id=$(awk '{print $1}' <<< "$last_history")
  unset last_history

  if [[ -z "$_sbp_previous_history_id" || "$_sbp_previous_history_id" -eq "$last_history_id" ]]; then
    command_exit_code=-1
    command_time=-1
  fi

  _sbp_previous_history_id=$last_history_id

  PS1=$("${sbp_path}/helpers/prompt.bash" "$COLUMNS" "$command_exit_code" "$command_time")
  [[ "$SBP_DEBUG" -eq 1 ]] && _sbp_debugger_stop
}

[[ "$PROMPT_COMMAND" =~ _sbp_set_prompt ]] || export PROMPT_COMMAND="_sbp_set_prompt;$PROMPT_COMMAND"
