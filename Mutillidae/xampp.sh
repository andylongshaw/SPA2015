export INSTALL_LOG=/tmp/xampp_install_log.txt

echo "Provisioning XAMPP" | tee $INSTALL_LOG

cd /vagrant

chmod 755 xampp-linux-x64-*-installer.run

sudo ./xampp-linux-x64-*-installer.run >> $INSTALL_LOG 2>&1 || echo "xampp installer failed to run"

ed /opt/lampp/etc/extra/httpd-xampp.conf << EOF >> $INSTALL_LOG 2>&1
/Require local/s/^/#/
wq
EOF
if [ $? -ne 0 ]; then echo "edit of xampp configuration file failed"; fi

sudo /opt/lampp/lampp restart >> $INSTALL_LOG 2>&1 || echo "lampp failed to restart"

cp /vagrant/lampp /etc/init.d
chmod +x /etc/init.d/lampp
update-rc.d lampp defaults

ifconfig eth1 | grep 'inet addr:' 

echo "XAMPP Provisioning finished" | tee -a $INSTALL_LOG

