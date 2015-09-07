#!/bin/sh
bldred='\033[1;31m'
bldgrn='\033[1;32m'
bldblu='\033[1;34m'
bldylw='\033[1;33m' # Yellow
txtrst='\033[0m'
first_element=false

logit () {
  if [ "x$output" != "xJSON" ]; then
    printf "%b\n" "$1" | tee -a "$logger"
  fi
}

info () {
  if [ "x$output" = "xJSON" ]; then
    if [ "$first_element" != true ]; then
      printf ","
    else
      first_element=false
    fi
    printf "{\"result\":\"warn\", \"check_number\":\"$1\", \"check_desc\":\"$2\", \"check_data\":\"$3\"}"
  else
    printf "%b\n" "${bldblu}[INFO]${txtrst} $1 - $2" | tee -a "$logger"
    if [ "$3" != "" ]; then
      printf "%b\n" "${bldblu}[INFO]${txtrst}      * $3" | tee -a "$logger"
    fi
  fi
}

pass () {
  if [ "x$output" = "xJSON" ]; then
    if [ "$first_element" != true ]; then
      printf ","
    else
      first_element=false
    fi
    printf "{\"result\":\"pass\", \"check_number\":\"$1\", \"check_desc\":\"$2\"}"
  else
    printf "%b\n" "${bldgrn}[PASS]${txtrst} $1 - $2" | tee -a "$logger"
  fi
}

warn () {  
  if [ "x$output" = "xJSON" ]; then
    if [ "$first_element" != true ]; then
      printf ","
    else
      first_element=false
    fi
    printf "{\"result\":\"warn\", \"check_number\":\"$1\", \"check_desc\":\"$2\", \"check_data\":\"$3\"}"
  else
    printf "%b\n" "${bldred}[WARN]${txtrst} $1 - $2" | tee -a "$logger"
    if [ "$3" != "" ]; then
      printf "%b\n" "${bldred}[WARN]${txtrst}      * $3" | tee -a "$logger"
    fi
  fi
}

section_start() {
  if [ "x$output" = "xJSON" ]; then
    printf "{\"section\":\"$1\", \"desc\": \"$2\", \"results\":["
    first_element=true
  else
    printf "%b\n" "${bldblu}[INFO]${txtrst} $1 - $2" | tee -a "$logger"
  fi
}

section_end() {
  if [ "x$output" = "xJSON" ]; then
    printf "]}"
  fi
}

yell () {
  if [ "x$output" != "xJSON" ]; then
    printf "%b\n" "${bldylw}$1${txtrst}\n"
  fi
}
