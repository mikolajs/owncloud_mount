#!/bin/bash

# apt-get install devfs2

# dpkg-reconfigure devfs2

# make nesesary directories


if [ ! -e ~/.davfs2 ] 
then 
	mkdir ~/.davfs2
fi

if [ ! -e  ~/.davfs2/secrets ]
then
	touch ~/.davfs2/secrets
fi

if [ ! -e ~/$USER/owncloud ] 
then 
	mkdir ~/$USER/owncloud
fi

ETCCONFIG=./davfs2.conf # /etc/davfs2/davfs2.conf
TMP=./temp

# create tmp file
if [ ! -e $TEMP ] 
then 
	mkdir ~/.davfs2
fi

# edit /etc/davfs2 comment line with ignore_home and uncomment secrets
exec<$ETCCONFIG
   while read line
   do
	if [[ "$line" =~ "ignore_home" ]] 
	then
		line="# $line"
	elif [[ "$line" =~ "secrets" ]] 
	then
		line=" secrets ~/.davfs2/secrets"
	fi

        echo $line >> $TMP
   done
#insert config from tmp
rm $ETCCONFIG
mv $TMP $ETCCONFIG

#add write in fstab
FSTAB=./README           #/etc/fstab
ADDRESS="http://153.19.169.10:9090/remote.php/webdav/"
echo  "" >> $FSTAB
echo "$ADDRESS /home/$USER/owncloud davfs user,noauto 0 0" >> $FSTAB

