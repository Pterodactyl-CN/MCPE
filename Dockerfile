# Pterodactyl Core Dockerfile
# Environment: GLIBC (glibc support)
# Minimum Panel Version: 0.6.0
# ----------------------------------
FROM        centos

MAINTAINER  Misakacloud, <admin@misakacloud.cn>

RUN yum update -y \
    && yum install glibc wget curl python -y
RUN mkdir -p /usr/local/PM_PHP/
RUN wget https://jenkins.pmmp.io/job/PHP-7.2-Linux-x86_64/lastSuccessfulBuild/artifact/PHP_Linux-x86_64.tar.gz
RUN tar xvzf PHP_Linux-x86_64.tar.gz -C /usr/local/PM_PHP/
RUN rm PHP_Linux-x86_64.tar.gz
RUN echo 'export PATH=/usr/local/PM_PHP/bin/php7/bin:$PATH' >> /etc/profile
COPY ./libmvec.so /usr/lib64/libmvec.so
RUN ln -sf /usr/lib64/libmvec.so /usr/lib64/libmvec.so.1
COPY ./libstdc++.so.6.0.25 /usr/lib64/libstdc++.so.6.0.25
RUN  ln -sf /usr/lib64/libstdc++.so.6.0.25 /usr/lib64/libstdc++.so.6
COPY ./libstdc++.so.6.0.25 /usr/lib/libstdc++.so.6.0.25
RUN  ln -sf /usr/lib/libstdc++.so.6.0.25 /usr/lib/libstdc++.so.6
RUN wget -O sg.tar.gz https://www.sourceguardian.com/loaders/download/loaders.linux-x86_64.tar.gz 
RUN mkdir sg 
RUN tar xvzf sg.tar.gz -C sg
RUN wget -O ioncube.tar.gz https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz
RUN tar xvzf ioncube.tar.gz
RUN rm ioncube.tar.gz sg.tar.gz
RUN mkdir -p /usr/local/PM_PHP/bin/php7/lib/php/extensions/
RUN cp ioncube/ioncube_loader_lin_7.2_ts.so /usr/local/PM_PHP/bin/php7/lib/php/extensions/ioncube_loader_lin_7.2_ts.so
RUN cp sg/ixed.7.2ts.lin /usr/local/PM_PHP/bin/php7/lib/php/extensions/ixed.7.2ts.lin
RUN echo 'zend_extension=/usr/local/PM_PHP/bin/php7/lib/php/extensions/ioncube_loader_lin_7.2_ts.so' >> /usr/local/PM_PHP/bin/php7/bin/php.ini
RUN echo 'zend_extension=/usr/local/PM_PHP/bin/php7/lib/php/extensions/ixed.7.2ts.lin' >> /usr/local/PM_PHP/bin/php7/bin/php.ini
RUN source /etc/profile
RUN ln -sf /usr/local/PM_PHP/bin/php7/bin/php /bin/php
USER container
ENV  USER container
ENV  HOME /home/container

WORKDIR /home/container

COPY ./entrypoint.sh /entrypoint.sh

CMD ["/bin/bash", "/entrypoint.sh"]
