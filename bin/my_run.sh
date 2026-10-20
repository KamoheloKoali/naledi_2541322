#!/usr/bin/bash

CURR_SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$CURR_SCRIPT_DIR/../lib/validate_config.sh"

validate_config
source "$CURR_SCRIPT_DIR/../etc/naledi.conf"

if [[ -z "$1" ]]; then
  echo "usage: myrun [ ...OPTIONS ] <path_to_file or command>"

else
  source "$PROJECT_ROOT/lib/banner.sh" # import mywhoami function
  
  if [[ "$1" == "--show-banner-only" ]]; then
    mywhoami
    exit
  fi

  if [[ "$1" == "-c" ]]; then
    mywhoami

    if [[ "$3" == -* ]]; then # check if third argument is a flag
    "$2" "$3"
    else
      $2
    fi

  else
    path_to_file="$PROJECT_ROOT/bin/$1"
    mywhoami

    source $path_to_file
  fi
fi
