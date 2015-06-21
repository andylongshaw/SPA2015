export INSTALL_LOG=/tmp/mutillidae_install_log.txt

echo "Provisioning Mutillidae" | tee $INSTALL_LOG

sudo apt-get install unzip >> $INSTALL_LOG 2>&1 || echo "apt-get of unzup failed"

sudo apt-get -y install curl >> $INSTALL_LOG 2>&1 || echo "apt-get of curl failed"

cd /opt/lampp/htdocs/

sudo unzip /vagrant/LATEST-mutillidae-2.6.19.zip >> $INSTALL_LOG 2>&1 || echo "unzup of mutillidae failed"

echo "Unpacked zip file"

sudo ed mutillidae/.htaccess << EOF >> $INSTALL_LOG 2>&1
/Allow from localhost/s/^/#/
wq
EOF
if [ $? -ne 0 ]; then echo "edit of htaccess file failed"; fi

sudo ed mutillidae/classes/MySQLHandler.php << EOF >> $INSTALL_LOG 2>&1
/mMySQLDatabasePassword = ""/s//mMySQLDatabasePassword = "SPA2015y"/
wq
EOF
if [ $? -ne 0 ]; then echo "edit of MySQLHandler.php file failed"; fi

sudo curl http://localhost/mutillidae/set-up-database.php >> $INSTALL_LOG 2>&1 || echo "curl of database setup failed"

echo "Mutillidae provisioning finished" | tee -a $INSTALL_LOG
