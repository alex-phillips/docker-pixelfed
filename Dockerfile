FROM lsiobase/alpine.nginx:3.8

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="alex-phillips"

RUN \
 echo "**** install build packages ****" && \
 apk add --no-cache --virtual=build-dependencies \
    composer \
    curl \
    git && \
 echo "**** install runtime packages ****" && \
 apk add --no-cache \
    grep  \
    logrotate \
    ncurses \
    php7 \
    php7-bcmath \
    php7-ctype \
    php7-curl \
    php7-dom \
    php7-exif \
    php7-gd \
    php7-iconv \
    php7-json \
    php7-mbstring \
    php7-pcntl \
    php7-pdo \
    php7-pdo_mysql \
    php7-posix \
    php7-session \
    php7-tokenizer && \
 echo "**** install pixelfed ****" && \
 git clone https://github.com/pixelfed/pixelfed.git /app/pixelfed && \
 echo "**** install composer packages ****" && \
 cd /app/pixelfed && \
 /usr/bin/composer install --no-dev --no-interaction && \
 echo "**** cleanup ****" && \
 apk del --purge \
    build-dependencies && \
 rm -rf \
    /root/.cache \
    /tmp/*

# copy local files
COPY root/ /

# ports and volumes
VOLUME /config
