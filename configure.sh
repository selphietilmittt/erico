
#zsh

## user config
## set IVENT_NAME: person, guild,gbattle
IVENT_NAME="guild"
## num of page
TARGET_RANKING=10
BORDER_OF_RANKING=( 1 10 30 300 1000 3000 10000 30000 )
####

cd `dirname $0`
CONFIG_FILE="config.txt"
if [ -e $CONFIG_FILE ];then
	mv $CONFIG_FILE $CONFIG_FILE".1"
fi

## set root directory
ROOTDIR=`pwd`
echo "ROOTDIR=$ROOTDIR"

## create other directory
DATADIR="$ROOTDIR/data"
HTMLDIR="$DATADIR/html"
OUTPUTDIR="$ROOTDIR/output"
UTILDIR="$ROOTDIR/lib/util"
if [ ! -d $DATADIR ];then mkdir $DATADIR ; fi
if [ ! -d $HTMLDIR ];then mkdir $HTMLDIR ; fi
if [ ! -d $OUTPUTDIR ];then mkdir $OUTPUTDIR ; fi
if [ ! -d $UTILDIR ];then mkdir $UTILDIR ; fi

NULL_FILELIST="$DATADIR/null-filelist.txt"
NULL_HOURLYFILELIST="$DATADIR/null-hourly-filelist.txt"
NULL_OUTPUT="$DATADIR/null-output.csv"
DEFEATING_TIME_OF_=$OUTPUTDIR"/defeating_time_of_" # _guile_name.csv
DEFEATING_TIME_BY_ENDNUM_OF_=$OUTPUTDIR"/defeating_time_by_endnum_of_" # _guile_name.csv



if [ -z $IVENT_NAME ];then
	echo "IVENT_NAME is EMPTY"
	exit 1
elif [ $IVENT_NAME == "person" ];then
	ALL_MEMBERS_RANKING=person_ranking_sp_item_festival
	GUILD_MEMBERS_RANKING=person_ranking_sp_item_festival_guild
	CAMPAIGN_ID=2038
	echo "ALL_MEMBERS_RANKING=$ALL_MEMBERS_RANKING"
	echo "GUILD_MEMBERS_RANKING=$GUILD_MEMBERS_RANKING"
	echo "CAMPAIGN_ID=$CAMPAIGN_ID"
elif [ $IVENT_NAME == "battle" ];then
	ALL_MEMBERS_RANKING=person_ranking_battle_arena_festival
	GUILD_MEMBERS_RANKING=person_ranking_battle_arena_festival_guild
	CAMPAIGN_ID=7014
	echo "ALL_MEMBERS_RANKING=$ALL_MEMBERS_RANKING"
	echo "GUILD_MEMBERS_RANKING=$GUILD_MEMBERS_RANKING"
	echo "CAMPAIGN_ID=$CAMPAIGN_ID"
elif [ $IVENT_NAME == "guild" ];then
	ALL_MEMBERS_RANKING=guild_ranking_sp_boss_rush
	GUILD_MEMBERS_RANKING=null
	CAMPAIGN_ID=6022
	echo "ALL_MEMBERS_RANKING=$ALL_MEMBERS_RANKING"
	echo "GUILD_MEMBERS_RANKING=$GUILD_MEMBERS_RANKING"
	echo "CAMPAIGN_ID=$CAMPAIGN_ID"
elif [ $IVENT_NAME == "gbattle" ];then
	ALL_MEMBERS_RANKING=guild_ranking_guild_battle
	GUILD_MEMBERS_RANKING=person_ranking_guild_battle_guild
	CAMPAIGN_ID=12005
	echo "ALL_MEMBERS_RANKING=$ALL_MEMBERS_RANKING"
	echo "GUILD_MEMBERS_RANKING=$GUILD_MEMBERS_RANKING"
	echo "CAMPAIGN_ID=$CAMPAIGN_ID"
else
	echo "invalid IVENT_NAME: $IVENT_NAME"
	exit 1
fi

## set personal id
GUILD_ID=115783 #thomson
USER_ID=4dd9524137cc065dc68c14af1b0c4ea4 #erio

## path of profile
PROFILE_TOPPICKUPNAME=$ROOTDIR/etc/profile_topPickUpName.txt
PROFILE_BOTTOMPICKUPNAME=$ROOTDIR/etc/profile_bottomPickUpName.txt
PROFILE_MULTINAME=$ROOTDIR/etc/profile_multiName.txt



## set csv line
#,2015/11/11 06:48:05
#pickUpTU
#Mu, ,
#,,
#,,
#:
#pickUpRank
#ranking
#1,1502,Mumin�J??
NUM_OF_TOP_NAME=`wc -l < $PROFILE_TOPPICKUPNAME`
NUM_OF_TOP_NAME=`expr $NUM_OF_TOP_NAME + 1`
TIMESTAMP=1
START_OF_TOP_PICKUP_NAME=3
END_OF_TOP_PICKUP_NAME=`expr $START_OF_TOP_PICKUP_NAME + $NUM_OF_TOP_NAME \* 3 - 1`
START_OF_RANKING=`expr $END_OF_TOP_PICKUP_NAME + 3`
END_OF_RANKING=`expr $START_OF_RANKING + $TARGET_RANKING - 1`


echo "creating config.txt"
VAR=(\
	 CONFIG_FILE\
	 ROOTDIR\
	 DATADIR\
	 HTMLDIR\
	 OUTPUTDIR\
	 UTILDIR\
	 NULL_FILELIST\
	 NULL_HOURLYFILELIST\
	 NULL_OUTPUT\
	 DEFEATING_TIME_OF_\
	 DEFEATING_TIME_BY_ENDNUM_OF_\
	 IVENT_NAME\
	 ALL_MEMBERS_RANKING\
	 GUILD_MEMBERS_RANKING\
	 CAMPAIGN_ID\
	 GUILD_ID\
	 USER_ID\
	 PROFILE_TOPPICKUPNAME\
	 PROFILE_BOTTOMPICKUPNAME\
	 PROFILE_MULTINAME\
	 TARGET_RANKING\
	 BORDER_OF_RANKING\
	 NUM_OF_TOP_NAME\
	 TIMESTAMP\
	 START_OF_TOP_PICKUP_NAME\
	 END_OF_TOP_PICKUP_NAME\
	 START_OF_RANKING\
	 END_OF_RANKING\
)

i=0
for var in ${VAR[@]}; do
	tmp="$`echo $var`"
	eval "echo $var $tmp" >> $CONFIG_FILE
	let i++
done


## set URL
echo "setting URL"
#ALL_MEMBERS_RANKING
if [ $ALL_MEMBERS_RANKING != "null" ];then
	RANKING_URL="\
http://api.puyoquest.jp/html/\
$ALL_MEMBERS_RANKING/\
?campaign_id=$CAMPAIGN_ID\
&uid=$USER_ID\
&page="
	i=0
	until  [ $i -ge $TARGET_RANKING ]
	do
		i=`expr $i + 30`
		p=`expr $i / 30`
		echo "RANKING_URL page$p"
		echo "ALL_MEMBERS_RANKING_URL$p $RANKING_URL$p">>$CONFIG_FILE
	done
fi

#GUILD_MEMBERS_RANKING
if [ $GUILD_MEMBERS_RANKING != "null" ];then
	RANKING_URL="\
http://api.puyoquest.jp/html/\
$GUILD_MEMBERS_RANKING/\
?campaign_id=$CAMPAIGN_ID\
&uid=$USER_ID\
&page=$page"
	i=0
	until  [ $i -ge 2 ]
	do
		i=`expr $i + 1`
		echo "RANKING_URL page$i"
		echo "GUILD_MEMBERS_RANKING_URL$i $RANKING_URL$i">>$CONFIG_FILE
	done
fi

echo  "calc BORDER_OF_RANKING"
	RANKING_URL="\
http://api.puyoquest.jp/html/\
$ALL_MEMBERS_RANKING/\
?campaign_id=$CAMPAIGN_ID\
&uid=$USER_ID\
&page="

for var in ${BORDER_OF_RANKING[@]}; do
	p=`expr \( $var - 1 \) / 30 + 1`
	echo "RANKING_URL page$p"
	echo "BORDER_OF_RANKING_URL$p $RANKING_URL$p">>$CONFIG_FILE
done
echo "remove duplicated lines"
#awk '!a[$0]++' $CONFIG_FILE
#uniq $CONFIG_FILE $CONFIG_FILE
echo "create config finished"
echo "--------"

exit 0
