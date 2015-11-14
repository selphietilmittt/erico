
##zsh
cd `dirname $0` 
mkdir previous
rsync -av --exclude=".backup" ../ previous/


