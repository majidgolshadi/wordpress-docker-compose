FROM alpine:latest

RUN \
    mkdir -p /var/lib/mysql && \
    mkdir -p /var/cache/nginx && \
    mkdir -p /var/www/html

VOLUME ["/var/lib/mysql", "/var/www/html", "/var/cache/nginx"]
