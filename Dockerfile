FROM debian:buster

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -y install \
       ffmpeg \
       ffmpegthumbnailer \
       gawk \
       imagemagick \
       nginx \
       python3 \
       socat \
       sudo \
       wget

RUN wget -O /usr/bin/dumb-init \
    https://github.com/Yelp/dumb-init/releases/download/v1.2.2/dumb-init_1.2.2_amd64 && \
    chmod +x /usr/bin/dumb-init

RUN wget -O /usr/bin/youtube-dl https://yt-dl.org/downloads/latest/youtube-dl && \
    chmod a+rx /usr/bin/youtube-dl && \
    ln -s /usr/bin/python3 /usr/bin/python && \
    mkdir /copycat && \
    mkdir /copycat/data && \
    chown -R www-data:www-data /copycat && \
    chown -R www-data:www-data /var/www

COPY bashttpd *.awk *.conf *.css *.ico *.sh /copycat/
COPY js/. /copycat/js/
COPY docker.nginx.site /etc/nginx/sites-available/default

EXPOSE 80
VOLUME /copycat/data

ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["/copycat/docker-boot.sh"]
