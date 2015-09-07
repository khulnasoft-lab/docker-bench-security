#!/bin/sh

logit ""
section_num="1"
section_desc="Host Configuration"

section_start "$section_num" "$section_desc"

# 1.1
check_num="1.1"
check_desc="Create a separate partition for containers"
grep /var/lib/docker /etc/fstab >/dev/null 2>&1
if [ $? -eq 0 ]; then
  pass "$check_num" "$check_desc"
else
  warn "$check_num" "$check_desc"
fi

# 1.2
check_num="1.2"
check_desc="Use an updated Linux Kernel"
kernel_version=$(uname -r | cut -d "-" -f 1)
do_version_check 3.10 "$kernel_version"
if [ $? -eq 11 ]; then
  warn "$check_num" "$check_desc"
else
  pass "$check_num" "$check_desc"
fi

# 1.5
check_num="1.5"
check_desc="Remove all non-essential services from the host - Network"
# Check for listening network services.
listening_services=$(netstat -na | grep -v tcp6 | grep -v unix | grep -c LISTEN)
if [ "$listening_services" -eq 0 ]; then
  warn "$check_num" "$check_desc" "Failed to get listening services for check"
else
  if [ "$listening_services" -gt 5 ]; then
    warn "$check_num" "$check_desc" "Host listening on: $listening_services ports"
  else
    pass "$check_num" "$check_desc"
  fi
fi

# 1.6
check_num="1.6"
check_desc="Keep Docker up to date"
docker_version=$(docker version | grep -i -A1 '^server' | grep -i 'version:' \
  | awk '{print $NF; exit}' | tr -d '[:alpha:]-,')
docker_current_version="1.8.0"
do_version_check "$docker_current_version" "$docker_version"
if [ $? -eq 11 ]; then
  warn "$check_num" "$check_desc" "Using $docker_version, when $docker_current_version is current."
else
  pass "$check_num" "$check_desc"
fi

# 1.7
check_num="1.7"
check_desc="Only allow trusted users to control Docker daemon"
docker_users=$(grep docker /etc/group)
for u in $docker_users; do
  user_list=$user_list $u
done
info "$check_num" "$check_desc" "$user_list"

# 1.8
check_num="1.8"
check_desc="Audit docker daemon"
command -v auditctl >/dev/null 2>&1
if [ $? -eq 0 ]; then
  auditctl -l | grep /usr/bin/docker >/dev/null 2>&1
  if [ $? -eq 0 ]; then
    pass "$check_num" "$check_desc"
  else
    warn "$check_num" "$check_desc"
  fi
else
  warn "$check_num" "$check_desc" "Failed to inspect: auditctl command not found."
fi

# 1.9
check_num="1.9"
check_desc="Audit Docker files and directories - /var/lib/docker"
directory="/var/lib/docker"
if [ -d "$directory" ]; then
  command -v auditctl >/dev/null 2>&1
  if [ $? -eq 0 ]; then
    auditctl -l | grep $directory >/dev/null 2>&1
    if [ $? -eq 0 ]; then
      pass "$check_num" "$check_desc"
    else
      warn "$check_num" "$check_desc"
    fi
  else
    warn "$check_num" "$check_desc" "Failed to inspect: auditctl command not found."
  fi
else
  info "$check_num" "$check_desc" "Directory not found"
fi

# 1.10
check_num="1.10"
check_desc="Audit Docker files and directories - /etc/docker"
directory="/etc/docker"
if [ -d "$directory" ]; then
  command -v auditctl >/dev/null 2>&1
  if [ $? -eq 0 ]; then
    auditctl -l | grep $directory >/dev/null 2>&1
    if [ $? -eq 0 ]; then
      pass "$check_num" "$check_desc"
    else
      warn "$check_num" "$check_desc"
    fi
  else
    warn "$check_num" "$check_desc" "Failed to inspect: auditctl command not found."
  fi
else
  info "$check_num" "$check_desc" "Directory not found"
fi

# 1.11
check_num="1.11"
check_desc="Audit Docker files and directories - docker-registry.service"
file="/usr/lib/systemd/system/docker-registry.service"
if [ -f "$file" ]; then
  command -v auditctl >/dev/null 2>&1
  if [ $? -eq 0 ]; then
    auditctl -l | grep $file >/dev/null 2>&1
    if [ $? -eq 0 ]; then
      pass "$check_num" "$check_desc"
    else
      warn "$check_num" "$check_desc"
    fi
  else
    warn "$check_num" "$check_desc" "Failed to inspect: auditctl command not found."
  fi
else
  info "$check_num" "$check_desc" "File not found"
fi

# 1.12
check_num="1.12"
check_desc="Audit Docker files and directories - docker.service"
file="/usr/lib/systemd/system/docker.service"
if [ -f "$file" ]; then
  command -v auditctl >/dev/null 2>&1
  if [ $? -eq 0 ]; then
    auditctl -l | grep $file >/dev/null 2>&1
    if [ $? -eq 0 ]; then
      pass "$check_num" "$check_desc"
    else
      warn "$check_num" "$check_desc"
    fi
  else
    warn "$check_num" "$check_desc" "Failed to inspect: auditctl command not found."
  fi
else
  info "$check_num" "$check_desc" "File not found"
fi

# 1.13
check_num="1.13"
check_desc="Audit Docker files and directories - /var/run/docker.sock"
file="/var/run/docker.sock"
if [ -e "$file" ]; then
  command -v auditctl >/dev/null 2>&1
  if [ $? -eq 0 ]; then
    auditctl -l | grep $file >/dev/null 2>&1
    if [ $? -eq 0 ]; then
      pass "$check_num" "$check_desc"
    else
      warn "$check_num" "$check_desc"
    fi
  else
    warn "$check_num" "$check_desc" "Failed to inspect: auditctl command not found."
  fi
else
  info "$check_num" "$check_desc" "File not found"
fi

# 1.14
check_num="1.14"
check_desc="Audit Docker files and directories - /etc/sysconfig/docker"
file="/etc/sysconfig/docker"
if [ -f "$file" ]; then
  command -v auditctl >/dev/null 2>&1
  if [ $? -eq 0 ]; then
    auditctl -l | grep $file >/dev/null 2>&1
    if [ $? -eq 0 ]; then
      pass "$check_num" "$check_desc"
    else
      warn "$check_num" "$check_desc"
    fi
  else
    warn "$check_num" "$check_desc" "Failed to inspect: auditctl command not found."
  fi
else
  info "$check_num" "$check_desc" "File not found"
fi

# 1.15
check_num="1.15"
check_desc="Audit Docker files and directories - /etc/sysconfig/docker-network"
file="/etc/sysconfig/docker-network"
if [ -f "$file" ]; then
  command -v auditctl >/dev/null 2>&1
  if [ $? -eq 0 ]; then
    auditctl -l | grep $file >/dev/null 2>&1
    if [ $? -eq 0 ]; then
      pass "$check_num" "$check_desc"
    else
      warn "$check_num" "$check_desc"
    fi
  else
    warn "$check_num" "$check_desc" "Failed to inspect: auditctl command not found."
  fi
else
  info "$check_num" "$check_desc" "File not found"
fi

# 1.16
check_num="1.16"
check_desc="Audit Docker files and directories - /etc/sysconfig/docker-registry"
file="/etc/sysconfig/docker-registry"
if [ -f "$file" ]; then
  command -v auditctl >/dev/null 2>&1
  if [ $? -eq 0 ]; then
    auditctl -l | grep $file >/dev/null 2>&1
    if [ $? -eq 0 ]; then
      pass "$check_num" "$check_desc"
    else
      warn "$check_num" "$check_desc"
    fi
  else
    warn "$check_num" "$check_desc" "Failed to inspect: auditctl command not found."
  fi
else
  info "$check_num" "$check_desc" "File not found"
fi

# 1.17
check_num="1.17"
check_desc="Audit Docker files and directories - /etc/sysconfig/docker-storage"
file="/etc/sysconfig/docker-storage"
if [ -f "$file" ]; then
  command -v auditctl >/dev/null 2>&1
  if [ $? -eq 0 ]; then
    auditctl -l | grep $file >/dev/null 2>&1
    if [ $? -eq 0 ]; then
      pass "$check_num" "$check_desc"
    else
      warn "$check_num" "$check_desc"
    fi
  else
    warn "1.17 - Failed to inspect: auditctl command not found."
  fi
else
  info "$check_num" "$check_desc" "File not found"
fi

# 1.18
check_num="1.18"
check_desc="Audit Docker files and directories - /etc/default/docker"
file="/etc/default/docker"
if [ -f "$file" ]; then
  command -v auditctl >/dev/null 2>&1
  if [ $? -eq 0 ]; then
    auditctl -l | grep $file >/dev/null 2>&1
    if [ $? -eq 0 ]; then
      pass "$check_num" "$check_desc"
    else
      warn "$check_num" "$check_desc"
    fi
  else
    warn "$check_num" "$check_desc" "Failed to inspect: auditctl command not found."
  fi
else
  info "$check_num" "$check_desc" "File not found"
fi

# close section  
section_end "$section_num" "$section_desc"