function test_that_sbp_passes_shellcheck() {
  check=$(shellcheck -s bash -x sbp.bash || :)
  assert_empty "$check"
}

function test_that_installer_passes_shellcheck() {
  check=$(shellcheck -s bash -x install.bash || :)
  assert_empty "$check"
}
