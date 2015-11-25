
#bash
cd `dirname $0`
source "../util/util.sh"

CALCMODE=$1
TARGET_GUILD=$2
log_info "this is calc_defeating_time"
log_info "CALCMODE=$CALCMODE TARGET_GUILD=$TARGET_GUILD"

FILELIST=`getconf NULL_FILELIST`
DATADIR=`getconf DATADIR`
OUTPUTFILE=`getconf DEFEATING_TIME_OF_`"$TARGET_GUILD.csv"
##OUTPUTFILE
## num, NAME, DEFEATING_TIME_OF_
##	1
##	2
##	3
##	:

if [ ! -e $FILELIST ];then
	log_fatal "[[calc_defeating_time.sh]] $FILELIST NOT exists."
	exit 1
fi
if [ -z $TARGET_GUILD ];then
	log_fatal "[[calc_defeating_time.sh]] TARGET_GUILD is EMPTY."
	exit 1
fi


function get_defeated_num(){
	filename=$1
	target_guild=$2
	log_info "[get_defeated_num] filename=$filename target_guild=$target_guild"

	if [ ! -e $filename ];then
		log_fatal "[get_defeated_num] $filename NOT exists"
		exit 1
	fi
	cut_filename=`cut_filedata $filename`
	if [ ! -e $cut_filename ];then
		log_fatal "[get_defeated_num] cut_file $cut_filename NOT exists"
	fi
	defeated_num=`cat $cut_filename | grep $target_guild | awk -F, '{print $2}'`
	log_info "[get_defeated_num] return $defeated_num"
	if [ -z $defeated_num ];then
		log_info "[get_defeated_num] defeated_num is empty. return null"
		defeated_num="null"
	fi
	echo $defeated_num
}

function set_defeating_num_time(){
	filename=$1
	TARGET_GUILD=$2
	defeated_num=$3
	defeating_num=$4
	defeating_time=$5
	log_info "[set_defeating_num_time] filename=$filename target_guild=$TARGET_GUILD"
	if [ -z  $filename -o -z $TARGET_GUILD ];then
		log_warning "[set_defeating_num_time] filename or TARGET_GUILD is EMPTY"
		log_warning "[set_defeating_num_time] filename=$filename target_guild=$target_guild"
	fi
	#renew defeating_num, defeated_num, defeating_time
	defeating_num=`get_defeated_num  $filename $TARGET_GUILD`
	if [ -z "$defeated_num" ];then
		log_warning "[set_defeating_num_time] defeated_num==null"
		log_warning "ted: $defeated_num ting: $defeating_num time: $defeating_time"
	fi
	if [ -z "$defeating_num" ];then
		log_warning "[set_defeating_num_time] defeating_num==null"
		log_warning "ted: $defeated_num ting: $defeating_num time: $defeating_time"
	fi

	if [ "$defeated_num" == "$defeating_num" ];then
		## same boss
		log_info "[set_defeating_num_time] same boss. defeating_time=$defeating_time+1"
		defeating_time=`expr $defeating_time + 1`
	else
		# next boss
		log_info "[set_defeating_num_time]  next boss"
		#echo "tednum: $defeatied_num != tingnum: $defeating_num time: $defeating_time"
		defeated_num=$defeating_num
		defeating_time=1
	fi
}

function fetch_bottom_line(){ #OUTPUTFILE num NAME DEFEATING_TIME_OF_
	OUTPUTFILE=$1
	fetched_defeated_num=$2
	fetched_NAME=$3
	fetched_defeating_time=$4

	log_info "[fetch_bottom_line] OUTPUTFILE=$OUTPUTFILE"
	if [ ! -e $OUTPUTFILE ];then
		log_info "[fetch_bottom_line] OUTPUTFILE NOT exists"
		log_info "[fetch_bottom_line] null,null,0 > $OUTPUTFILE"
		echo "null,null,0" > $OUTPUTFILE
		fetched_defeated_num="null"
		fetched_NAME="null"
		fetched_defeating_time="0"
	else
		log_info "[fetch_bottom_line] OUTPUTFILE exists"
		last_line=`tail -n 1 $OUTPUTFILE`
		log_info "[fetch_bottom_line] last_line=$last_line"
		if [ -z $last_line ];then
			log_info "[fetch_bottom_line] last_line is empty. return null,null,0"
			fetched_defeated_num="null"
			fetched_NAME="null"
			fetched_defeating_time="0"
		elif [ -z `echo $last_line | awk -F "," '{print $1}'` ];then
			log_warning "[fetch_bottom_line] NAME is empty. return null,null,0"
			fetched_defeated_num="null"
			fetched_NAME="null"
			fetched_defeating_time="0"
		else
			log_info "l[fetch_bottom_line] last_line is $last_line"
			echo $last_line | awk -F "," '{\
			 	fetched_defeated_num=$1; \
			 		fetched_NAME=$2; \
			 			fetched_defeating_time=$3}'
			#echo $last_line | awk -F "," '{fetched_defeated_num=$1; print $2; print $3}'
			arr=(`echo $last_line | awk -F "," '{print $1,$2,$3}'`)
			fetched_defeated_num=${arr[0]}
			fetched_NAME=${arr[1]}
			fetched_defeating_time=${arr[2]}
		fi
	fi
	log_info "[fetch_bottom_line]num: $fetched_defeated_num, NAME: $fetched_NAME,time:$fetched_defeating_time"
}


function renew_bottom_of_outputfile(){
	log_info "[renew_bottom_of_outputfile] OUTPUTFILE=$OUTPUTFILE"
	OUTPUTFILE=$1
	defeating_num=$2
	NAME=$3

	log_info "[renew_bottom_of_outputfile]argv... num: $defeating_num, NAME: $fNAME"
	if [ -z $OUTPUTFILE ];then log_fatal "[renew_bottom_of_outputfile]OUTPUTFILE is empty";exit 1; fi
	if [ -z $defeating_num ];then log_fatal "[renew_bottom_of_outputfile]defeating_num is empty";exit 1; fi
	if [ -z $NAME ];then log_fatal "[renew_bottom_of_outputfile]NAME is empty";exit 1; fi

	fetch_bottom_line $OUTPUTFILE $fetched_defeated_num $fetched_NAME $fetched_defeating_time
	log_info "[renew_bottom_of_outputfile]fetched... num: $fetched_defeated_num, NAME: $fetched_NAME,time:$fetched_defeating_time"

	if ! expr "$fetched_defeating_time" : '[0-9]*' > /dev/null ; then
		log_info "[renew_bottom_of_outputfile] fetched_defeating_time $fetched_defeating_time is not num. set 0."
		fetched_defeating_time=0
	fi

	if [ "$fetched_defeated_num" == "null" -o "$fetched_NAME" == "null" ];then
		log_info "[renew_bottom_of_outputfile] fetched_line is null. create new lines with embedding"
		sed -ie '$d' $OUTPUTFILE
		i=1
		until [ $i -eq $defeating_num ];do
			log_info "embed empty num $i with NAME=$NAME, time=0"
			echo "$i,$NAME,0," >> $OUTPUTFILE
			i=`expr $i + 1`
		done
		echo "$defeating_num,$NAME,1," >> $OUTPUTFILE
		log_info "creating a new line finished"
	elif [ "$fetched_NAME" != "$NAME" ];then
		log_fatal "[renew_bottom_of_outputfile]fetched_NAME not equal to $NAME. no action"
		exit 1

	elif [ "$fetched_defeated_num" == "$defeating_num" ];then
		log_info "fetched_defeated_num=defeating_num=$defeating_num. defeating_time=$fetched_defeating_time+1"
		defeating_time=`expr $fetched_defeating_time + 1`
		sed -ie '$d' $OUTPUTFILE
		echo "$defeating_num,$NAME,$defeating_time," >> $OUTPUTFILE
	else
		log_info "[renew_bottom_of_outputfile]else"
		i=`expr $fetched_defeated_num + 1`
		until [ $i -eq $defeating_num ];do
			log_info "embed empty num $i with NAME=$NAME, time=0"
			echo "$i,$NAME,0," >> $OUTPUTFILE
			i=`expr $i + 1`
		done
		log_info "$defeating_num,$NAME,1, >> $OUTPUTFILE"
		echo "$defeating_num,$NAME,1," >> $OUTPUTFILE
	fi
}


#CALCMODE=$1
#TARGET_GUILD=$2
if [ -z $CALCMODE ];then
	echo "calc_defeating_time.sh CALCMODE is EMPTY. please set all or latest"
	exit 1

elif [ $CALCMODE == "all" ];then
	log_info "CALCMODE==all"

	if [ ! -e $OUTPUTFILE ];then
		echo "calc_defeating_time.sh $OUTPUTFILE NOT exists. creating"
		touch $OUTPUTFILE
	else
		rm $OUTPUTFILE
	fi

	defeating_time=1
	defeated_num=0
	cat $FILELIST | while read filename
	do
		#renew defeating_num, defeated_num, defeating_time
		#set_defeating_num_time \
		#	$DATADIR/$filename".csv"\
		#	$TARGET_GUILD \
		#	$defeated_num \
		#	$defeating_num \
		#	$defeating_time
		defeating_num=`get_defeated_num $DATADIR/$filename".csv" $TARGET_GUILD`
		if [ "$defeating_num" == "null" ];then
			log_info "$TARGET_GUILD is out of rank on $filename. no action."
		else
			#echo "$filename :defeating_num = $defeating_num"
			#echo $defeating_time
			renew_bottom_of_outputfile \
				$OUTPUTFILE \
				$defeating_num \
				$TARGET_GUILD
		fi
	done
	log_info "CALCMODE==all finished. nkf from UTF8 to SJIS"
	nkf -s --overwrite $OUTPUTFILE

elif [ $CALCMODE == "latest" ]; then
	log_info "CALCMODE==latest"
	#previous_filename=`get_previous_filename`
	#log_info "[main] previous_filename=$previous_filename"
	latest_filename=`get_latest_filename`
	log_info "[main] latest_filename=$latest_filename"

	#defeating_time=0 #fetch_bottom_line()
	#defeated_num=`get_defeated_num $previous_filename $TARGET_GUILD`
	defeating_num=`get_defeated_num $latest_filename $TARGET_GUILD`

	#set_defeating_num_time \
		#$latest_filename \
		#$TARGET_GUILD \
		#$defeated_num \
		#$defeating_num \
		#$defeating_time

	renew_bottom_of_outputfile \
		$OUTPUTFILE \
		$defeating_num \
		$TARGET_GUILD \

	log_info "CALCMODE==latest finished. nkf from UTF8 to SJIS"
	nkf -s --overwrite $OUTPUTFILE


else
	echo "calc_defeating_time.sh  MODE ERROR[$CALCMODE]"
	exit 1
fi
