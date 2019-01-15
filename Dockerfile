FROM alpine:3.8

ENV COMPOSER_ALLOW_SUPERUSER=1 \
    COMPOSER_NO_INTERACTION=1 \
    ENV=/root/.bashrc \
    LD_PRELOAD="/usr/lib/preloadable_libiconv.so php" \
    NODE_ENV=production \
    SYMFONY_PHPUNIT_VERSION=7.1 \
    TERM=xterm-color

EXPOSE 80

WORKDIR /srv

RUN apk add --update --no-cache -q \
        ca-certificates \
        curl \
        gnupg \

    && apk add --update --no-cache -q \
        mysql-client \
        nginx \
        perl \
        php7 \
        php7-apcu \
        php7-bcmath \
        php7-ctype \
        php7-curl \
        php7-dom \
        php7-fileinfo \
        php7-fpm \
        php7-gd \
        php7-iconv \
        php7-intl \
        php7-json \
        php7-mbstring \
        php7-odbc \
        php7-opcache \
        php7-openssl \
        php7-pcntl \
        php7-pdo \
        php7-pdo_mysql \
        php7-pdo_sqlite \
        php7-pgsql \
        php7-phar \
        php7-pspell \
        php7-redis \
        php7-simplexml \
        php7-soap \
        php7-sodium \
        php7-sqlite3 \
        php7-tidy \
        php7-tokenizer \
        php7-xdebug \
        php7-xml \
        php7-xmlrpc \
        php7-xmlwriter \
        php7-zip \
        php7-zlib \
        procps \
        redis \
        supervisor \

    && wget -q -O /usr/local/bin/phpunit https://phar.phpunit.de/phpunit-${SYMFONY_PHPUNIT_VERSION}.phar \
    && chmod +x /usr/local/bin/phpunit \

    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \

    && mkdir /run/nginx /run/php-fpm /run/supervisor /var/log/blackfire /var/log/supervisor \

    # forward request and error logs to docker log collector
    && ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log \

    # clean up
    && rm -rf /tmp/* /var/cache/apk/* /var/www/*

COPY .bashrc /root/
COPY nginx/conf.d/* /etc/nginx/conf.d/
COPY nginx/html /var/lib/nginx/html
COPY nginx/nginx.conf /etc/nginx/
COPY php/conf.d/* /etc/php7/conf.d/
COPY php/php.ini /etc/php7/
COPY php/php-fpm.conf /etc/php7/
COPY php/php-fpm.d/* /etc/php7/php-fpm.d/
COPY supervisor/supervisor.d/* /etc/supervisor.d/
COPY supervisor/supervisord.conf /etc/

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
