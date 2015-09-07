#!/bin/sh

logit "\n"
section_num="2"
section_desc="Docker Daemon Configuration"

section_start "$section_num" "$section_desc"

# 2.1
check_num="2.1"
check_desc="Do not use lxc execution driver"
get_command_line_args docker | grep lxc >/dev/null 2>&1
if [ $? -eq 0 ]; then
  warn "$check_num" "$check_desc"
else
  pass "$check_num" "$check_desc"
fi

# 2.2
check_num="2.2"
check_desc="Restrict network traffic between containers"
get_command_line_args docker | grep "icc=false" >/dev/null 2>&1 
if [ $? -eq 0 ]; then
  pass "$check_num" "$check_desc"
else
  warn "$check_num" "$check_desc"
fi

# 2.3
check_num="2.3"
check_desc="Set the logging level"
get_command_line_args docker | grep "log-level=\"debug\"" >/dev/null 2>&1
if [ $? -eq 0 ]; then
  warn "$check_num" "$check_desc"
else
  pass "$check_num" "$check_desc"
fi

# 2.4
check_num="2.4"
check_desc="Allow Docker to make changes to iptables"
get_command_line_args docker | grep "iptables=false" >/dev/null 2>&1
if [ $? -eq 0 ]; then
  warn "$check_num" "$check_desc"
else
  pass "$check_num" "$check_desc"
fi

# 2.5
check_num="2.5"
check_desc="Do not use insecure registries"
get_command_line_args docker | grep "insecure-registry" >/dev/null 2>&1
if [ $? -eq 0 ]; then
  warn "$check_num" "$check_desc"
else
  pass "$check_num" "$check_desc"
fi

# 2.6
check_num="2.6"
check_desc="Setup a local registry mirror"
get_command_line_args docker | grep "registry-mirror" >/dev/null 2>&1
if [ $? -eq 0 ]; then
  pass "$check_num" "$check_desc"
else
  info "$check_num" "$check_desc" "No local registry currently configured"
fi

# 2.7
check_num="2.7"
check_desc="Do not use the aufs storage driver"
docker info 2>/dev/null | grep -e "^Storage Driver:\s*aufs\s*$" >/dev/null 2>&1
if [ $? -eq 0 ]; then
  warn "$check_num" "$check_desc"
else
  pass "$check_num" "$check_desc"
fi

# 2.8
check_num="2.8"
check_desc="Do not bind Docker to another IP/Port or a Unix socket"
get_command_line_args docker | grep "\-H" >/dev/null 2>&1
if [ $? -eq 0 ]; then
  info "$check_num" "$check_desc" "Docker daemon running with -H"
else
  pass "$check_num" "$check_desc"
fi

# 2.9
check_num="2.9"
check_desc="Configure TLS authentication for Docker daemon"
get_command_line_args docker | grep "\-H" >/dev/null 2>&1
if [ $? -eq 0 ]; then
  get_command_line_args docker | grep "tlsverify" | grep "tlskey" >/dev/null 2>&1
  if [ $? -eq 0 ]; then
    pass "$check_num" "$check_desc" "Docker daemon currently listening on TCP"
  else
    warn "$check_num" "$check_desc" "Docker daemon currently listening on TCP without --tlsverify"
  fi
else
  info "$check_num" "$check_desc" "Docker daemon not listening on TCP"
fi

# 2.10
check_num="2.10"
check_desc="Set default ulimit as appropriate"
get_command_line_args docker | grep "default-ulimit" >/dev/null 2>&1
if [ $? -eq 0 ]; then
  pass "$check_num" "$check_desc"
else
  info "$check_num" "$check_desc" "Default ulimit doesn't appear to be set"
fi

# close section  
section_end "$section_num" "$section_desc"