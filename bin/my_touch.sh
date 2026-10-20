#!/usr/bin/bash

# Create a shell script file, make it executable and insert shebang statement

CURR_SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$CURR_SCRIPT_DIR/../lib/validate_config.sh"

validate_config
source "$CURR_SCRIPT_DIR/../etc/naledi.conf"
source "$PROJECT_ROOT/lib/create_script.sh"

if [[ -z "$1" ]]; then
  echo "usage: mytouch <path_to_file>"

else
  path_to_file="$PROJECT_ROOT"

  if [[ "$1" == "--import-variables" ]]; then
    create_with_import "$path_to_file/$2"

  else
    create_normally "$path_to_file/$1"

  fi
fi
