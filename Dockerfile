# Pterodactyl Core Dockerfile
# Environment: GLIBC (glibc support)
# Minimum Panel Version: 0.6.0
# ----------------------------------
FROM        centos

MAINTAINER  Misakacloud, <admin@misakacloud.cn>

RUN yum update -y \
    && yum install glibc -y
COPY ./libmvec.so /usr/lib64/libmvec.so
RUN ln -sf /usr/lib64/libmvec.so /usr/lib64/libmvec.so.1
RUN wget https://jenkins.pmmp.io/job/PHP-7.2-Linux-x86_64/lastSuccessfulBuild/artifact/PHP_Linux-x86_64.tar.gz
RUN tar xvzf PHP_Linux-x86_64.tar.gz 
RUN mkdir /usr/local/PM_PHP
RUN cp -R bin /usr/local/PM_PHP/
RUN echo 'export PATH=/usr/local/PM_PHP/bin/php7/bin:$PATH' >> /etc/profile
COPY ./libstdc++.so.6.0.22 /usr/lib64/libstdc++.so.6.0.22
RUN  ln -sf /usr/lib64/libstdc++.so.6.0.22 /usr/lib64/libstdc++.so.6
COPY ./libstdc++.so.6.0.22 /usr/lib/libstdc++.so.6.0.22
RUN  ln -sf /usr/lib/libstdc++.so.6.0.22 /usr/lib/libstdc++.so.6
RUN source /etc/profile
USER container
ENV  USER container
ENV  HOME /home/container

WORKDIR /home/container

COPY ./entrypoint.sh /entrypoint.sh

CMD ["/bin/bash", "/entrypoint.sh"]
