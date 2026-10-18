#!/usr/bin/bash

# Identify current user and whether filesystem supports permissions and ACLs

mywhoami() {
  echo "------ IDENTITY BANNER ------" 
  echo
  echo "------- CURRENT USER ------"
  printf '%s | %s@%s | %s\n' "$STUDENT_ID" "$(whoami)" "$(uname -n)" "$(date '+%F %T %T')";
  echo

  echo "------ FILESYSTEM INFO ------"
  findmnt -T $PROJECT_ROOT

  echo
  echo "------ OUTPUT ------"
  echo
}


