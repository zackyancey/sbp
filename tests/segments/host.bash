function pretty_print_segment() {
  printf '%s' "${@}"
}

export -f pretty_print_segment

function test_we_get_the_user_right() {
  result=$("${sbp_path}/segments/host.bash" 0 0)
  assert_equals " $USER " "$result"
}
