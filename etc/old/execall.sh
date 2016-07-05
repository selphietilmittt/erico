
# bash
cd `dirname $0`
source "lib/util/util.sh"
function getconf_execall() { getconf "$1" "etc/configure.txt";}
function log_info_execall() { log_info "$1" "etc/log";}

#guildNAME=$1
#timeSlot=$2
EXEC_NUM=$3


ROOTDIR=`getconf_execall ROOTDIR`
log_info_execall "execall start"

ROOTDIR=`getconf_execall ROOTDIR`
DATADIR="$ROOTDIR/data"
HTMLDIR="$DATADIR/html"
OUTPUTDIR="$ROOTDIR/output"
UTILDIR="$ROOTDIR/lib/util"
ETCDIR="$ROOTDIR/etc"
if [ ! -d "$DATADIR" ];then mkdir $DATADIR ; fi
if [ ! -d "$HTMLDIR" ];then mkdir $HTMLDIR ; fi
if [ ! -d "$OUTPUTDIR" ];then mkdir $OUTPUTDIR ; fi
if [ ! -d "$UTILDIR" ];then mkdir $UTILDIR ; fi
if [ ! -d "$ETCDIR" ];then mkdir $ETCDIR ; fi

cd $ROOTDIR
ALL_MEMBERS_EVENT_NAME=`getconf_execall ALL_MEMBERS_EVENT_NAME`
GUILD_MEMBERS_EVENT_NAME=`getconf_execall GUILD_MEMBERS_EVENT_NAME`
CAMPAIGN_ID=`getconf_execall CAMPAIGN_ID`


log_info_execall "parameter\n\
	ALL_MEMBERS_EVENT_NAME=$ALL_MEMBERS_EVENT_NAME\n\
	GUILD_MEMBERS_EVENT_NAME=$GUILD_MEMBERS_EVENT_NAME\n\
	EXEC_NUM=$EXEC_NUM"


bash $ROOTDIR/lib/html/get_html.sh
## operate_index

bash lib/calc_speed/create_hourly_filelist.sh latest
bash lib/calc_speed/calc_speedph.sh latest
bash lib/calc_speed/create_target_speed.sh トムソン
#bash lib/calc_speed/calc_defeating_time.sh all トムソン
#bash lib/calc_speed/calc_defeating_time.sh all Dizzy
#bash lib/calc_speed/calc_defeating_time.sh latest トムソン
#bash lib/calc_speed/calc_defeating_time.sh latest Dizzy
#bash lib/calc_speed/create_target_speed.sh トムソン
exit 0


echo "aaa"
if [ $execNum -eq 1 ]; then
	page=0
	until [ $page -ge $numofPage ];do
		page=`expr $page + 1`
		if [ $guildID == "null" ]; then
			#mkdir -p "api.puyoquest.jp/html/$eventName/"
			#wget -r -l 1 "http://api.puyoquest.jp/html/$eventName/?campaign_id=$campaignID&uid=4dd9524137cc065dc68c14af1b0c4ea4&page=$page" --output-document="api.puyoquest.jp/html/$eventName/_campaign_id=$campaignID&uid=4dd9524137cc065dc68c14af1b0c4ea4&page=$page"
			:
		else
			#mkdir -p "api.puyoquest.jp/html/$eventNamePerson/"
			#wget -r -l 1 "http://api.puyoquest.jp/html/$eventNamePerson/?campaign_id=$campaignID&guild_id=$guildID&$userID&uid=$userID&page=$page" --output-document="api.puyoquest.jp/html/$eventNamePerson/_campaign_id=$campaignID&guild_id=$guildID&uid=4dd9524137cc065dc68c14af1b0c4ea4&page=$page"
			:
		fi
	done
fi


if [ $guildID == "null" ]; then
	#perl operateIndex.pl $campaignID $numofPage $execNum $guildID $userID $timeSlot $eventName
	:
else
	#perl operateIndex.pl $campaignID $numofPage $execNum $guildID $userID $timeSlot $eventNamePerson
	:
fi

exit 0
