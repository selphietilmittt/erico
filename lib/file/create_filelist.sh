
# bash

cd `dirname $0`
source "../util/util.sh"
log_info "create_filelist.sh start arg[1]=$1"

DATADIR=`getconf DATADIR`

if [ -z $1 ];then
	log_fatal "[create_filelist.sh] CALCMODE is EMPTY"
	exit 1

elif [ $1 = "null" ];then
	FILELIST=`getconf NULL_FILELIST`
	log_info "CALCMODE[null]. create $FILELIST start"
	:>$FILELIST #initialize
	ls $DATADIR | grep -E null-[0-9]{8}-[0-9]{6}.csv | while read filename; do
		echo $filename | awk -F '.' '{print $1}' >> $FILELIST
	done
else
	FILELIST="$DATADIR/$1"`getconf ALL_FILELIST_SUFFIX`
	log_info "CALCMODE[$1]. create $FILELIST start"
	exit 1
fi

cat $FILELIST

exit 0



