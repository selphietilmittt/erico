#!/bin/bash

cd `dirname $0`
source "lib/util/util.sh"
function getconf_execall() { getconf "$1" "etc/configure.txt";}
function log_info_execall() { log_info "$1" "etc/log";}

ROOTDIR=`getconf_execall ROOTDIR`
log_info_execall "execperl start. target guils is $1"

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
NULL_HOURLYFILELIST=`getconf_execall NULL_HOURLYFILELIST`

cd $ROOTDIR

HOMEDIR=$ROOTDIR
cd $HOMEDIR
#iventName=guild_ranking_guild_battle
#iventNamePerson=person_ranking_guild_battle_guild
#campaignID=12005

iventName=`getconf_execall ALL_MEMBERS_EVENT_NAME`
iventNamePerson=`getconf_execall GUILD_MEMBERS_EVENT_NAME`
campaignID=`getconf_execall CAMPAIGN_ID`

#iventName=guild_ranking_sp_boss_rush
#iventNamePerson=$iventName
#campaignID=6022

numofPage=11
execNum=$3

if [ $1 == "thomson" ]; then
	guildID=115783 #thomson
	#userID=12b02d5c13cb3b0a0ed5633c60e23f5a #pachikuri
        userID=4dd9524137cc065dc68c14af1b0c4ea4 #erio

	numofPage=2
elif [ $1 == "doroeri" ]; then
	guildID=197519 #doroeri
	userID=4dd9524137cc065dc68c14af1b0c4ea4 #erio
	numofPage=2
elif [ $1 == "sunrise" ]; then
	guildID=27625 #sunrise
	userID=3871c44250f7e4ad1b6686d44cbc03c5 #melt
	numofPage=2
else
	guildID=null
	userID=4dd9524137cc065dc68c14af1b0c4ea4
fi

if [ $2 -gt 0 ]; then
	timeSlot=$2
else
	timeSlot="null"
fi

if [ $execNum -eq 1 ]; then
	page=0
	until [ $page -ge $numofPage ];
	do
		page=`expr $page + 1`
		if [ $guildID == "null" ]; then
			mkdir -p "api.puyoquest.jp/html/$iventName/"
			wget -r -l 1 "http://api.puyoquest.jp/html/$iventName/?campaign_id=$campaignID&uid=4dd9524137cc065dc68c14af1b0c4ea4&page=$page" --output-document="api.puyoquest.jp/html/$iventName/_campaign_id=$campaignID&uid=4dd9524137cc065dc68c14af1b0c4ea4&page=$page"
			:
		else
			mkdir -p "api.puyoquest.jp/html/$iventNamePerson/"
			wget -r -l 1 "http://api.puyoquest.jp/html/$iventNamePerson/?campaign_id=$campaignID&guild_id=$guildID&$userID&uid=$userID&page=$page" --output-document="api.puyoquest.jp/html/$iventNamePerson/_campaign_id=$campaignID&guild_id=$guildID&uid=4dd9524137cc065dc68c14af1b0c4ea4&page=$page"
			:
		fi
	done
fi


if [ $guildID == "null" ]; then
	perl operateIndex.pl $campaignID $numofPage $execNum $guildID $userID $timeSlot $iventName
	#:
else
	perl operateIndex.pl $campaignID $numofPage $execNum $guildID $userID $timeSlot $iventNamePerson
	:
fi

if [ ! -e $NULL_HOURLYFILELIST ];then
	log_info_execall "NULL_HOURLYFILELIST not exists. create all."
	bash lib/calc_speed/create_hourly_filelist.sh all
fi
#log_info_execall "create_hourly_filelist.sh latest start"
#bash lib/calc_speed/create_hourly_filelist.sh latest
#log_info_execall "calc_speedph.sh latest start"
#bash lib/calc_speed/calc_speedph.sh latest

exit 0
