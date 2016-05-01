# shellcheck source=helpers/color.bash
source "${sbp_path}/helpers/color.bash"

function timstamp_minus_seconds() {
  local seconds timestamp
  seconds=$1
  timestamp=$(date +'%s')
  printf '%s' $(( timestamp - seconds ))
}

function test_that_we_get_the_right_spent_time() {
  local result
  result=$("${sbp_path}/segments/command.bash" 0 "$(timstamp_minus_seconds 5)")
  assert_substring "last: 0m 5s" "$result"
}

function test_that_we_get_a_failed_color() {
  local result color
  export settings_command_color_bg_error=32
  export settings_command_color_fg_error=24
  result=$("${sbp_path}/segments/command.bash" 1 0)
  color=$(get_current_bg_color "$result")
  assert_equals '32' "$color"
}
