
function get_current_bg_color() { # returns the last bg color code
  LC_ALL=C sed -nE 's/.*\\\[\\e\[([0-9]+;[0-9]+;)?([0-9]+)m\\\].*/\2/pg' <<< "$1"
}

function strip_escaped_colors() {
  LC_ALL=C sed -E 's/\\\[\\e\[([0-9]+;[0-9]+;)?[0-9]+m\\\]//g' <<< "$1"
}
