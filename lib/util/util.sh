
#bash
#cd `dirname $0`
#getconf="../util/getconf.sh"

function getconf(){
	CONFIG_FILE="../../config.txt"
	ROOTDIR=`cat $CONFIG_FILE | grep ROOTDIR | awk -F " " '{print $2}'`
	cat $CONFIG_FILE | grep $1 | awk -F " " '{print $2}'
	exit 0
}


function get_previous_filename() { #return filename
	NULL_FILELIST=`getconf NULL_FILELIST`
	#echo "$NULL_FILELIST"
	if [ ! -e $NULL_FILELIST ];then
 		exit 1
	 fi
	previous_filename=$DATADIR/`tail -n 2 $NULL_FILELIST | head -n 1`.csv
	if [ ! -e $previous_filename ];then
		exit 1
	else
		echo $previous_filename
	fi
}

function get_latest_filename() { #return filename
	NULL_FILELIST=`getconf NULL_FILELIST`
	if [ ! -e $NULL_FILELIST ];then
 		exit 1
	fi
	latest_filename=$DATADIR/`tail -n 1 $NULL_FILELIST`.csv
	if [ ! -e $latest_filename ];then
		exit 1
	else
		echo $latest_filename
	fi
}

function cut_filedata() { #return cut filename
	target_file_name=$1
	START_OF_RANKING=`getconf START_OF_RANKING`
	END_OF_RANKING=`getconf END_OF_RANKING`
	head -n $END_OF_RANKING $target_file_name | tail -n `expr $END_OF_RANKING - $START_OF_RANKING + 1` > cut.csv
	echo cut.csv
}
