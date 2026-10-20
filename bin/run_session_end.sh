#!/usr/bin/bash

# run session_end.sh on provided flash drive mount 


if [[ -z "$1" ]]; then
  echo "usage: run-session-end <flash_drive_mount>"
  exit
fi

bash $1/session_end.sh $1

# to get mount:
# lsblk -o NAME,TRAN,SIZE,FSTYPE,LABEL,MOUNTPOINTS
