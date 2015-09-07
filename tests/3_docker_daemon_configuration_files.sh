#!/bin/sh

logit "\n"
section_num="3"
section_desc="Docker Daemon Configuration Files"

section_start "$section_num" "$section_desc"

# 3.1
check_num="3.1"
check_desc="Verify that docker.service file ownership is set to root:root"
file="/usr/lib/systemd/system/docker.service"
if [ -f "$file" ]; then
  if [ "$(stat -c %u%g $file)" -eq 00 ]; then
    pass "$check_num" "$check_desc"
  else
    warn "$check_num" "$check_desc" "Wrong ownership for $file"
  fi
else
  info "$check_num" "$check_desc" "File not found"
fi

# 3.2
check_num="3.2"
check_desc="Verify that docker.service file permissions are set to 644"
file="/usr/lib/systemd/system/docker.service"
if [ -f "$file" ]; then
  if [ "$(stat -c %a $file)" -eq 644 ]; then
    pass "$check_num" "$check_desc"
  else
    warn "$check_num" "$check_desc" "Wrong permissions for $file"
  fi
else
  info "$check_num" "$check_desc" "File not found"
fi

# 3.3
check_num="3.3"
check_desc="Verify that docker-registry.service file ownership is set to root:root"
file="/usr/lib/systemd/system/docker-registry.service"
if [ -f "$file" ]; then
  if [ "$(stat -c %u%g $file)" -eq 00 ]; then
    pass "$check_num" "$check_desc"
  else
    warn "$check_num" "$check_desc" "Wrong ownership for $file"
  fi
else
  info "$check_num" "$check_desc" "File not found"
fi

# 3.4
check_num="3.4"
check_desc="Verify that docker-registry.service file permissions are set to 644"
file="/usr/lib/systemd/system/docker-registry.service"
if [ -f "$file" ]; then
  if [ "$(stat -c %a $file)" -eq 644 ]; then
    pass "$check_num" "$check_desc"
  else
    warn "$check_num" "$check_desc" "Wrong permissions for $file"
  fi
else
  info "$check_num" "$check_desc" "File not found"
fi

# 3.5
check_num="3.5"
check_desc="Verify that docker.socket file ownership is set to root:root"
file="/usr/lib/systemd/system/docker.socket"
if [ -f "$file" ]; then
  if [ "$(stat -c %u%g $file)" -eq 00 ]; then
    pass "$check_num" "$check_desc"
  else
    warn "$check_num" "$check_desc" "Wrong ownership for $file"
  fi
else
  info "$check_num" "$check_desc" "File not found"
fi

# 3.6
check_num="3.6"
check_desc="Verify that docker.socket file permissions are set to 644"
file="/usr/lib/systemd/system/docker.socket"
if [ -f "$file" ]; then
  if [ "$(stat -c %a $file)" -eq 644 ]; then
    pass "$check_num" "$check_desc"
  else
    warn "$check_num" "$check_desc" "Wrong permissions for $file"
  fi
else
  info "$check_num" "$check_desc" "File not found"
fi

# 3.7
check_num="3.7"
check_desc="Verify that Docker environment file ownership is set to root:root "
file="/etc/sysconfig/docker"
if [ -f "$file" ]; then
  if [ "$(stat -c %u%g $file)" -eq 00 ]; then
    pass "$check_num" "$check_desc"
  else
    warn "$check_num" "$check_desc" "Wrong ownership for $file"
  fi
else
  info "$check_num" "$check_desc" "File not found"
fi

# 3.8
check_num="3.8"
check_desc="Verify that Docker environment file permissions are set to 644"
file="/etc/sysconfig/docker"
if [ -f "$file" ]; then
  if [ "$(stat -c %a $file)" -eq 644 ]; then
    pass "$check_num" "$check_desc"
  else
    warn "$check_num" "$check_desc" "Wrong permissions for $file"
  fi
else
  info "$check_num" "$check_desc" "File not found"
fi

# 3.9
check_num="3.9"
check_desc="Verify that docker-network environment file ownership is set to root:root"
file="/etc/sysconfig/docker-network"
if [ -f "$file" ]; then
  if [ "$(stat -c %u%g $file)" -eq 00 ]; then
    pass "$check_num" "$check_desc"
  else
    warn "$check_num" "$check_desc" "Wrong ownership for $file"
  fi
else
  info "$check_num" "$check_desc" "File not found"
fi

# 3.10
check_num="3.10"
check_desc="Verify that docker-network environment file permissions are set to 644"
file="/etc/sysconfig/docker-network"
if [ -f "$file" ]; then
  if [ "$(stat -c %a $file)" -eq 644 ]; then
    pass "$check_num" "$check_desc"
  else
    warn "$check_num" "$check_desc" "Wrong permissions for $file"
  fi
else
  info "$check_num" "$check_desc" "File not found"
fi

# 3.11
check_num="3.11"
check_desc="Verify that docker-registry environment file ownership is set to root:root"
file="/etc/sysconfig/docker-registry"
if [ -f "$file" ]; then
  if [ "$(stat -c %u%g $file)" -eq 00 ]; then
    pass "$check_num" "$check_desc"
  else
    warn "$check_num" "$check_desc" "Wrong ownership for $file"
  fi
else
  info "$check_num" "$check_desc" "File not found"
fi

# 3.12
check_num="3.12"
check_desc="Verify that docker-registry environment file permissions are set to 644"
file="/etc/sysconfig/docker-registry"
if [ -f "$file" ]; then
  if [ "$(stat -c %a $file)" -eq 644 ]; then
    pass "$check_num" "$check_desc"
  else
    warn "$check_num" "$check_desc" "Wrong permissions for $file"
  fi
else
  info "$check_num" "$check_desc" "File not found"
fi

# 3.13
check_num="3.13"
check_desc="Verify that docker-storage environment file ownership is set to root:root"
file="/etc/sysconfig/docker-storage"
if [ -f "$file" ]; then
  if [ "$(stat -c %u%g $file)" -eq 00 ]; then
    pass "$check_num" "$check_desc"
  else
    warn "$check_num" "$check_desc" "Wrong ownership for $file"
  fi
else
  info "$check_num" "$check_desc" "File not found"
fi

# 3.14
check_num="3.14"
check_desc="Verify that docker-storage environment file permissions are set to 644"
file="/etc/sysconfig/docker-storage"
if [ -f "$file" ]; then
  if [ "$(stat -c %a $file)" -eq 644 ]; then
    pass "$check_num" "$check_desc"
  else
    warn "$check_num" "$check_desc" "Wrong permissions for $file"
  fi
else
  info "$check_num" "$check_desc" "File not found"
fi

# 3.15
check_num="3.15"
check_desc="Verify that /etc/docker directory ownership is set to root:root"
directory="/etc/docker"
if [ -d "$directory" ]; then
  if [ "$(stat -c %u%g $directory)" -eq 00 ]; then
    pass "$check_num" "$check_desc"
  else
    warn "$check_num" "$check_desc" "Wrong ownership for $directory"
  fi
else
  info "$check_num" "$check_desc" "Directory not found"
fi

# 3.16
check_num="3.16"
check_desc="Verify that /etc/docker directory permissions are set to 755"
directory="/etc/docker"
if [ -d "$directory" ]; then
  if [ "$(stat -c %a $directory)" -eq 755 ]; then
    pass "$check_num" "$check_desc"
  elif [ "$(stat -c %a $directory)" -eq 700 ]; then
    pass "$check_num" "$check_desc"
  else
    warn "$check_num" "$check_desc" "Wrong permissions for $directory"
  fi
else
  info "$check_num" "$check_desc" "Directory not found"
fi

# 3.17
check_num="3.17"
check_desc="Verify that registry certificate file ownership is set to root:root"
directory="/etc/docker/certs.d/"
if [ -d "$directory" ]; then
  fail=0
  owners=$(ls -lL $directory | grep ".crt" | awk '{print $3, $4}')
  for p in $owners; do
    printf "%s" "$p" | grep "root" >/dev/null 2>&1
    if [ $? -ne 0 ]; then
      fail=1
    fi
  done
  if [ $fail -eq 1 ]; then
    warn "$check_num" "$check_desc" "Wrong ownership for $directory"
  else
    pass "$check_num" "$check_desc"
  fi
else
  info "$check_num" "$check_desc" "Directory not found"
fi

# 3.18
check_num="3.18"
check_desc="Verify that registry certificate file permissions are set to 444"
directory="/etc/docker/certs.d/"
if [ -d "$directory" ]; then
  fail=0
  perms=$(ls -lL $directory | grep ".crt" | awk '{print $1}')
  for p in $perms; do
    if [ "$p" != "-r--r--r--." -a "$p" = "-r--------." ]; then
      fail=1
    fi
  done
  if [ $fail -eq 1 ]; then
    warn "$check_num" "$check_desc" "Wrong permissions for $directory"
  else
    pass "$check_num" "$check_desc"
  fi
else
  info "$check_num" "$check_desc" "Directory not found"
fi

# 3.19
check_num="3.19"
check_desc="Verify that TLS CA certificate file ownership is set to root:root"
tlscacert=$(get_command_line_args docker | sed -n 's/.*tlscacert=\([^s]\)/\1/p' | sed 's/--/ --/g' | cut -d " " -f 1)
if [ -f "$tlscacert" ]; then
  if [ "$(stat -c %u%g "$tlscacert")" -eq 00 ]; then
    pass "$check_num" "$check_desc"
  else
    warn "$check_num" "$check_desc" "Wrong ownership for $tlscacert"
  fi
else
  info "$check_num" "$check_desc" "No TLS CA certificate found"
fi

# 3.20
check_num="3.20"
check_desc="Verify that TLS CA certificate file permissions are set to 444"
tlscacert=$(get_command_line_args docker | sed -n 's/.*tlscacert=\([^s]\)/\1/p' | sed 's/--/ --/g' | cut -d " " -f 1)
if [ -f "$tlscacert" ]; then
  perms=$(ls -ld "$tlscacert" | awk '{print $1}')
  if [ "$perms" = "-r--r--r--" ]; then
    pass "$check_num" "$check_desc"
  else
    warn "$check_num" "$check_desc" "Wrong permissions for $tlscacert"
  fi
else
  info "$check_num" "$check_desc" "No TLS CA certificate found"
fi

# 3.21
check_num="3.21"
check_desc="Verify that Docker server certificate file ownership is set to root:root"
tlscert=$(get_command_line_args docker | sed -n 's/.*tlscert=\([^s]\)/\1/p' | sed 's/--/ --/g' | cut -d " " -f 1)
if [ -f "$tlscert" ]; then
  if [ "$(stat -c %u%g "$tlscert")" -eq 00 ]; then
    pass "$check_num" "$check_desc"
  else
    warn "$check_num" "$check_desc" "Wrong ownership for $tlscert"
  fi
else
  info "$check_num" "$check_desc" "No TLS Server certificate found"
fi

# 3.22
check_num="3.22"
check_desc="Verify that Docker server certificate file permissions are set to 444"
tlscert=$(get_command_line_args docker | sed -n 's/.*tlscert=\([^s]\)/\1/p' | sed 's/--/ --/g' | cut -d " " -f 1)
if [ -f "$tlscert" ]; then
  perms=$(ls -ld "$tlscert" | awk '{print $1}')
  if [ "$perms" = "-r--r--r--" ]; then
    pass "$check_num" "$check_desc"
  else
    warn "$check_num" "$check_desc" "Wrong permissions for $tlscert"
  fi
else
  info "$check_num" "$check_desc" "No TLS Server certificate found"
fi

# 3.23
check_num="3.23"
check_desc="Verify that Docker server key file ownership is set to root:root"
tlskey=$(get_command_line_args docker | sed -n 's/.*tlskey=\([^s]\)/\1/p' | sed 's/--/ --/g' | cut -d " " -f 1)
if [ -f "$tlskey" ]; then
  if [ "$(stat -c %u%g "$tlskey")" -eq 00 ]; then
    pass "$check_num" "$check_desc"
  else
    warn "$check_num" "$check_desc" "Wrong ownership for $tlskey"
  fi
else
  info "$check_num" "$check_desc" "No TLS Key found"
fi

# 3.24
check_num="3.24"
check_desc="Verify that Docker server key file permissions are set to 400"
tlskey=$(get_command_line_args docker | sed -n 's/.*tlskey=\([^s]\)/\1/p' | sed 's/--/ --/g' | cut -d " " -f 1)
if [ -f "$tlskey" ]; then
  perms=$(ls -ld "$tlskey" | awk '{print $1}')
  if [ "$perms" = "-r--------" ]; then
    pass "$check_num" "$check_desc"
  else
    warn "$check_num" "$check_desc" "Wrong permissions for $tlskey"
  fi
else
  info "$check_num" "$check_desc" "No TLS Key found"
fi

# 3.25
check_num="3.25"
check_desc="Verify that Docker socket file ownership is set to root:docker"
file="/var/run/docker.sock"
if [ -f "$file" ]; then
  if [ "$(stat -c %u%g $file)" -eq 00 ]; then
    pass "$check_num" "$check_desc"
  else
    warn "$check_num" "$check_desc" "Wrong ownership for $file"
  fi
else
  info "$check_num" "$check_desc" "File not found"
fi

# 3.26
check_num="3.26"
check_desc="Verify that Docker socket file permissions are set to 660"
file="/var/run/docker.sock"
if [ -f "$file" ]; then
  perms=$(ls -ld "$file" | awk '{print $1}')
  if [ "$perms" = "srw-rw----" ]; then
    pass "$check_num" "$check_desc"
  else
    warn "$check_num" "$check_desc" "Wrong permissions for $file"
  fi
else
  info "$check_num" "$check_desc" "File not found"
fi


section_end "$section_num" "$section_desc"