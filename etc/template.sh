#bash
cd `dirname $0`
source "../util/util.sh"
log_info "**.sh start"
CONFIG_FILE=`getconf CONFIG_FILE`
HTMLDIR=`getconf HTMLDIR`

if [ -z $1 ];then
	log_fatal "[**.sh] CALCMODE is EMPTY"
	exit 1

elif [ $1 = "all" ];then
	log_info "CALCMODE[all]"

elif [ $1 = "latest" ];then
	log_info "CALCMODE[latest]"
	
elif [ $1 = "target" ];then
	log_info "CALCMODE[target]"
	
else
	log_fatal "[**.sh] MODE ERROR[$1]"
	exit 1
fi


exit 0