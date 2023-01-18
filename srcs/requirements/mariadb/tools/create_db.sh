#!bin/sh

sed -i "s|skip-networking||g" /etc/my.cnf.d/mariadb-server.cnf
echo [mysqld] > /etc/my.cnf.d/exta.cnf
#echo skip-host-cache >> /etc/my.cnf.d/exta.cnf
#echo skip-name-resolve >> /etc/my.cnf.d/exta.cnf
#echo skip-grant-tables >> /etc/my.cnf.d/exta.cnf
echo bind-address=0.0.0.0 >> /etc/my.cnf.d/exta.cnf
echo skip-networking=0 >> /etc/my.cnf.d/exta.cnf
echo socket=/tmp/mysqld.sock >> /etc/my.cnf.d/exta.cnf
echo user=mysql >> /etc/my.cnf.d/exta.cnf
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

	#mysql -e "USER 'root'@'localhost' IDENTIFIED VIA mysql_native_password USING PASSWORD('$MYSQL_ROOT_PASSWORD');"
        mysql -e "CREATE DATABASE IF NOT EXISTS $DB_NAME DEFAULT CHARACTER SET utf8;"
        mysql -e "CREATE USER '$DB_USER'@'%' IDENTIFIED BY '$DB_PASS';"
        mysql -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'%';"
        mysql -e "FLUSH PRIVILEGES;"
        
        #mysql < create_tables.sql

fi
