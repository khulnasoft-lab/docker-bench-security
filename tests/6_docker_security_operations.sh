#!/bin/sh

logit "\n"
section_num="6"
section_desc="Docker Security Operations"


section_start "$section_num" "$section_desc"

# 6.5
check_num="6.5"
check_desc="Use a centralized and remote log collection service"

# If containers is empty, there are no running containers
if [ -z "$containers" ]; then
  info "$check_num" "$check_desc" "No containers running"
else
  fail=0
  set -f; IFS=$'
'
  for c in $containers; do
    volumes=$(docker inspect --format '{{ .Volumes }}' "$c")

    if [ "$volumes" = "map[]" ]; then
      # If it's the first container, fail the test
      if [ $fail -eq 0 ]; then
        info "$check_num" "$check_desc" "Container has no volumes, ensure centralized logging is enabled : $c"
        fail=1
      else
        info "$check_num" "$check_desc" "Container has no volumes, ensure centralized logging is enabled : $c"
      fi
    fi
  done
  # Only alert if there are no volumes. If there are volumes, can't know if they
  # are used for logs
fi
# Make the loop separator go back to space
set +f; unset IFS

# 6.6
check_num="6.6"
check_desc="Avoid image sprawl"
images=$(docker images -q | sort -u | wc -l | awk '{print $1}')
active_images=0

for c in $(docker inspect -f "{{.Image}}" $(docker ps -qa)); do
  if docker images --no-trunc -a | grep "$c" > /dev/null ; then
    active_images=$(( active_images += 1 ))
  fi
done

if [ "$images" -gt 100 ]; then
  warn "$check_num" "$check_desc" "There are currently: $images images"
else
  info "$check_num" "$check_desc" "There are currently: $images images"
fi

if [ "$active_images" -lt "$((images / 2))" ]; then
  warn "$check_num" "$check_desc" "Only $active_images out of $images are in use"
fi

# 6.7
check_num="6.7"
check_desc="Avoid container sprawl"
total_containers=$(docker info 2>/dev/null | grep "Containers" | awk '{print $2}')
running_containers=$(docker ps -q | wc -l | awk '{print $1}')
diff="$((total_containers - running_containers))"
if [ "$diff" -gt 25 ]; then
  warn "$check_num" "$check_desc" "There are currently a total of $total_containers containers, with only $running_containers of them currently running"
else
  info "$check_num" "$check_desc" "There are currently a total of $total_containers containers, with $running_containers of them currently running"
fi


section_end "$section_num" "$section_desc"
