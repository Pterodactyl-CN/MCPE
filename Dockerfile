# Pterodactyl Core Dockerfile
# Environment: GLIBC (glibc support)
# Minimum Panel Version: 0.6.0
# ----------------------------------
FROM        frolvlad/alpine-glibc

MAINTAINER  Misakacloud, <admin@misakacloud.cn>

RUN         apk add --update --no-cache curl ca-certificates openssl libstdc++ busybox-extras \
            && apk add libc++ jq --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
            && apk add --update --no-cache curl ca-certificates openssl git tar bash sqlite \
            && adduser -D -h /home/container container


RUN wget https://jenkins.pmmp.io/job/PHP-7.2-Linux-x86_64/lastSuccessfulBuild/artifact/PHP_Linux-x86_64.tar.gz
RUN tar xvzf PHP_Linux-x86_64.tar.gz 
RUN mkdir /usr/local/PM_PHP
RUN cp -R bin /usr/local/PM_PHP/
RUN echo 'export PATH=/usr/local/PM_PHP/bin/php7/bin:$PATH' >> /etc/profile
RUN source /etc/profile
RUN rm -r bin
USER container
ENV  USER container
ENV  HOME /home/container

WORKDIR /home/container

COPY ./entrypoint.sh /entrypoint.sh

CMD ["/bin/ash", "/entrypoint.sh"]