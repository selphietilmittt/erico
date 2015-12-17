
# bash
cd `dirname $0`
source "../util/util.sh"
log_info "merge_all_minitely_files.sh start arg[1]=$1"

function extract_number () {
	num=`echo $line | awk -F ',' '{print $4}' | sed -e 's/[^0-9]//g'`
	line=`echo $line | awk -F ',' '{print $1","$2","$3}'`
	echo "$line,$num"
	#num=`echo $line | awk -F ',' '{print $4}'`
	#echo $line | awk -F ',' 'print $1'
	#echo $num | sed -e 's/[^0-9]//g'
}

function merge_all_minitely_files () {
	log_info "merge_all_minitely_files start. HTML_DIR=$1"
	HTML_DIR=$1
	MERGED_FILE="$HTML_DIR/"`getconf NULL_MERGED_MINITELY_FILE`
	:>$MERGED_FILE #initialize
	#ls $HTML_DIR
	#echo $HTML_DIR
	#ls $HTML_DIR
	#echo $MERGED_FILE

	## set time
	y=`echo ${HTML_DIR: -15:4}`
	mo=`echo ${HTML_DIR: -11:2}`
	d=`echo ${HTML_DIR: -9:2}`
	h=`echo ${HTML_DIR: -6:2}`
	min=`echo ${HTML_DIR: -4:2}`
	s=`echo ${HTML_DIR: -2:2}`	
	time="$y/$mo/$d $h:$min:$s"
	log_info "set time[$time]"
	echo ",,$time," >> $MERGED_FILE

	#set TOPPICKUPNAME only frame
	echo TARGET >> $MERGED_FILE
	TOPPICKUPNAME_FILE=`getconf PROFILE_TOPPICKUPNAME`
	log_info "set toppickupname[$TOPPICKUPNAME_FILE]"
	cat $TOPPICKUPNAME_FILE | while read name;do
		echo $name >> $MERGED_FILE
		echo "" >> $MERGED_FILE # space for num
		echo "" >> $MERGED_FILE # space for speed
	done

	#set ALL_MEMBERS_RANKING_LIST
	echo ALL >> $MERGED_FILE
	category=ALL_MEMBERS_RANKING
	target_filelist="$HTML_DIR/"`getconf $category"_LIST"`
	cat $target_filelist | while read filename; do
		cat $filename.csv | while read line; do
			extract_number $line >> $MERGED_FILE
		done
	done

	#set BOTTOMPICKUPNAME
	echo TARGET >> $MERGED_FILE
	BOTTOMPICKUPNAME_FILE=`getconf PROFILE_BOTTOMPICKUPNAME`
	log_info "set bottompickupname[$BOTTOMPICKUPNAME_FILE]"
	cat $BOTTOMPICKUPNAME_FILE | while read name;do
		echo $name >> $MERGED_FILE
		echo "" >> $MERGED_FILE
		echo "" >> $MERGED_FILE
	done

	#set BORDER
	echo BORDER >> $MERGED_FILE
	category=BORDER_OF_RANKING
	target_filelist="$HTML_DIR/"`getconf $category"_LIST"`
	cat $target_filelist | while read filename; do
		ranking=`echo $filename | awk -F $category '{print $2}'`
		line_num=`expr $ranking % 30`
		if [ $line_num = 0 ];then line_num=30; fi
		line=`head -n $line_num $filename.csv | tail -n 1`
		num=`echo $line | awk -F ',' '{print $4}' | sed -e 's/[^0-9]//g'`
		log_info "ranking=$ranking, line_num=$line_num, num=$num"
		if [ -z $num ];then
			echo "$ranking位,,$ranking位,0" >> $MERGED_FILE
		else
			echo "$ranking位,,$ranking位,$num" >> $MERGED_FILE
		fi
	done

	#set GUILD_MEMBERS_RANKING_LIST
	echo `getconf GUILD_ID` >> $MERGED_FILE
	category=GUILD_MEMBERS_RANKING
	target_filelist="$HTML_DIR/"`getconf $category"_LIST"`
	cat $target_filelist | while read filename; do
		cat $filename.csv | while read line; do
			extract_number $line >> $MERGED_FILE
		done
	done

	#set TOPPICKUPNAME only frame
	START_OF_TOP_PICKUP_NAME=`getconf START_OF_TOP_PICKUP_NAME`
	END_OF_TOP_PICKUP_NAME=`getconf END_OF_TOP_PICKUP_NAME`
	START_OF_RANKING=`getconf START_OF_RANKING`
	END_OF_RANKING=`getconf END_OF_RANKING`
	#head -n $END_OF_TOP_PICKUP_NAME $MERGED_FILE | tail -n `expr $END_OF_TOP_PICKUP_NAME - $START_OF_TOP_PICKUP_NAME + 1`
	
	echo $MERGED_FILE
}


if [ -z $1 ];then
	log_fatal "[merge_all_minitely_files.sh] CALCMODE is EMPTY"
	exit 1

elif [ $1 = "all" ];then
	log_info "CALCMODE[all]"
	mea

elif [ $1 = "latest" ];then
	log_info "CALCMODE[latest]"
	
elif [[ $1 =~ ^[0-9]{8}"-"[0-9]{6} ]];then
	log_info "CALCMODE[target($1)]"
	HTML_DIR=`getconf HTMLDIR`/$1
	merge_all_minitely_files $HTML_DIR

else
	log_fatal "[merge_all_minitely_files.sh] MODE ERROR[$1]"
	exit 1
fi


exit 0
