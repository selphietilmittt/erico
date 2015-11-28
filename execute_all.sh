
# bash
cd `dirname $0`

if [ -e configure.sh ];then bash configure.sh > /dev/null 2>&1; fi

source "lib/util/util.sh"
function getconf_() { getconf "$1" "etc/configure.txt";}
function log_info_() { log_info "$1" "etc/log";}

#guildNAME=$1
#timeSlot=$2
EXEC_NUM=$3

log_info_ " start"

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
log_info_ "parameter\n\
	ALL_MEMBERS_EVENT_NAME=$ALL_MEMBERS_EVENT_NAME\n\
	GUILD_MEMBERS_EVENT_NAME=$GUILD_MEMBERS_EVENT_NAME\n\
	EXEC_NUM=$EXEC_NUM"

echo "get_html.sh"
#HTMLDIR=`bash $ROOTDIR/lib/html/get_html.sh`
HTMLDIR=/Volumes/share/Dropbox/program/puyoque/output/20151128155905
log_info_ "HTMLDIR=$HTMLDIR\n`ls $HTMLDIR`"
ls $HTMLDIR | while read html;do
	echo $html
done



#bash lib/calc_speed/create_hourly_filelist.sh latest
#bash lib/calc_speed/calc_speedph.sh latest
#bash lib/calc_speed/create_target_speed.sh トムソン
#bash lib/calc_speed/calc_defeating_time.sh all トムソン
#bash lib/calc_speed/calc_defeating_time.sh all Dizzy
#bash lib/calc_speed/calc_defeating_time.sh latest トムソン
#bash lib/calc_speed/calc_defeating_time.sh latest Dizzy
#bash lib/calc_speed/create_target_speed.sh トムソン

exit 0
