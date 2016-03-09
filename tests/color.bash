function setup() {
  source helpers/imports.bash
}

function test_that_we_get_get_color_codes() {
  text=$(print_color_escapes '0' '1')
  assert_none_empty "${text}"
}

function test_that_we_fail() {
  htunesao
}
