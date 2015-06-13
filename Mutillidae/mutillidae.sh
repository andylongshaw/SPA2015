echo "Provisioning Mutillidae"

sudo apt-get install unzip
sudo apt-get install curl

cd /opt/lampp/htdocs/

sudo unzip /vagrant/LATEST-mutillidae-2.6.19.zip > /dev/null

echo "Unpacked zip file"

ed mutillidae/.htaccess << EOF
/Allow from localhost/s/^/#/
wq
EOF

# sudo curl http://localhost/mutillidae/set-up-database.php
