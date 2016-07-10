
#bash
cd `dirname $0`

SRCDIR="../"
DSTDIR="/home/tilmi_000/f/game/puyoQue/guildosakanarush20160629_data"

if [ ! -d $DSTDIR ] ;then echo "targetdir[$DSTDIR] not exist";exit 1;fi
rsync -av --exclude="._*" --exclude=".git" --exclude=".backup" --exclude="test/*" --exclude="configure.txt" --exclude="profile_topPickUpName.txt" --exclude="profile_multiName.txt" --exclude="profile_bottomPickUpName.txt" --include="*/" --include="*.sh" --include="*.pl" --include="*.rb" --include="*.txt" --include="*.md" --exclude="*" $SRCDIR/ $DSTDIR/

#mkdir $DSTDIR/data
#mkdir $DSTDIR/output


exit 0
