export INSTALL_LOG=/tmp/xampp_install_log.txt

echo "Provisioning XAMPP" | tee $INSTALL_LOG

cd /vagrant

chmod 755 xampp-linux-x64-*-installer.run

sudo ./xampp-linux-x64-*-installer.run >> $INSTALL_LOG 2>&1 || echo "xampp installer failed to run"


sudo ed /opt/lampp/xampp << EOF >> $INSTALL_LOG 2>&1
/^LIBRARY_PATH="\$XAMPP_ROOT\/lib"/s//LIBRARY_PATH="\/lib\/x86_64-linux-gnu:\$XAMPP_ROOT\/lib"/
wq
EOF
if [ $? -ne 0 ]; then echo "edit of xampp file failed"; fi

sudo ed /opt/lampp/bin/envvars << EOF >> $INSTALL_LOG 2>&1
/LD_LIBRARY_PATH="\/opt\/lampp\/lib:\$LD_LIBRARY_PATH"/s//LD_LIBRARY_PATH="\$LD_LIBRARY_PATH:\/opt\/lampp\/lib"
wq
EOF
if [ $? -ne 0 ]; then echo "edit of envvars file failed"; fi

ed /opt/lampp/etc/extra/httpd-xampp.conf << EOF >> $INSTALL_LOG 2>&1
/Require local/s/^/#/
wq
EOF
if [ $? -ne 0 ]; then echo "edit of xampp configuration file failed"; fi

sudo /opt/lampp/lampp restart >> $INSTALL_LOG 2>&1 || echo "lampp failed to restart"

# Wait for mysql to be ready?
sleep 5

/opt/lampp/bin/mysql --user=root << EOF >> $INSTALL_LOG 2>&1
FLUSH PRIVILEGES;
SET PASSWORD FOR 'root'@'localhost' = PASSWORD('SPA2015y');
exit
EOF
if [ $? -ne 0 ]; then echo "mysql set root password failed"; fi

cp /vagrant/lampp /etc/init.d
chmod +x /etc/init.d/lampp
update-rc.d lampp defaults

ifconfig eth1 | grep 'inet addr:' 

echo "XAMPP Provisioning finished" | tee -a $INSTALL_LOG

