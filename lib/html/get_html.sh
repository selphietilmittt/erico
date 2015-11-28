
#bash
cd `dirname $0`
source "../util/util.sh"
log_info "get_html start"
CONFIG_FILE=`getconf CONFIG_FILE`
HTMLDIR=`getconf HTMLDIR`

if [ ! -z $1 ];then
		date=$2
	else
		date=`date +%Y%m%d-%k%M%S`
fi
OUTPUTDIR=$HTMLDIR/$date
log_info "get_html start OUTPUTDIR=$OUTPUTDIR"


if [ ! -d $OUTPUTDIR ];then mkdir -p $OUTPUTDIR; fi

i=1
cat $CONFIG_FILE | grep ALL_MEMBERS_RANKING_URL | awk -F ' ' '{print $2}' | while read url; do
	log_info "wget -r -l 1 $url --output-document=$OUTPUTDIR/ALL_MEMBERS_RANKING$i"
	wget -r -l 1 $url --output-document="$OUTPUTDIR/ALL_MEMBERS_RANKING$i" >& /dev/null
	if [ ! -s "$OUTPUTDIR/ALL_MEMBERS_RANKING$i" ];then
		log_warning "$OUTPUTDIR/ALL_MEMBERS_RANKING$i is empty."
	fi
	i=`expr $i + 1`
done

# get GUILD_MEMBERS_RANKING_URL
i=1
cat $CONFIG_FILE | grep GUILD_MEMBERS_RANKING_URL | awk -F ' ' '{print $2}' | while read url; do
	log_info "wget -r -l 1 $url --output-document=$OUTPUTDIR/GUILD_MEMBERS_RANKING$i"
	wget -r -l 1 $url --output-document="$OUTPUTDIR/GUILD_MEMBERS_RANKING$i" >& /dev/null
	if [ ! -s "$OUTPUTDIR/GUILD_MEMBERS_RANKING$i" ];then
		log_warning "$OUTPUTDIR/GUILD_MEMBERS_RANKING$i is empty."
	fi
	i=`expr $i + 1`
done

# get BORDER_OF_RANKING_URL
i=1
cat $CONFIG_FILE | grep BORDER_OF_RANKING_URL | awk -F ' ' '{print $2}' | while read url; do
	log_info "wget -r -l 1 $url --output-document=$OUTPUTDIR/BORDER_OF_RANKING$i"
	wget -r -l 1 $url --output-document="$OUTPUTDIR/BORDER_OF_RANKING$i" >& /dev/null
	if [ ! -s "$OUTPUTDIR/BORDER_OF_RANKING$i" ];then
		log_warning "$OUTPUTDIR/BORDER_OF_RANKING$i is empty."
	fi
	i=`expr $i + 1`
done

echo $date
log_info "get_html finished. save html files to $OUTPUTDIR"