
#bash
#cd `dirname $0`
CONFIG_FILE="../../config.txt"
ROOTDIR=`cat $CONFIG_FILE | grep ROOTDIR | awk -F " " '{print $2}'`
cat $CONFIG_FILE | grep $1 | awk -F " " '{print $2}'
#if getconf is null->?
exit 0
