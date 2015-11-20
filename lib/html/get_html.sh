
#bash
cd `dirname $0`
getconf="../util/getconf.sh"
DATADIR=`./$getconf DATADIR`
HTMLDIR=`./$getconf HTMLDIR`


if [ ! -d $HTMLDIR ];then
	mkdir $HTMLDIR
fi

# get ALL_MEMBERS_RANKING_URL 
i=1
./$getconf ALL_MEMBERS_RANKING_URL | while read url; do
	wget -r -l 1 $url --output-document="$HTMLDIR/ALL_MEMBERS_RANKING$i"
	i=`expr $i + 1`
done

# get GUILD_MEMBERS_RANKING_URL 
i=1
./$getconf GUILD_MEMBERS_RANKING_URL | while read url; do
	wget -r -l 1 $url --output-document="$HTMLDIR/GUILD_MEMBERS_RANKING$i"
	i=`expr $i + 1`
done

# get BORDER_OF_RANKING_URL 
i=1
./$getconf BORDER_OF_RANKING_URL | while read url; do
	wget -r -l 1 $url --output-document="$HTMLDIR/BORDER_OF_RANKING$i"
	i=`expr $i + 1`
done

i=1
./$getconf BORDER_OF_RANKING_URL | while read url; do
	echo $i
	i=`expr $i + 1`
done


