#!/usr/bin/bash

# seed quarantine_zones.dat

CURR_SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$CURR_SCRIPT_DIR/../lib/validate_config.sh"

validate_config
source "$CURR_SCRIPT_DIR/../etc/naledi.conf"


seed_quarantine_zones() {
  FILE_PATH="$PROJECT_ROOT/data/quarantine_zones.dat"
  DISTRICT_IDS=("D01" "D02" "D03" "D04" "D05" "D06")
  AUTHORITIES=("Department of Veterinary Services" "Discrict Veterinary Officer" "Chief Veterinary Officer" "Regional Veterinary Office" "Department of Veterinary Services" "District Veterinary Officer") 
  ZONE_STATUS=("OPEN" "QUARANTINE" "RESTRICTED")
  EFFECTIVE_FROM_DATE=("01-01-2026" "01-10-2026" "15-10-2026" "01-09-2026")
  EFFECTIVE_TO_DATE=("31-12-2026" "30-11-2026" "15-11-2026" "31-10-2026")

  if [[ ! -f "$FILE_PATH" ]]; then
    touch "$FILE_PATH"
  elif [[ -s "$FILE_PATH" ]]; then
    echo "$FILE_PATH already exists and has contents"
    return
  fi
  
  for districts in "${DISTRICT_IDS[@]}"; do
    rand_authorities_index=$(( RANDOM % ${#AUTHORITIES[@]})) # random index for AUTHORITIES array
    rand_zone_status_index=$(( RANDOM % ${#ZONE_STATUS[@]})) # random index for ZONE_STATUS
    rand_effective_from_date_index=$(( RANDOM % ${#EFFECTIVE_FROM_DATE[@]})) # random index for EFFECTIVE_FROM_DATE
    rand_effective_to_date_index=$(( RANDOM % ${#EFFECTIVE_TO_DATE[@]})) # random index for EFFECTIVE_TO_DATE
    
    printf "%s\n" "$districts|${ZONE_STATUS[$rand_zone_status_index]}|${EFFECTIVE_FROM_DATE[$rand_effective_from_date_index]}|${EFFECTIVE_TO_DATE[$rand_effective_to_date_index]}|${AUTHORITIES[$rand_authorities_index]}" >> "$FILE_PATH"
  done
}
