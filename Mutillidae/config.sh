export INSTALL_LOG=/tmp/vm_config_log.txt

echo "Final config of VM" | tee $INSTALL_LOG

sudo apt-get install acpid >> $INSTALL_LOG 2>&1 || echo "apt-get of acpid failed"

sudo passwd root << EOF >> $INSTALL_LOG 2>&1
SPA2015x
SPA2015x
EOF

sudo ed /etc/motd.tail << EOF >> $INSTALL_LOG 2>&1
$
a

Your IP address is `ifconfig eth1 | grep 'inet addr:' | sed 's/ *//' | cut -d ' ' -f2 | cut -d ':' -f2`
.
wq
EOF
if [ $? -ne 0 ]; then echo "edit of motd file failed"; fi

sudo umount /vagrant >> $INSTALL_LOG 2>&1 || echo "unmount vagrant synced failed"
