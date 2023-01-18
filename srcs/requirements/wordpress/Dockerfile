# syntax=docker/dockerfile-upstream:master-labs
FROM alpine:3.17

RUN apk update && apk upgrade && apk add php81-fpm php81-mysqli mariadb-client curl composer \ 
    && composer global require wp-cli/wp-cli \
    && curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp \
    && sed -i "s|listen = 127.0.0.1:9000|listen = 9000|g" /etc/php81/php-fpm.d/www.conf
    # sed -i "s|;listen.owner = nobody|listen.owner = nobody|g" \
    #   /etc/php81/php-fpm.d/www.conf && \
    # sed -i "s|;listen.group = nobody|listen.group = nobody|g" \
    #   /etc/php81/php-fpm.d/www.confi


RUN mkdir -p /var/www/wordpress /run/mysqld && wp core download --path=/var/www/wordpress --locale=ru_RU

COPY tools/install_wp.sh .

RUN chmod a+x install_wp.sh

ENTRYPOINT [ "./install_wp.sh" ]

#CMD ["php-fpm81", "-F"]

#COPY conf/wp-config.php /var/www/wordpress

#RUN wp core install --path=/var/www/wordpress --url=$DOMAIN_NAME --title=$TITLE --admin_user=$WP_ADMIN --admin_password=$WP_PASS --admin_email=$WP_EMAIL 

#RUN apk add git && git clone https://github.com/WordPress/WordPress.git /var/www/wordpress

#ADD --keep-git-dir=true https://github.com/WordPress/WordPress.git /var/www/wordpress