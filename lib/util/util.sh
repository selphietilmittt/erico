
#bash
cd `dirname $0`
getconf="../util/getconf.sh"
DATADIR=`./$getconf DATADIR`


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
	following_filename="$DATADIR/`tail -n 1 $FILELIST`.csv"
	if [ `../util/check_file_exists.sh $following_filename > /dev/null 2>&1` ];then
		exit 1
	else
		echo $following_filename
	fi
}

function cut_filedata() { #return cut filename
	target_file_name=$1
	START_OF_RANKING=`./$getconf START_OF_RANKING`
	END_OF_RANKING=`./$getconf END_OF_RANKING`
	head -n $END_OF_RANKING $target_file_name | tail -n `expr $END_OF_RANKING - $START_OF_RANKING + 1` > cut.csv
	echo cut.csv
}
