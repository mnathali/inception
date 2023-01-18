FROM alpine:3.17

ARG DOMAIN_NAME

RUN apk update && apk upgrade && apk add --no-cache nginx openssl

RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout \
	/etc/ssl/certs/$DOMAIN_NAME.key -out /etc/ssl/certs/$DOMAIN_NAME.crt \
	-subj "/C=RU/ST=Moscow/L=Moscow/O=Shool_21/OU=Ecole_42/CN=nginx/emailAddress=mnathali@student.21-school.ru"

COPY conf/nginx.conf /etc/nginx/http.d/

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
