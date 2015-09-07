#!/bin/sh

logit "\n"

section_num="4"
section_desc="Container Images and Build Files"

section_start "$section_num" "$section_desc"


# 4.1
check_num="4.1"
check_desc="Create a user for the container"

# If container_users is empty, there are no running containers
if [ -z "$containers" ]; then
  info "$check_num" "$check_desc" "No containers running"
else
  # We have some containers running, set failure flag to 0. Check for Users.
  fail=0
  # Make the loop separator be a new-line in POSIX compliant fashion
  set -f; IFS=$'
'
  for c in $containers; do
    user=$(docker inspect --format 'User={{.Config.User}}' "$c")

    if [ "$user" = "User=" -o "$user" = "User=[]" -o "$user" = "User=<no value>" ]; then
      # If it's the first container, fail the test
      if [ $fail -eq 0 ]; then
        warn "$check_num" "$check_desc" "Running as root: $c"
        fail=1
      else
        warn "$check_num" "$check_desc" "Running as root: $c"
      fi
    fi
  done
  # We went through all the containers and found none running as root
  if [ $fail -eq 0 ]; then
      pass "$check_num" "$check_desc"
  fi
fi
# Make the loop separator go back to space
set +f; unset IFS

section_end "$section_num" "$section_desc"