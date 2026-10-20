#!/usr/bin/bash

# create requested script files with execution permissions and more at specified paths


creation_successful() {
  echo "File created successfully at $1 and given execution permissions"
} 


creation_unsuccessful() {
  echo "File creation unsuccessful"
}


create_normally () {
  # create a script file with just a shebang statement at the top

  if (
    touch "$1";
    chmod +x "$1";
    printf "%s\n" "#!/usr/bin/bash" > "$1"
  ); then
    creation_successful "$1"

  else
    creation_unsucessful
  fi
}


create_with_import () {
  # create a script file with a shebang statement plus import statement
  
  if (
    touch "$1";
    chmod +x "$1";
    printf "%s\n\n" "#!/usr/bin/bash" > "$1";
    printf "%s\n" 'CURR_SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"' >> "$1";
    printf "%s\n" 'source "$CURR_SCRIPT_DIR/../lib/validate_config.sh"

validate_config
source "$CURR_SCRIPT_DIR/../etc/naledi.conf"
' >> "$1"
  ); then
    creation_successful "$1"
  else
    creation_unsuccessful
  fi
}

