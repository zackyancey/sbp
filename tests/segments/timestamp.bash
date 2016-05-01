# shellcheck source=helpers/color.bash
source "${sbp_path}/helpers/color.bash"

function test_that_we_get_the_right_time() {
  local result timestamp
  timestamp=$(date +'%H:%M:%S')
  result=$("${sbp_path}/segments/timestamp.bash" 0 "$(date +'%s')")
  assert_equals " $timestamp " "$(strip_escaped_colors "$result")"
}
