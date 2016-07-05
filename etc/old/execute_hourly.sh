#!/bin/bash

cd `dirname $0`
source "lib/util/util.sh"
function getconf_execall() { getconf "$1" "etc/configure.txt";}
function log_info_execall() { log_info "$1" "etc/log";}

log_info_execall "create_hourly_filelist.sh latest start"
bash lib/calc_speed/create_hourly_filelist.sh latest > /dev/null
log_info_execall "calc_speedph.sh latest start"
bash lib/calc_speed/calc_speedph.sh latest > /dev/null

exit 0
