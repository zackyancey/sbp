#! /usr/bin/env bash

# shellcheck source=functions/decorate.bash
source "${sbp_path}/functions/decorate.bash"
# shellcheck source=functions/configure.bash
source "${sbp_path}/functions/configure.bash"

load_config

color_reset='\[\e[00m\]'

get_executable_script() {
  local type=$1
  local feature=$2

  if [[ -f "${config_folder}/peekaboo/${segment_name}" ]]; then
    return 0
  fi

  local local_script="${config_folder}/${type}s/${feature}.bash"
  local global_script="${sbp_path}/${type}s/${feature}.bash"

  if [[ -x "$local_script" ]]; then
    printf '%s' "$local_script"
  elif [[ -x "$global_script" ]]; then
    printf '%s' "$global_script"
  else
    log_error "Could not find $local_script"
    log_error "Could not find $global_script"
    log_error "Make sure it exists"
  fi
}

execute_segment_script() {
  local segment=$1
  local segment_direction=$2
  local segment_max_length=$3
  local segment_script="$(get_executable_script 'segment' "$segment")"

  if [[ -n "$segment_script" ]]; then
    bash "$segment_script" "$command_exit_code" "$command_time" "$segment_direction" "$segment_max_length"
  fi
}

execute_prompt_hooks() {
  for hook in "${settings_hooks[@]}"; do
    local hook_script="$(get_executable_script 'hook' "$hook")"

    if [[ -n "$hook_script" ]]; then
      (nohup bash "$hook_script" "$command_exit_code" "$command_time" &>/dev/null &)
    fi
  done
}

generate_prompt() {
  columns=$1
  command_exit_code=$2
  command_time=$3

  execute_prompt_hooks

  local prompt_left
  if [[ settings_prompt_start_newline -ne 0 ]]; then
    prompt_left='\n'
  else
    prompt_left=''
  fi
  local prompt_filler prompt_right prompt_ready seperator_direction base_dir
  local prompt_left_end=$(( ${#settings_segments_left[@]} - 1 ))
  local prompt_right_end=$(( ${#settings_segments_right[@]} + prompt_left_end ))
  local prompt_segments=("${settings_segments_left[@]}" "${settings_segments_right[@]}" 'prompt_ready')
  local number_of_top_segments=$(( ${#settings_segments_left[@]} + ${#settings_segments_right[@]} - 1))
  local segment_max_length=$(( columns / number_of_top_segments ))

  declare -A pid_left
  declare -A pid_right
  declare -A pid_two

  # Concurrent evaluation of promt segments
  systemd_tmp="/run/user/${UID}/"
  if [[ -d "${systemd_tmp}" ]]; then
    tempdir=$(mktemp -d --tmpdir="$systemd_tmp") && trap 'rm -rf "$tempdir"' EXIT;
  else
    tempdir=$(mktemp -d) && trap 'rm -rf "$tempdir"' EXIT;
  fi

  for i in "${!prompt_segments[@]}"; do
    segment_name="${prompt_segments[i]}"
    [[ -z "$segment_name" ]] && continue
    if [[ "$i" -eq 0 ]]; then
      seperator_direction=''
      pid_left["$i"]="$i"
    elif [[ "$i" -le "$prompt_left_end" ]]; then
      seperator_direction='right'
      pid_left["$i"]="$i"
    elif [[ "$i" -le "$prompt_right_end" ]]; then
      seperator_direction='left'
      pid_right["$i"]="$i"
    elif [[ "$i" -gt "$prompt_right_end" && -z "$pid_two" ]]; then
      seperator_direction=''
      pid_two["$i"]="$i"
    fi

    execute_segment_script "$segment_name" "$seperator_direction" "$segment_max_length" > "${tempdir}/${i}" & pids[i]=$!

  done

  total_empty_space="$columns"

  if [[ -n "${settings_prompt_prefix_upper}" ]]; then
    total_empty_space=$(( total_empty_space - ${#settings_prompt_prefix_upper} ))
    prefix_color="$(print_fg_color "$settings_prompt_ready_color_primary")"
    prompt_left="${prompt_left}${prefix_color}${settings_prompt_prefix_upper}"
  fi

  for i in "${!pids[@]}"; do
    wait "${pids[i]}"
    segment_length=$?
    segment=$(<"$tempdir/$i")
    empty_space=$(( total_empty_space - segment_length ))
    if [[ -n "${pid_left["$i"]}"  && "$empty_space" -gt 0 ]]; then
      prompt_left="${prompt_left}${segment}"
      total_empty_space="$empty_space"
    elif [[ -n "${pid_right["$i"]}" && "$empty_space" -gt 0  ]]; then
      prompt_right="${prompt_right}${segment}"
      total_empty_space="$empty_space"
    elif [[ -n "${pid_two["$i"]}" ]]; then
      prompt_ready="${segment}"
    fi
  done

  # Generate the filler segment
  if [[ -n "$prompt_right" ]]; then
    prompt_uncolored="$(( total_empty_space - 1 ))" # Account for the filler seperator
  else
    prompt_uncolored=0
  fi
  padding=$(printf "%*s" "$prompt_uncolored")
  prompt_filler="$(pretty_print_segment "" "" "$padding" "right")"


  if [[ "${settings_prompt_ready_newline}" -eq 1 ]]; then
    prompt_ready="\n${prompt_ready}"
  fi

  # Print the prompt and reset colors
  if [[ "${settings_prompt_ready_suppress}" -eq 1 ]]; then
    printf '%s' "${prompt_left}${prompt_filler}${prompt_right}${color_reset}"
  else
    printf '%s' "${prompt_left}${prompt_filler}${prompt_right}${color_reset}${prompt_ready}${color_reset}"
  fi

}

generate_prompt "$@"
