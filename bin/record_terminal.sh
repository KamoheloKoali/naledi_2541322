#!/usr/bin/bash

# automate starting terminal session recording

CURR_SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$CURR_SCRIPT_DIR/../lib/validate_config.sh"

validate_config
source "$CURR_SCRIPT_DIR/../etc/naledi.conf"


cd "$PROJECT_ROOT"
script -a "logs/session-$(date +%F).typescript"
