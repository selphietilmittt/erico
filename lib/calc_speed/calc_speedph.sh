
##zsh
## calc_speedph/calc_speedph.sh
## if arg[1] == all;then calculate speed/h by all of data/null-hourly-filelist
## if arg[1] == latest;then calculate speed/h by latest two files of data/null-hourly-filelist
cd `dirname $0`
DATADIR=`pwd`"/../../data"
FILELIST="$DATADIR/null-hourly-filelist.txt"
CONFIG="../../config"

CALCMODE=$1

if [ `../util/check_file_exists.sh $FILELIST > /dev/null 2>&1` ];then
	exit 1
fi

function get_previous_filename() { #return filename
	if [ `../util/check_file_exists.sh $FILELIST > /dev/null 2>&1` ];then
 		exit 1
	 fi
	previous_filename="$DATADIR/`tail -n 2 $FILELIST  | head -n 1`.csv"
	if [ `../util/check_file_exists.sh $previous_filename > /dev/null 2>&1` ];then
		exit 1
	else
		echo $previous_filename
	fi
}

function get_following_filename() { #return filename
	if [ `../util/check_file_exists.sh $FILELIST > /dev/null 2>&1` ];then
 		exit 1
	fi
	following_filename="$DATADIR`tail -n 1 $FILELIST`.csv"
	if [ `../util/check_file_exists.sh $following_filename > /dev/null 2>&1` ];then
		exit 1
	else
		echo $following_filename
	fi
}

function cut_filedata() { #return cut filename
	cat $CONFIG
}


if [ -z $CALCMODE ];then
	echo "CALCMODE is EMPTY. please set all or latest"
	exit 1
elif [ $CALCMODE == "all" ];then
	echo "all"
elif [ $CALCMODE == "latest" ];then
	echo "latest"
	previous_filename=`get_previous_filename`
	following_filename=`get_following_filename`
	echo $previous_filename
	echo $following_filename
	echo `cut_filedata $previous_filename`
	#ruby calc_speed.rb `get_previousfile` `get_currentfile`

else
	echo "MODE ERROR[$CALCMODE]"
	exit 1
fi
