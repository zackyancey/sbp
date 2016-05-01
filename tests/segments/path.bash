# shellcheck source=helpers/color.bash
source "${sbp_path}/helpers/color.bash"

function test_that_we_get_full_path() {
  local result
  local wdir=${PWD/$HOME/\~}
  local paths=${wdir//\//  }
  result=$("${sbp_path}/segments/path.bash" 0 0)
  assert_equals " $paths " "$(strip_escaped_colors "$result")"
}
