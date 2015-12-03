
#bash
cd `dirname $0`
source "../lib/util/util.sh"
function getconf_delete() { getconf "$1" "../etc/configure.txt";}
function log_info_delete() { log_info "$1" "../etc/log";}

ROOTDIR=`getconf_delete ROOTDIR`
DATADIR="$ROOTDIR/data"
OUTPUTDIR="$ROOTDIR/output"

rm -rf $DATADIR/*
rm -rf $OUTPUTDIR/*
