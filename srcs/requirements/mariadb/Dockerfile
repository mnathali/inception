FROM alpine:3.17

RUN apk update && apk add --no-cache mariadb mariadb-client

COPY tools/ .

ARG DB_NAME \
    DB_USER \
    DB_PASS \
    MYSQL_ROOT_PASSWORD

RUN sh create_db.sh && rm create_db.sh

CMD ["mysqld_safe", "--skip-log-error"]
