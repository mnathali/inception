#!bin/sh

echo "-------------------->START<-----------------------------"

wp config create --allow-root --path=/var/www/wordpress/ --dbname=$DB_NAME \
	--dbuser=$DB_USER --dbpass=$DB_PASS --dbhost=$DB_HOST \
	--dbprefix=wp_

wp core install --allow-root --path=/var/www/wordpress --url=$DOMAIN_NAME \
--title=$TITLE --admin_user=$WP_ADMIN --admin_password=$WP_PASS \
--admin_email=$WP_EMAIL

wp user create --allow-root --path=/var/www/wordpress/ $WP_USER wp@m.ru \
                --role=author --user_pass=$WP_USER_PASS

exec /usr/sbin/php-fpm81 -F