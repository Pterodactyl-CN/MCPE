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
RUN wget -O sg.tar.gz https://www.sourceguardian.com/loaders/download/loaders.linux-x86_64.tar.gz 
RUN mkdir sg 
RUN tar xvzf sg.tar.gz -C sg
RUN wget -O ioncube.tar.gz https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz
RUN tar xvzf ioncube.tar.gz
RUN cp ioncube/ioncube_loader_lin_7.2_ts.so /usr/local/PM_PHP/bin/php7/lib/php/extensions/ioncube_loader_lin_7.2_ts.so
RUN cp sg/ixed.7.2ts.lin /usr/local/PM_PHP/bin/php7/lib/php/extensions/ixed.7.2ts.lin
RUN echo 'zend_extension=/usr/local/PM_PHP/bin/php7/lib/php/extensions/ioncube_loader_lin_7.2_ts.so' >> /usr/local/PM_PHP/bin/php7/bin/php.ini
RUN echo 'zend_extension=/usr/local/PM_PHP/bin/php7/lib/php/extensions/ixed.7.2ts.lin' >> /usr/local/PM_PHP/bin/php7/bin/php.ini
RUN echo 'export PATH=/usr/local/PM_PHP/bin/php7/bin:$PATH' >> /etc/profile
RUN source /etc/profile
RUN rm -r bin
USER container
ENV  USER container
ENV  HOME /home/container

WORKDIR /home/container

COPY ./entrypoint.sh /entrypoint.sh

CMD ["/bin/bash", "/entrypoint.sh"]