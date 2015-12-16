
# bash
cd `dirname $0`

echo "configure.sh"
#if [ -e configure.sh ];then bash configure.sh > /dev/null 2>&1; fi
bash configure.sh > /dev/null 2>&1

source "lib/util/util.sh"
function getconf_() { getconf "$1" "etc/configure.txt";}
function log_info_() { log_info "$1" "etc/log";}

#guildNAME=$1
#timeSlot=$2
EXEC_NUM=$3

log_info_ "execute_all.sh start"

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

cd $ROOTDIR
#log_info_ "parameter\n\
#	ALL_MEMBERS_EVENT_NAME=$ALL_MEMBERS_EVENT_NAME\n\
#	GUILD_MEMBERS_EVENT_NAME=$GUILD_MEMBERS_EVENT_NAME\n\
#	EXEC_NUM=$EXEC_NUM"

echo "get_html.sh"
OPERATE_HTML_DIR="$ROOTDIR/lib/html"
#date=`bash $OPERATE_HTML_DIR/get_html.sh`
#HTML_DIR=`getconf_ HTMLDIR`/$date
date="20151204-150513"
HTML_DIR=/Volumes/share/Dropbox/program/puyoque/data/html/20151204-150513
log_info_ "HTML_DIR=$HTML_DIR\n`ls $HTML_DIR`"

target_categorys=(
ALL_MEMBERS_RANKING
GUILD_MEMBERS_RANKING
BORDER_OF_RANKING
)
#target_categorys=(
#GUILD_MEMBERS_RANKING
#)

for category in ${target_categorys[@]}; do
	HTML_LIST="$HTML_DIR/$category"_LIST
	merged_output=$HTML_DIR/$category.csv
	:>$merged_output
	cat $HTML_LIST | while read html_file; do
		echo convert_html_to_csv.sh $category
		bash $OPERATE_HTML_DIR/convert_html_to_csv.sh $html_file $html_file.csv
		cat $html_file.csv >> $merged_output
	done
done

#ls $HTMLDIR | while read html;do
#	echo $HTMLDIR/$html
#done

#bash lib/calc_speed/create_hourly_filelist.sh latest
#bash lib/calc_speed/calc_speedph.sh latest
#bash lib/calc_speed/create_target_speed.sh トムソン
#bash lib/calc_speed/calc_defeating_time.sh all トムソン
#bash lib/calc_speed/calc_defeating_time.sh all Dizzy
#bash lib/calc_speed/calc_defeating_time.sh latest トムソン
#bash lib/calc_speed/calc_defeating_time.sh latest Dizzy
#bash lib/calc_speed/create_target_speed.sh トムソン

exit 0
