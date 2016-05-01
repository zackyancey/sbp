function get_current_bg_color() { # returns the last bg color code
  sed -Ee 's/\[00m/\[48;5;0m/g' -ne 's/.*\[48;5;([0-9]+)m.*/\1/gp' <<< "$1"
}

function strip_escaped_colors() {
  echo -e "${1}" | perl -pe 's/\x1b\[[0-9;]*m//g' |  sed -e 's/\\e\[00m//g' -e 's/\\\[\\\]//g'
}
