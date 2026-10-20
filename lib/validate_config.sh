#!/usr/bin/bash

# check if naledi.conf exists, is readable and has correct values

CURR_SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FILEPATH="$CURR_SCRIPT_DIR/../etc/naledi.conf"

invalid_value_error() {
  echo "ERROR: $1 is an invalid value"
  exit 1
}

missing_not_set_error() {
  echo "ERROR: $1 is missing or is not set in naledi.conf"
  exit 1
}

missing_unreadable_error() {
  echo "ERROR: $1 is missing or is unreadable"
  exit 1
}

is_not_negative_number() {
  if [[ "$1" =~ ^[0-9]+$ ]]; then
    if (( "$1" >= 0 )); then
      return 0
    fi
  fi

  return 1
}

check_int_variable() {
  if [[ -n "$1" ]]; then
    if ( ! is_not_negative_number "$1" ); then
      invalid_value_error "$2"
    fi
      
  else
    missing_not_set_error "$2"
  fi
}

validate_config() {
  if [[ ! -r "$FILEPATH" ]]; then
    missing_unreadable_error "naledi.conf"

  else
    source "$FILEPATH"

    if [[ -n "$PROJECT_ROOT" ]]; then

      if [[ ! -r $PROJECT_ROOT ]]; then
        missing_unreadable_error "PROJECT_ROOT directory"
      fi

    else
      missing_not_set_error "PROJECT_ROOT"
    fi      


    if [[ ! -n "$TAG_PREFIX" ]]; then
      missing_not_set_error "TAG_PREFIX"
    fi

    check_int_variable "$HERD_RECORDS" "HERD_RECORDS"
    check_int_variable "$DISTRICT_COUNT" "DISTRICT_COUNT"
    check_int_variable "$PERMIT_VALIDITY_DAYS" "PERMIT_VALIDITY_DAYS"
    check_int_variable "$INSPECTION_AGE_MONTHS" "INSPECTION_AGE_MONTHS"
    check_int_variable "$PENALTY_UNIT" "PENALTY_UNIT"
    check_int_variable "$COMPLIANCE_HOUR" "COMPLIANCE_HOUR"
    check_int_variable "$COMPLIANCE_MINUTE" "COMPLIANCE_MINUTE"
    check_int_variable "$BACKUP_RETENTION_DAYS" "BACKUP_RETENTION_DAYS"
  fi
}

