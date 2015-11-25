
#bash
cd `dirname $0`
source "../util/util.sh"
log_info "get_html start"

DATADIR=`getconf DATADIR`
HTMLDIR=`getconf HTMLDIR`


if [ ! -d $HTMLDIR ];then mkdir $HTMLDIR; fi
#if [ "$(ls -A $HTMLDIR)" ];then rm $HTMLDIR/*;fi

# get ALL_MEMBERS_RANKING_URL
i=1
getconf ALL_MEMBERS_RANKING_URL | while read url; do
	log_info "wget -r -l 1 $url --output-document=$HTMLDIR/ALL_MEMBERS_RANKING$i"
	#wget -r -l 1 $url --output-document="$HTMLDIR/ALL_MEMBERS_RANKING$i" >& /dev/null
	if [ ! -s "$HTMLDIR/ALL_MEMBERS_RANKING$i" ];then
		log_warning "$HTMLDIR/ALL_MEMBERS_RANKING$i is empty."
	fi
	i=`expr $i + 1`
done

# get GUILD_MEMBERS_RANKING_URL
i=1
getconf GUILD_MEMBERS_RANKING_URL | while read url; do
	log_info "wget -r -l 1 $url --output-document=$HTMLDIR/GUILD_MEMBERS_RANKING$i"
	#wget -r -l 1 $url --output-document="$HTMLDIR/GUILD_MEMBERS_RANKING$i" >& /dev/null
	if [ ! -s "$HTMLDIR/GUILD_MEMBERS_RANKING$i" ];then
		log_warning "$HTMLDIR/GUILD_MEMBERS_RANKING$i is empty."
	fi
	i=`expr $i + 1`
done

# get BORDER_OF_RANKING_URL
i=1
getconf BORDER_OF_RANKING_URL | while read url; do
	log_info "wget -r -l 1 $url --output-document=$HTMLDIR/BORDER_OF_RANKING$i"
	#wget -r -l 1 $url --output-document="$HTMLDIR/BORDER_OF_RANKING$i" >& /dev/null
	if [ ! -s "$HTMLDIR/BORDER_OF_RANKING$i" ];then
		log_warning "$HTMLDIR/BORDER_OF_RANKING$i is empty."
	fi
	i=`expr $i + 1`
done
