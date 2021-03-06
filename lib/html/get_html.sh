
#bash
cd `dirname $0`
source "../util/util.sh"
log_info "get_html start"
CONFIG_FILE=`getconf CONFIG_FILE`
HTMLDIR=`getconf HTMLDIR`

if [ -z $1 ];then
		date=`date +%Y%m%d-%k%M%S`
	else
		date=$1
fi
OUTPUTDIR=$HTMLDIR/$date
if [ ! -d $OUTPUTDIR ];then mkdir -p $OUTPUTDIR; fi
log_info "get_html start OUTPUTDIR=$OUTPUTDIR"


# get ALL_MEMBERS_RANKING
FILE_LIST="$OUTPUTDIR/ALL_MEMBERS_RANKING_LIST"
:>$FILE_LIST
i=1
cat $CONFIG_FILE | grep ALL_MEMBERS_RANKING_URL | awk -F ' ' '{print $2}' | while read url; do
	log_info "wget -r -l 1 $url --output-document=$OUTPUTDIR/ALL_MEMBERS_RANKING$i"
	wget -r -l 1 $url --output-document="$OUTPUTDIR/ALL_MEMBERS_RANKING$i" >& /dev/null
	echo "$OUTPUTDIR/ALL_MEMBERS_RANKING$i" >> $FILE_LIST
	if [ ! -s "$OUTPUTDIR/ALL_MEMBERS_RANKING$i" ];then
		log_warning "$OUTPUTDIR/ALL_MEMBERS_RANKING$i is empty."
	fi
	i=`expr $i + 1`
done

# get GUILD_MEMBERS_RANKING_URL
FILE_LIST="$OUTPUTDIR/GUILD_MEMBERS_RANKING_LIST"
:>$FILE_LIST
i=1
cat $CONFIG_FILE | grep GUILD_MEMBERS_RANKING_URL | awk -F ' ' '{print $2}' | while read url; do
	log_info "wget -r -l 1 $url --output-document=$OUTPUTDIR/GUILD_MEMBERS_RANKING$i"
	wget -r -l 1 $url --output-document="$OUTPUTDIR/GUILD_MEMBERS_RANKING$i" >& /dev/null
	echo "$OUTPUTDIR/GUILD_MEMBERS_RANKING$i" >> $FILE_LIST
	if [ ! -s "$OUTPUTDIR/GUILD_MEMBERS_RANKING$i" ];then
		log_warning "$OUTPUTDIR/GUILD_MEMBERS_RANKING$i is empty."
	fi
	i=`expr $i + 1`
done

# get BORDER_OF_RANKING_URL
FILE_LIST="$OUTPUTDIR/BORDER_OF_RANKING_LIST"
:>$FILE_LIST
BORDER_OF_RANKING_STRING=`getconf BORDER_OF_RANKING_STRING`
BORDER_OF_RANKING_ARRAY=( `echo $BORDER_OF_RANKING_STRING | sed 's/,/ /g'`)

i=1
cat $CONFIG_FILE | grep BORDER_OF_RANKING_URL | awk -F ' ' '{print $2}' | while read url; do
	target_ranking=${BORDER_OF_RANKING_ARRAY[`expr $i - 1`]}
	output_filename=$OUTPUTDIR/BORDER_OF_RANKING$target_ranking
	log_info "wget -r -l 1 $url --output-document=$output_filename"
	wget -r -l 1 $url --output-document="$output_filename" >& /dev/null

	echo $output_filename >> $FILE_LIST
	if [ ! -s $output_filename ];then
		log_warning "$output_filename is empty."
	fi
	i=`expr $i + 1`
done

echo $date
log_info "get_html finished. save html files to $OUTPUTDIR"