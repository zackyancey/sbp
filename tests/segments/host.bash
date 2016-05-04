function segment() {
  printf '%s' "${@}"
}

export -f segment

function test_we_get_the_user_right() {
  result=$("${sbp_path}/segments/host.bash" 0 0)
  assert_equals " $USER " "$result"
}

function test_that_we_detect_ssh() {
  export SSH_CLIENT=yes
  result=$("${sbp_path}/segments/host.bash" 0 0)
  assert_equals " ${USER}@${HOSTNAME} " "$result"
}
