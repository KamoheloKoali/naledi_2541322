#!/usr/bin/bash

# seed districts.dat

CURR_SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$CURR_SCRIPT_DIR/../etc/naledi.conf"

seed_districts() {
  FILE_PATH="$PROJECT_ROOT/data/disctricts.dat"
  DISTRICTS=("Maseru" "Berea" "Butha-Buthe" "Leribe" "Mafeteng" "Quthing")
  OFFICES=("Central Office" "Northern Office" "Southern Office")

  if [[ ! -f "$FILE_PATH" ]]; then
    touch "$FILE_PATH"
  elif [[ -s "$FILE_PATH" ]]; then
    echo "$FILE_PATH already exists and has contents"
    return
  fi

  district_count=1
  
  for district in "${DISTRICTS[@]}"; do
    random_index=$(( RANDOM % ${#OFFICES[@]})) # get random index from OFFICES arrya
    printf "%s\n" "D0$district_count|$district|${OFFICES[$random_index]}" >> "$FILE_PATH"
    ((district_count++))
  done
}
