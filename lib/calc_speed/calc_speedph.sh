
##bash
## calc_speedph/calc_speedph.sh
## if arg[1] == all;then calculate speed/h by all of data/null-hourly-filelist
## if arg[1] == latest;then calculate speed/h by latest two files of data/null-hourly-filelist
cd `dirname $0`
source "../util/util.sh"
log_info "calc_speedph.sh start arg[1]=$1"

DATADIR=`getconf DATADIR`
OUTPUTDIR=`getconf OUTPUTDIR`
FILELIST="$DATADIR/null-hourly-filelist.txt"

if [ ! -d $OUTPUTDIR ];then
	mkdir $OUTPUTDIR
fi

CALCMODE=$1

if [ `../util/check_file_exists.sh $FILELIST > /dev/null 2>&1` ];then
	exit 1
fi

function get_previous_filename() { #return filename
	if [ ! -e "$FILELIST" ];then
 		exit 1
	 fi
	previous_filename="$DATADIR/`tail -n 2 $FILELIST  | head -n 1`.csv"
	if [ ! -e "$previous_filename" ];then
		log_fatal "cannot get previous_filename"
		exit 1
	else
		echo $previous_filename
	fi
}

function get_following_filename() { #return filename
	if [ ! -e "$FILELIST" ];then
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
	log_info "cut_filedata start argv[1]=$1"
	target_file_name=$1
	START_OF_RANKING=`getconf START_OF_RANKING`
	END_OF_RANKING=`getconf END_OF_RANKING`
	head -n $END_OF_RANKING $target_file_name | tail -n `expr $END_OF_RANKING - $START_OF_RANKING + 1` > cut.csv
	echo cut.csv
}


if [ -z $CALCMODE ];then
	echo "CALCMODE is EMPTY. please set all or latest"
	exit 1
elif [ $CALCMODE == "all" ];then
	echo "all"
	if [ -e $OUTPUTDIR/"speed.csv" ];then
		mv $OUTPUTDIR/"speed.csv" $OUTPUTDIR/"speed.csv.1"
	fi

	previous_filename=$DATADIR/"null"
	cat $FILELIST | while read line; do
	following_filename=$DATADIR/$line".csv"	
		if [ ${#line} -eq 0 ]; then
			echo "empty"
			:
		elif [ -e $previous_filename ];then
			echo "$previous_filename exists"

			cut_file=`cut_filedata $previous_filename`
			mv $cut_file previous_file.csv
			cut_file=`cut_filedata $following_filename`
			mv $cut_file following_file.csv
			following_time=` head -n 1 $following_filename`
			echo $following_time > output_file.csv # create only timestamp file
			ruby calc_speed.rb previous_file.csv following_file.csv output_file.csv
			cat output_file.csv >> $OUTPUTDIR/"speed.csv"
		fi
		previous_filename=$DATADIR/$line".csv"
	done
elif [ $CALCMODE == "latest" ];then
	log_info "CALC_MODE=latest"
	following_filename=`get_following_filename`
	log_info "following_filename=$following_filename"

	if [ `../util/check_file_exists.sh output_file.csv > /dev/null 2>&1` ];then
		touch output_file.csv
	fi

	following_file_timestamp=`head -n 1 $following_filename`
	output_file_timestamp=`head -n 1 output_file.csv`
	log_info "folowing_file_timestamp=$following_file_timestamp"
	log_info "output_file_timestamp=$output_file_timestamp"
	#if [ "$following_file_timestamp" == "$output_file_timestamp" ];then
	#	echo "same nothing to do"
	#	exit 0
	#fi

	previous_filename=`get_previous_filename`
	log_info "previous_filename=$previous_filename"
	following_time=` head -n 1 $following_filename`
	log_info "following_time=$following_time"
	cut_file=`cut_filedata $previous_filename`
	mv $cut_file previous_file.csv
	cut_file=`cut_filedata $following_filename`
	mv $cut_file following_file.csv
	echo $following_time > output_file.csv # create only timestamp file
	ruby calc_speed.rb previous_file.csv following_file.csv output_file.csv
	#cat output_file
	cat output_file.csv >> $OUTPUTDIR/"speed.csv"

else
	log_fatal "MODE ERROR[$CALCMODE]"
	exit 1
fi
