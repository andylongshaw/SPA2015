echo "Provisioning XAMPP"

cd /vagrant

chmod 755 xampp-linux-x64-*-installer.run

sudo ./xampp-linux-x64-*-installer.run

ed /opt/lampp/etc/extra/httpd-xampp.conf << EOF
/Require local/s/^/#/
wq
EOF

sudo /opt/lampp/lampp restart

ifconfig eth1 | grep 'inet addr:'
