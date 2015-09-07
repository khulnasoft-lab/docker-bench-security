#!/bin/sh

logit "\n"

section_num="5"
section_desc="DocContainer Runtime"

section_start "$section_num" "$section_desc"


# If containers is empty, there are no running containers
if [ -z "$containers" ]; then
  check_num="5"
  check_desc="Running containers" "No containers running, skipping Section 5"
  info "$check_num" "$check_desc"
else
  # Make the loop separator be a new-line in POSIX compliant fashion
  set -f; IFS=$'
'
  # 5.1
  check_num="5.1"
  check_desc="Verify AppArmor Profile, if applicable"

  fail=0
  for c in $containers; do
    policy=$(docker inspect --format 'AppArmorProfile={{ .AppArmorProfile }}' "$c")

    if [ "$policy" = "AppArmorProfile=" -o "$policy" = "AppArmorProfile=[]" -o "$policy" = "AppArmorProfile=<no value>" ]; then
      # If it's the first container, fail the test
      if [ $fail -eq 0 ]; then
        warn "$check_num" "$check_desc" "No AppArmorProfile Found: $c"
        fail=1
      else
        warn "$check_num" "$check_desc" "No AppArmorProfile Found: $c"
      fi
    fi
  done
  # We went through all the containers and found none without AppArmor
  if [ $fail -eq 0 ]; then
      pass "$check_num" "$check_desc"
  fi

  # 5.2
  check_num="5.2"
  check_desc="Verify SELinux security options, if applicable"

  fail=0
  for c in $containers; do
    policy=$(docker inspect --format 'SecurityOpt={{ .HostConfig.SecurityOpt }}' "$c")

    if [ "$policy" = "SecurityOpt=" -o "$policy" = "SecurityOpt=[]" -o "$policy" = "SecurityOpt=<no value>" ]; then
      # If it's the first container, fail the test
      if [ $fail -eq 0 ]; then
        warn "$check_num" "$check_desc" "No SecurityOptions Found: $c"
        fail=1
      else
        warn "$check_num" "$check_desc" "No SecurityOptions Found: $c"
      fi
    fi
  done
  # We went through all the containers and found none without SELinux
  if [ $fail -eq 0 ]; then
      pass "$check_num" "$check_desc"
  fi

  # 5.3
  check_num="5.3"
  check_desc="Verify that containers are running only a single main process"

  fail=0
  printcheck=0
  for c in $containers; do
    processes=$(docker exec "$c" ps -el 2>/dev/null | tail -n +2 | grep -c -v "ps -el")
    if [ "$processes" -gt 1 ]; then
      # If it's the first container, fail the test
      if [ $fail -eq 0 ]; then
        warn "$check_num" "$check_desc" "Too many proccesses running: $c"
        fail=1
	      printcheck=1
      else
        warn "$check_num" "$check_desc" "Too many proccesses running: $c"
      fi
    fi

    exec_check=$(docker exec "$c" ps -el 2>/dev/null)
    if [ $? -eq 255 ]; then
        if [ $printcheck -eq 0 ]; then
          warn "$check_num" "$check_desc"
	        printcheck=1
        fi
      warn "$check_num" "$check_desc" "Docker exec fails: $c"
      fail=1
    fi

  done
  # We went through all the containers and found none with toom any processes
  if [ $fail -eq 0 ]; then
      pass "$check_num" "$check_desc"
  fi

  # 5.4
  check_num="5.4"
  check_desc="Restrict Linux Kernel Capabilities within containers"

  fail=0
  for c in $containers; do
    caps=$(docker inspect --format 'CapAdd={{ .HostConfig.CapAdd}}' "$c")

    if [ "$caps" != 'CapAdd=' -a "$caps" != 'CapAdd=[]' -a "$caps" != 'CapAdd=<no value>' -a "$caps" != 'CapAdd=<nil>' ]; then
      # If it's the first container, fail the test
      if [ $fail -eq 0 ]; then
        warn "$check_num" "$check_desc" "Capabilities added: $caps to $c"
        fail=1
      else
        warn "$check_num" "$check_desc" "Capabilities added: $caps to $c"
      fi
    fi
  done
  # We went through all the containers and found none with extra capabilities
  if [ $fail -eq 0 ]; then
      pass "$check_num" "$check_desc"
  fi

  # 5.5
  check_num="5.5"
  check_desc="Do not use privileged containers"

  fail=0
  for c in $containers; do
    privileged=$(docker inspect --format '{{ .HostConfig.Privileged }}' "$c")

    if [ "$privileged" = "true" ]; then
      # If it's the first container, fail the test
      if [ $fail -eq 0 ]; then
        warn "$check_num" "$check_desc" "Container running in Privileged mode: $c"
        fail=1
      else
        warn "$check_num" "$check_desc" "Container running in Privileged mode: $c"
      fi
    fi
  done
  # We went through all the containers and found no privileged containers
  if [ $fail -eq 0 ]; then
      pass "$check_num" "$check_desc"
  fi

  # 5.6
  check_num="5.6"
  check_desc="Do not mount sensitive host system directories on containers"

  # List of sensitive directories to test for. Script uses new-lines as a separator.
  # Note the lack of identation. It needs it for the substring comparison.
  sensitive_dirs='/boot
/dev
/etc
/lib
/proc
/sys
/usr'
  fail=0
  for c in $containers; do
    volumes=$(docker inspect --format '{{ .VolumesRW }}' "$c")
    # Go over each directory in sensitive dir and see if they exist in the volumes
    for v in $sensitive_dirs; do
      sensitive=0
      contains "$volumes" "$v:" && sensitive=1
      if [ $sensitive -eq 1 ]; then
        # If it's the first container, fail the test
        if [ $fail -eq 0 ]; then
          warn "$check_num" "$check_desc" "Sensitive directory $v mounted in: $c"
          fail=1
        else
          warn "$check_num" "$check_desc" "Sensitive directory $v mounted in: $c"
        fi
      fi
    done
  done
  # We went through all the containers and found none with sensitive mounts
  if [ $fail -eq 0 ]; then
      pass "$check_num" "$check_desc"
  fi

  # 5.7
  check_num="5.7"
  check_desc="Do not run ssh within containers"

  fail=0
  printcheck=0
  for c in $containers; do

    processes=$(docker exec "$c" ps -el 2>/dev/null | grep -c sshd | awk '{print $1}')
    if [ "$processes" -ge 1 ]; then
      # If it's the first container, fail the test
      if [ $fail -eq 0 ]; then
        warn "$check_num" "$check_desc" "Container running sshd: $c"
        fail=1
	      printcheck=1
      else
        "$check_num" "$check_desc" "Container running sshd: $c"
      fi
    fi

    exec_check=$(docker exec "$c" ps -el 2>/dev/null)
    if [ $? -eq 255 ]; then
        if [ $printcheck -eq 0 ]; then
          warn "$check_num" "$check_desc"
	        printcheck=1
        fi
      warn "$check_num" "$check_desc" "Docker exec fails: $c"
      fail=1
    fi

  done
  # We went through all the containers and found none with sshd
  if [ $fail -eq 0 ]; then
      pass "$check_num" "$check_desc"
  fi

  # 5.8
  check_num="5.8"
  check_desc="Do not map privileged ports within containers"

  fail=0
  for c in $containers; do
    # Port format is private port -> ip: public port
    ports=$(docker port "$c" | awk '{print $0}' | cut -d ':' -f2)

    # iterate through port range (line delimited)
    for port in $ports; do
    if [ ! -z "$port" ] && [ "0$port" -lt 1024 ]; then
        # If it's the first container, fail the test
        if [ $fail -eq 0 ]; then
          warn "$check_num" "$check_desc" "Privileged Port in use: $port in $c"
          fail=1
        else
          warn "$check_num" "$check_desc" "Privileged Port in use: $port in $c"
        fi
      fi
    done
  done
  # We went through all the containers and found no privileged ports
  if [ $fail -eq 0 ]; then
      pass "$check_num" "$check_desc"
  fi

  # 5.10
  check_num="5.10"
  check_desc="Do not use host network mode on container"

  fail=0
  for c in $containers; do
    mode=$(docker inspect --format 'NetworkMode={{ .HostConfig.NetworkMode }}' "$c")

    if [ "$mode" = "NetworkMode=host" ]; then
      # If it's the first container, fail the test
      if [ $fail -eq 0 ]; then
        warn "$check_num" "$check_desc" "Container running with networking mode 'host': $c"
        fail=1
      else
        warn "$check_num" "$check_desc" "Container running with networking mode 'host': $c"
      fi
    fi
  done
  # We went through all the containers and found no Network Mode host
  if [ $fail -eq 0 ]; then
      pass "$check_num" "$check_desc"
  fi

  # 5.11
  check_num="5.11"
  check_desc="Limit memory usage for container"

  fail=0
  for c in $containers; do
    memory=$(docker inspect --format '{{ .Config.Memory }}' "$c")

    if [ "$memory" = "0" ]; then
      # If it's the first container, fail the test
      if [ $fail -eq 0 ]; then
        warn "$check_num" "$check_desc" "Container running without memory restrictions: $c"
        fail=1
      else
        warn "$check_num" "$check_desc" "Container running without memory restrictions: $c"
      fi
    fi
  done
  # We went through all the containers and found no lack of Memory restrictions
  if [ $fail -eq 0 ]; then
      pass "$check_num" "$check_desc"
  fi

  # 5.12
  check_num="5.12"
  check_desc="Set container CPU priority appropriately"

  fail=0
  for c in $containers; do
    shares=$(docker inspect --format '{{ .Config.CpuShares }}' "$c")

    if [ "$shares" = "0" ]; then
      # If it's the first container, fail the test
      if [ $fail -eq 0 ]; then
        warn "$check_num" "$check_desc" "Container running without CPU restrictions: $c"
        fail=1
      else
        warn "$check_num" "$check_desc" "Container running without CPU restrictions: $c"
      fi
    fi
  done
  # We went through all the containers and found no lack of CPUShare restrictions
  if [ $fail -eq 0 ]; then
      pass "$check_num" "$check_desc"
  fi

  # 5.13
  check_num="5.13"
  check_desc="Mount container's root filesystem as read only"

  fail=0
  for c in $containers; do
   read_status=$(docker inspect --format '{{ .HostConfig.ReadonlyRootfs }}' "$c")

    if [ "$read_status" = "false" ]; then
      # If it's the first container, fail the test
      if [ $fail -eq 0 ]; then
        warn "$check_num" "$check_desc" "Container running with root FS mounted R/W: $c"
        fail=1
      else
        warn "$check_num" "$check_desc" "Container running with root FS mounted R/W: $c"
      fi
    fi
  done
  # We went through all the containers and found no R/W FS mounts
  if [ $fail -eq 0 ]; then
      pass "$check_num" "$check_desc"
  fi

  # 5.14
  check_num="5.14"
  check_desc="Bind incoming container traffic to a specific host interface"

  fail=0
  for c in $containers; do
    for ip in $(docker port "$c" | awk '{print $3}' | cut -d ':' -f1); do
      if [ "$ip" = "0.0.0.0" ]; then
        # If it's the first container, fail the test
        if [ $fail -eq 0 ]; then
          warn "$check_num" "$check_desc" "Port being bound to wildcard IP: $ip in $c"
          fail=1
        else
          warn "$check_num" "$check_desc" "Port being bound to wildcard IP: $ip in $c"
        fi
      fi
    done
  done
  # We went through all the containers and found no ports bound to 0.0.0.0
  if [ $fail -eq 0 ]; then
      pass "$check_num" "$check_desc"
  fi

  # 5.15
  check_num="5.15"
  check_desc="Do not set the 'on-failure' container restart policy to always"

  fail=0
  for c in $containers; do
    policy=$(docker inspect --format 'RestartPolicyName={{ .HostConfig.RestartPolicy.Name }}' "$c")

    if [ "$policy" = "RestartPolicyName=always" ]; then
      # If it's the first container, fail the test
      if [ $fail -eq 0 ]; then
        warn "$check_num" "$check_desc" "Restart Policy set to always: $c"
        fail=1
      else
        warn "$check_num" "$check_desc" "Restart Policy set to always: $c"
      fi
    fi
  done
  # We went through all the containers and found none with restart policy always
  if [ $fail -eq 0 ]; then
      pass "$check_num" "$check_desc"
  fi

  # 5.16
  check_5_16="5.16"
  check_desc="Do not share the host's process namespace"

  fail=0
  for c in $containers; do
    mode=$(docker inspect --format 'PidMode={{.HostConfig.PidMode }}' "$c")

    if [ "$mode" = "PidMode=host" ]; then
      # If it's the first container, fail the test
      if [ $fail -eq 0 ]; then
        warn "$check_num" "$check_desc" "Host PID namespace being shared with: $c"
        fail=1
      else
        warn "$check_num" "$check_desc" "Host PID namespace being shared with: $c"
      fi
    fi
  done
  # We went through all the containers and found none with PidMode as host
  if [ $fail -eq 0 ]; then
      pass "$check_num" "$check_desc"
  fi

  # 5.17
  check_num="5.17"
  check_desc="Do not share the host's IPC namespace"

  fail=0
  for c in $containers; do
    mode=$(docker inspect --format 'IpcMode={{.HostConfig.IpcMode }}' "$c")

    if [ "$mode" = "IpcMode=host" ]; then
      # If it's the first container, fail the test
      if [ $fail -eq 0 ]; then
        warn "$check_num" "$check_desc" "Host IPC namespace being shared with: $c"
        fail=1
      else
        warn "$check_num" "$check_desc" "Host IPC namespace being shared with: $c"
      fi
    fi
  done
  # We went through all the containers and found none with IPCMode as host
  if [ $fail -eq 0 ]; then
      pass "$check_num" "$check_desc"
  fi

  # 5.18
  check_5_18="5.18 - Do not directly expose host devices to containers"

  fail=0
  for c in $containers; do
    devices=$(docker inspect --format 'Devices={{ .HostConfig.Devices }}' "$c")

    if [ "$devices" != "Devices=" -a "$devices" != "Devices=[]" -a "$devices" != "Devices=<no value>" ]; then
      # If it's the first container, fail the test
      if [ $fail -eq 0 ]; then
        info "$check_num" "$check_desc" "Container has devices exposed directly: $c"
        fail=1
      else
        info "$check_num" "$check_desc" "Container has devices exposed directly: $c"
      fi
    fi
  done
  # We went through all the containers and found none with devices
  if [ $fail -eq 0 ]; then
      pass "$check_num" "$check_desc"
  fi

  # 5.19
  check_num="5.19"
  check_desc="Override default ulimit at runtime only if needed"

  # List all the running containers, ouput their ID and host devices
  fail=0
  for c in $containers; do
    ulimits=$(docker inspect --format 'Ulimits={{ .HostConfig.Ulimits }}' "$c")

    if [ "$ulimits" = "Ulimits=" -o "$ulimits" = "Ulimits=[]" -o "$ulimits" = "Ulimits=<no value>" ]; then
      # If it's the first container, fail the test
      if [ $fail -eq 0 ]; then
        info "$check_num" "$check_desc" "Container no default ulimit override: $c"
        fail=1
      else
        info "$check_num" "$check_desc" "Container no default ulimit override: $c"
      fi
    fi
  done
  # We went through all the containers and found none without Ulimits
  if [ $fail -eq 0 ]; then
      pass "$check_num" "$check_desc"
  fi
fi

section_end "$section_num" "$section_desc"