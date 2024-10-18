#!/bin/bash

cp /home/derek/smb.conf /etc/samba
echo -e "$password\n$password" | smbpasswd -a derek