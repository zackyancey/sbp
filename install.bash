#! /usr/bin/env bash

base_path=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

if [[ ! -f "$HOME"/.sbp ]]; then
  echo "Adding default config to $HOME/.sbp"
  cp "$base_path"/settings.default "$HOME/.sbp"
else
  echo "Found config at $HOME/.sbp"
fi

# shellcheck disable=SC2154
if [[ -z "$sbp_path" || "$base_path" != "$sbp_path" ]]; then 
  echo "Please add the following to your .bashrc or equivalent"
  echo "sbp_path=${base_path}"
  echo "source ${base_path}/sbp.bash"
else
  echo "Everything seems to be in order"
fi
