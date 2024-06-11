FROM alpine:3.18

RUN apk add --no-cache \
    php \
    php-curl \
    php-fpm \
    php-bcmath \
    php-gd php-soap \
    php-zip php-curl \
    php-mbstring \
    php-mysqlnd \
    php-gd \
    php-xml \
    php-intl \
    php-zip \
    php-mysqli \
    php-pdo_mysql \
    php-phar \
    curl \
    unzip \
    openrc\
    wget

# set php-fpm to listen on any address and give it root privileges
RUN sed -i "s|listen = 127.0.0.1:9000|listen = 0.0.0.0:9000|g" /etc/php81/php-fpm.d/www.conf && \
    sed -i "s|;listen.owner = nobody|listen.owner = root|g" /etc/php81/php-fpm.d/www.conf && \
    sed -i "s|;listen.group = nobody|listen.group = root|g" /etc/php81/php-fpm.d/www.conf

COPY ./requirements/wordpress/tools/ /
RUN chmod 777 install-wp.sh

CMD ["sh", "install-wp.sh"]

