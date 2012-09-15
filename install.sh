#!/bin/bash


# apt-get install devfs2

# dpkg-reconfigure devfs2

# make nesesary directories


TEACHER=/home/$@

ADDRESS="http://153.19.169.10:9090/remote.php/webdav/"

if [ ! -e $TEACHER/.davfs2 ] 
then 
	mkdir $TEACHER/.davfs2
fi

if [ ! -e  $TEACHER/.davfs2/secrets ]
then
	touch $TEACHER/.davfs2/secrets
	$ADDRESS > $TEACHER/.davfs2/secrets
	chown -R $@ $TEACHER/.davfs2
	chmod 664 $TEACHER/.davfs2/secrets
fi

if [ ! -e $TEACHER/owncloud ] 
then 
	mkdir $TEACHER/owncloud
	chown -R $@ $TEACHER/owncloud
fi

ETCCONFIG=./davfs2.conf # /etc/davfs2/davfs2.conf
TMP=./tmp.conf

# create tmp file
if [ ! -e $TMP ] 
then 
	touch $TMP
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

echo  "" >> $FSTAB
echo "$ADDRESS /home/$@/owncloud davfs user,noauto 0 0" >> $FSTAB

#copy owncloud_mount to usr/bin
cp owncloud_mount /usr/bin/owncloud_mount
chmod 555 /usr/bin/owncloud_mount

ln -s /usr/bin/owncloud_mount $TEACHER/Pulpit/owncloud

