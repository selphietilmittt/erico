
# bash
cd `dirname $0`


echo "configure.sh"
#if [ -e configure.sh ];then bash configure.sh > /dev/null 2>&1; fi
bash configure.sh > /dev/null 2>&1

source "lib/util/util.sh"
function getconf_() { cd lib/util/;getconf "$1";cd ../../;}
function log_debug_() { cd lib/util/; log_debug "$1";cd ../../;}
function log_info_() {  cd lib/util/;log_info "$1";cd ../../;}
function log_warning_() {  cd lib/util/;log_warning "$1";cd ../../;}
function log_fatal_() {  cd lib/util/;log_fatal "$1";cd ../../;}

date=`date +%Y%m%d-%H%M%S`
echo -e "execute_all.sh at $date start."
log_info_ "\n\nexecute_all.sh at $date start.\n"

CONFIG_FILE=`getconf_ CONFIG_FILE`
ROOTDIR=`getconf_ ROOTDIR`
DATADIR="$ROOTDIR/data"
OUTPUTDIR="$ROOTDIR/output"
UTILDIR="$ROOTDIR/lib/util"
ETCDIR="$ROOTDIR/etc"

if [ ! -d "$DATADIR" ];then mkdir $DATADIR ; fi
if [ ! -d "$OUTPUTDIR" ];then mkdir $OUTPUTDIR ; fi
if [ ! -d "$UTILDIR" ];then mkdir $UTILDIR ; fi
if [ ! -d "$ETCDIR" ];then mkdir $ETCDIR ; fi

if [ -z $1 ];then
	log_fatal_ "[**.sh] TARGET is EMPTY"
	exit 1
elif [ $1 = "null" ];then
	PREFIX="null"
	FILELIST=$DATADIR/$PREFIX`getconf_ ALL_FILELIST_SUFFIX`
	HOURLYFILELIST=$DATADIR/$PREFIX`getconf_ HOURLYFILELIST_SUFFIX`
	USER_ID=`getconf_ USER_ID`
	GUILD_ID=`getconf_ GUILD_ID`
elif [ $1 = "thomson" ];then
	PREFIX=`getconf_ THOMSON_ID`
	USER_ID=`getconf_ THOMSON_MEMBER_ID`
	GUILD_ID=`getconf_ THOMSON_ID`
elif [ $1 = "doroeri" ];then
	PREFIX=`getconf_ DOROERI_ID`
	USER_ID=`getconf_ DOROERI_MEMBER_ID`
	GUILD_ID=`getconf_ DOROERI_ID`	
else
	log_fatal_ "[execute.sh] MODE ERROR[$1]"
	exit 1
fi
log_info_ "PREFIX=$PREFIX, USER_ID=$USER_ID, GUILD_ID=$GUILD_ID"



cd $ROOTDIR

echo "get_html"
OPERATE_HTML_DIR="$ROOTDIR/lib/html"
HTML_DIR=`getconf_ HTMLDIR`
bash $OPERATE_HTML_DIR/get_html.sh $date $USER_ID $GUILD_ID > /dev/null 
log_info_ "HTML_DIR=$HTML_DIR\ndate=$date\n`ls $HTML_DIR/$date`"

target_categorys=(
ALL_MEMBERS_RANKING
GUILD_MEMBERS_RANKING
BORDER_OF_RANKING
)
#target_categorys=(
#GUILD_MEMBER_RANKING
#)

for category in ${target_categorys[@]}; do
	echo convert_html_to_csv.sh $category
	HTML_LIST="$HTML_DIR/$date/$category"_LIST
	merged_output=$HTML_DIR/$date/$category.csv
	:>$merged_output
	cat $HTML_LIST | while read html_file; do
		bash $OPERATE_HTML_DIR/convert_html_to_csv.sh $html_file $html_file.csv > /dev/null 
		cat $html_file.csv >> $merged_output
	done
done

echo "merge_all_minitely_files"
log_debug_ "bash $OPERATE_FILE_DIR/merge_all_minitely_files.sh $date $HTML_DIR"
OPERATE_FILE_DIR=`getconf_ OPERATEFILEDIR`
merged_minitely_file=`bash $OPERATE_FILE_DIR/merge_all_minitely_files.sh $date $HTML_DIR`
#echo $merged_minitely_file
#echo "$PREFIX-$date.csv"
cp $merged_minitely_file "$DATADIR/$PREFIX-$date.csv"
nkf -s --overwrite "$DATADIR/$PREFIX-$date.csv"
echo "$PREFIX-$date" >> $FILELIST

log_info_ "create_fulldata.rb start"
cd lib/file/
ruby create_fulldata.rb -m latest
cd ../../

if [ ! -e $HOURLYFILELIST ];then
	log_info_ "create_hourly_filelist.sh all start"
	bash lib/calc_speed/create_hourly_filelist.sh all > /dev/null
fi

if [ `getconf_ HTMLFILE_FLAG` = "DISCARD" ];then
	log_info_ "DISCARD $HTML_DIR/$date"
	rm -r $HTML_DIR/$date
fi

echo "minutely processes finished."
log_info_ "minutely processes finished."


##execute_hourly
min=`echo ${date: -4:2}`
if [ $min = "00" ];then
	log_info_ "create_hourly_filelist.sh latest start"
	bash lib/calc_speed/create_hourly_filelist.sh latest > /dev/null
	log_info_ "calc_speedph.sh latest start"
	bash lib/calc_speed/calc_speedph.sh latest > /dev/null
	log_info_ "hourly processes finished."
fi

#log_info_execall "create_hourly_filelist.sh latest start"
#bash lib/calc_speed/create_hourly_filelist.sh latest
#log_info_execall "calc_speedph.sh latest start"
#bash lib/calc_speed/calc_speedph.sh latest

exit 0
