#!/usr/bin/bash

# seed herd_register.dat 

CURR_SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$CURR_SCRIPT_DIR/../lib/validate_config.sh"

validate_config
source "$CURR_SCRIPT_DIR/../etc/naledi.conf"


generate_date_of_birth() {
  days_less_18=$(( RANDOM % 548 ))
  date_less_18=$( date -d "-$days_less_18 days" +%F )

  # between 19 months and 2 yearss
  days_mid_range=$(( 578 + (RANDOM % 153) )) 
  date_mid_range=$(date -d "-$days_mid_range days" +%F)

  if [[ "$1" == "-18" ]]; then
    printf "%s\n" "$date_less_18"

  elif [[ "$1" == "+18" ]]; then
    printf "%s\n" "$date_mid_range"
  fi
}

generate_registered_on() {
  base_date=$(date -d "$1" "+%s")
  current_date=$(date -d "today 00:00:00" "+%s")

  days_difference=$(( (current_date - base_date) / 86400 ))

  random_days=$(( RANDOM % (days_difference + 1) ))

  registration_date=$(( base_date + (random_days * 86400) ))

  formatted_registration_date=$(date -d "@$registration_date" +%F)
  printf "%s\n" "$formatted_registration_date"
}

seed_herd_register() {
  FILE_PATH="$PROJECT_ROOT/data/herd_registry.dat"
  FIRST_NAMES=("Kamohelo" "Tebello" "Napo" "Reitumetse" "Mpiti" "Atang")
  SURNAMES=("Koali" "Tshoele" "Mpana" "Monyau" "Letsie" "Sechocha")
  USER_IDS=()
  VILLAGES=("Moshoeshoe 2" "Maqhaka" "Khubetsoana" "Sekamaneng" "Koalabata" "Ha Foso")
  DISTRICT_IDS=("D01" "D02" "D03" "D04" "D05" "D06")
  BREEDS=("Brahman" "Bonsmara" "Nguni" "Afrikaner" "Simmental" "Limousin")
  SEXES=("M" "F")
  MONTHS_OLD=("-18" "+18")
  STATUSES=("ACTIVE" "QUARANTINE" "IN-TRANSIT" "WITHDRAWN")



  if [[ ! -f "$FILE_PATH" ]]; then
    touch "$FILE_PATH"
  elif [[ -s "$FILE_PATH" ]]; then
    echo "$FILE_PATH already exists and has contents"
    return
  fi

  mapfile -t NUMBERS < <(
    awk 'BEGIN {
        srand()
        for (i = 0; i < 6; i++) {
            printf "%.0f\n", rand() * 900000 + 100000
        }
    }'
  )

  for ((i = 0; i < 6; i++)); do
    USER_IDS[$i]=${NUMBERS[$i]}
  done


  for ((i = 0; i < $HERD_RECORDS; i++)); do
    random_names_index=$(( RANDOM % ${#FIRST_NAMES[@]} )) # used to get both first name, surname and district id at random
    random_villages_index=$(( RANDOM % ${#VILLAGES[@]} ))
    random_breeds_index=$(( RANDOM % ${#BREEDS[@]} ))
    random_sexes_index=$(( RANDOM % ${#SEXES[@]} ))
    random_months_old_index=$(( RANDOM % ${#MONTHS_OLD[@]} ))
    random_Statuses_index=$(( RANDOM % ${#STATUSES[@]} ))
    date_of_birth=$(generate_date_of_birth "${MONTHS_OLD[$random_months_old_index]}")
    registered_on=$(generate_registered_on "$date_of_birth")
    random_user_ids_index=$(( RANDOM % ${#USER_IDS[@]} ))

    printf "%s%05d%s\n" "$TAG_PREFIX" "$i" "|${USER_IDS[$random_user_ids_index]}|${SURNAMES[$random_user_ids_index]}|${FIRST_NAMES[$random_user_ids_index]}|${VILLAGES[$random_villages_index]}|${DISTRICT_IDS[$random_user_ids_index]}|${BREEDS[$random_breeds_index]}|${SEXES[$random_sexes_index]}|$(date -d "$date_of_birth" '+%d-%m-%Y')|${STATUSES[$random_Statuses_index]}|$(date -d "$registered_on" '+%d-%m-%Y')" >> "$FILE_PATH"
  done
  

}
