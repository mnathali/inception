#!bin/sh

adduser -D $DB_USER
adduser -D shrek

sed -i "s|skip-networking||g" /etc/my.cnf.d/mariadb-server.cnf
echo [mysqld] > /etc/my.cnf.d/exta.cnf
#echo skip-host-cache >> /etc/my.cnf.d/exta.cnf
#echo skip-name-resolve >> /etc/my.cnf.d/exta.cnf
#echo skip-grant-tables >> /etc/my.cnf.d/exta.cnf
echo bind-address=0.0.0.0 >> /etc/my.cnf.d/exta.cnf
echo skip-networking=0 >> /etc/my.cnf.d/exta.cnf
echo socket=/tmp/mysqld.sock >> /etc/my.cnf.d/exta.cnf
echo user=root >> /etc/my.cnf.d/exta.cnf
echo datadir=/var/lib/mysql >> /etc/my.cnf.d/exta.cnf
#echo pid-file=/var/run/mysqld.pid
echo [mysql] >> /etc/my.cnf.d/exta.cnf
echo socket=/tmp/mysqld.sock >> /etc/my.cnf.d/exta.cnf

mysql_install_db

if [ ! -d "/var/lib/mysql/wordpress" ]; then

        mysqld &

        while [ ! -e /tmp/mysqld.sock ]
        do
        echo "lounch mysqld to create an user..."
        sleep 0.5
        done
        
        mysql -e "CREATE DATABASE $DB_NAME;"
        mysql -e "CREATE USER '$DB_USER'@'%' IDENTIFIED BY '$DB_PASS';"
        mysql -e "CREATE USER '$DB_USER'@localhost IDENTIFIED BY '$DB_PASS';"
        echo GRANT ALL ON '`'$DB_NAME'`'.* TO "'$DB_USER'"@"'%';" | mysql
        mysql -e "FLUSH PRIVILEGES;"
        mysqladmin --socket=/tmp/mysqld.sock -u root password $MYSQL_ROOT_PASSWORD

fi
