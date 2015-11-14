
##zsh
## calc_speedph/calc_speedph.sh
## if arg[1] == all;then calculate speed/h by all of data/null-hourly-filelist
## if arg[1] == latest;then calculate speed/h by latest two files of data/null-hourly-filelist
cd `dirname $0`
DATADIR="../../data"
FILELIST="$DATADIR/null-hourly-filelist.txt"
CALCMODE=$1

if [ `../util/check_file_exists.sh $FILELIST > /dev/null 2>&1` ];then
	exit 1
fi

function get_previousfile() { #return filename
	if [ `../util/check_file_exists.sh $FILELIST > /dev/null 2>&1` ];then
 		exit 1
	 fi
	echo "`tail -n 2 $FILELIST  | head -n 1`"
}

function get_currentfile() { #return filename
	if [ `../util/check_file_exists.sh $FILELIST > /dev/null 2>&1` ];then
 		exit 1
	fi
	echo "`tail -n 1 $FILELIST`"
}

if [ -z $CALCMODE ];then
	echo "CALCMODE is EMPTY. please set all or latest"
	exit 1
elif [ $CALCMODE == "all" ];then
	echo "all"
elif [ $CALCMODE == "latest" ];then
	echo "latest"
	echo "`get_currentfile` - `get_previousfile`"
	ruby calc_speed.rb `get_previousfile` `get_currentfile`

else
	echo "MODE ERROR[$CALCMODE]"
	exit 1
fi
