To run (Ubuntu):
1. install seed and devfs2
2. run command dpkg-reconfigure webdav2 and confirm yes
3. edit /etc/davfs2 comment line with ignore_home and uncomment secrets
4. add to fstab: http://http_address/remote.php/webdav/ /home/user/owncloud davfs user,noauto 0 0
