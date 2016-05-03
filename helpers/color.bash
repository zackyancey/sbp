# these are slow, do we need to use them as often?
function get_current_bg_color() { # returns the last bg color code
  sed -nE 's/.*\\\[\\e\[([0-9]+;[0-9]+;)?([0-9]+)m\\\].*/\2/pg' <<< "$1"
}

function strip_escaped_colors() {
  sed -E 's/\\\[\\e\[([0-9]+;[0-9]+;)?[0-9]+m\\\]//g' <<< "$1"
}
