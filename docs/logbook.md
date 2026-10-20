# Engineering Log Book
A record of my what I attempted, what failed, what I accomplished, and the chain link generated when I archive a session.


# 17-10-2026 to 18-10-2026

### Attempted
- I attempted making automation scripts for future use during development. The goal is to be able to create a script that creates the desired shell script, assign it execute permissions, insert a shebang statement as well as adding import statements for naledi.conf below the shebang statement if the flag "--import-variables" is provided when running the script. I aliased it "mytouch" in "~/.bashrc"

- Another automation script I had tried is one that I use to run shell scripts and shell commands whose tasks require the banner to be shown in running the output. its aim is to avoid having to invoke my banner function each time it is needed to be run when running a shell script or shell command needing it. I aliased it "myrun" in "~/.bashrc"

- I tried making a shell script to automate seeding my data files. I wanted to be able to whenever necessary, be able to quickly re-seed the needed data files.

### Failures and Problems
With the feature to be able to create scripts already having the shebang statement, and naledi.conf import without hardcoding the path to naledi.conf itself was problematic. Firstly to import naledi.conf without hardcoding the path to it,  after the shebang statement, I placed the following: 

```
CURR_SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$CURR_SCRIPT_DIR/../etc/naledi.conf"
```
Initially, I used the echo command and redirected the output using `>` to the created shell script. However, the variable calls in those two lines would be written into that file after being expanded out, meaning the path to naledi.conf would be written as is in the new file, resulting in a hardcoded path, which is what we want to avoid.

I tried escaping the `$` for each variable with `\`,  it did not work, I in fact got syntax error because of my bad placement of those but even when I did place them correctly, it did not work. I also tried placing the variable calls in single quotes, that did not help either.

What eventually did work was using printf with the `%s` option,  and with that I was able to preserve and write those two lines as is.

### What I accomplished
- I managed to successfully complete, test and use my automation shell scripts being my_run.sh and my_touch.sh as well use them for creating other shell script files (module shell scripts so far and the seeding shell script)

- Lastly, I achieved completing my shell script for seeding data. Although it only seeds herd_registry.dat, districts.dat and quarantine_zones.dat only so far.

#### Chain link
```
````

```
```
```
Chain link 16791db89d26122b7d2a20e871227e0c870e07d90d3efda148f6bcebfa435e90
```

```


# Engineering Log Book
A record of my what I attempted, what failed, what I accomplished, and the chain link generated when I archive a session.


# 19-10-2026 to 20-10-2026

### Attempted
- Today I attempted to improve validation of naledi.conf. The goal was to ensure that naledi.conf existed and that it was readable. In the case that checks are not satisfied, I made sure that the shell script fails safely and nothing executes.

- I tried writing a shell script to validate every variable defined in naledi.conf. the aim was to have the shell script ensure that every required variable from operating parameters existed and was set to their appropriate values. Also here in the event that checks are not satisfied, I made sure that the shell script fails safely and nothing executes.

- I worked on modularizing the code for validating naledi.conf and that of validating required variables from operating parameters. I wanted to make it so that I do not have to repeat the same code over and over again in every shell script I create moving forward

### Failures and Problems
One problem I did have was a logical bug in my validation shell script. For the variables that are meant to be set to positive integers, when testing my validation script, I set one of them, `HERD_RECORDS` to a negative value. The expected output was the message `ERROR: HERD_RECORDS is an invalid value` and a safe fail. I however got the message `ERROR: PROJECT_ROOT is an invalid value`.

To explain what happened, I need to start with how I validate variables that are meant to store positive integers.

I made the following function to validate integer variables:

```
check_int_variable() {
  if [[ -n "$1" ]]; then
    if ( ! is_not_negative_number "$1" ); then
      invalid_value_error "$2"
    fi
      
  else
    missing_not_set_error "$2"
  fi
}
``` 
I call the above function in my main function and the exact function call for the `HERD_RECORDS` variable is:
```
check_int_variable "$HERD_RECORDS" "HERD_RECORDS"
```

Now, the issue is that in the `invalid_value_error` function, I had hardcoded the variable that was checked at that moment as `PROJECT_ROOT`, which supposed to be dynamic like so:
```
invalid_value_error() {
  echo "ERROR: PROJECT_ROOT is an invalid value"
  exit 1
}
```

The fix was  to simply make it dynamic by using in the provided argument when it was called like so:

```
invalid_value_error() {
  echo "ERROR: $1 is an invalid value"
  exit 1
}
```
**NOTE**:  All above functions are in the same file named `validate_config.sh`

##
Another Problem I had to resolve was the legacy code that I initially used to validate naledi.conf. It did not meet instructions and was not modularized.

In every shell script, I initially had the top, just the following to validate naledi.conf:

```
CURR_SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ ! -f "$CURR_SCRIPT_DIR/../etc/naledi.conf" ]]; then
  echo "ERROR: /etc/naledi.conf does not exist!"
  exit
else
  source "$CURR_SCRIPT_DIR/../etc/naledi.conf" 
fi
```

and now I have:

```
CURR_SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$CURR_SCRIPT_DIR/../lib/validate_config.sh"

validate_config
source "$CURR_SCRIPT_DIR/../etc/naledi.conf"
```
with `validate_config` being more comprehensive.

### What I accomplished
- I managed to complete and meet all my goals for the validation shell script for `naledi.conf`.

- I also successfully replaced legacy code that initially only checked if `naledi.conf` existed in all the shell scripts that were created before `validate_config.sh` with just one function call `validate_config` after importing the `validate_config.sh` shell script.

- most importantly, I successfully changed the logic in my `create_script.sh` module utilized by `mytouch` to make sure it now adds the new method of validating `naledi.conf` and required operating parameters. 

