
# bash
cd `dirname $0`

if [ -e configure.sh ];then bash configure.sh > /dev/null 2>&1; fi

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
HTML_DIR=/Volumes/share/Dropbox/program/puyoque/data/html/20151128-214715
HTML_LIST=$HTML_DIR/html_list
log_info_ "HTML_DIR=$HTML_DIR\n`ls $HTML_DIR`"

target_categorys=(
ALL_MEMBERS_RANKING
GUILD_MEMBERS_RANKING
BORDER_OF_RANKING
)

for category in ${target_categorys[@]}; do
	:> $HTML_LIST
	ls $HTML_DIR | grep "$category" | while read html_file; do
		echo $HTML_DIR/$html_file >> $HTML_LIST
	done
	log_info_ "HTML_LIST=\n`cat $HTML_LIST`"
	bash $OPERATE_HTML_DIR/convert_html_to_csv.sh $HTML_LIST

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
