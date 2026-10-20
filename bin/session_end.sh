#!/usr/bin/env bash
# session_end.sh - run at the end of every working session
# usage: ./session_end.sh /media/$USER/MYSTICK
set -euo pipefail
: "${STUDENT_ID:?set STUDENT_ID in your shell profile}"
: "${CHECKPOINT:?set CHECKPOINT in your profile}"
STICK="${1:?usage: session_end.sh /path/to/your/device}"
ARCHIVE="$STICK/C6LIE19_${STUDENT_ID}_${CHECKPOINT}.tar.gz"
CHAIN="$STICK/chain.txt"

if [[ -e "$ARCHIVE" ]]; then
    echo "Error: Archive already exists: $ARCHIVE"
    exit 1
fi

tar czf "$ARCHIVE" -C "$HOME" "naledi_$STUDENT_ID"
HASH=$(sha256sum "$ARCHIVE" | cut -d" " -f1)

if [[ -s "$CHAIN" ]]; then
    PREV=$(tail -n 1 "$CHAIN" 2>/dev/null | awk -F"|" "{print \$NF}")
else
    PREV=${PREV:-GENESIS}
fi

LINK=$(printf "%s%s" "$PREV" "$HASH" | sha256sum | cut -d" " -f1)
printf "%s|%s|%s|%s|%s|%s\n" "$(date -Is)" "$STUDENT_ID" "$(uname -n)" \
 "$(basename "$ARCHIVE")" "$HASH" "$LINK" >> "$CHAIN"
printf "Archived %s\nChain link %s\n" "$(basename "$ARCHIVE")" "$LINK"
