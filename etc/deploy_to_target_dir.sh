
#bash
cd `dirname $0`

SRCDIR="../"
DSTDIR="/home/tilmi_000/f/game/puyoQue/guildosakanarush20160629_data"

if [ ! -d $DSTDIR ] ;then echo "targetdir[$DSTDIR] not exist";exit 1;fi
rsync -av --exclude="._*" --exclude=".git/*" --exclude="test/*" --exclude="configure.txt" --include="*/" --include="*.sh" --include="*.pl" --include="*.rb" --include="*.txt" --exclude="*" $SRCDIR/ $DSTDIR/

mkdir $DSTDIR/data
mkdir $DSTDIR/output


exit 0
