#!/usr/bin/bash

# seed initial data

CURR_SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$CURR_SCRIPT_DIR/../etc/naledi.conf"
source "$PROJECT_ROOT/lib/seed_districts.sh"
source "$PROJECT_ROOT/lib/seed_herd_registry.sh"
source "$PROJECT_ROOT/lib/seed_quarantine_zones.sh"

# seed districts
seed_districts
seed_quarantine_zones
seed_herd_register
