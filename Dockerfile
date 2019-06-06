FROM ubuntu:16.04

COPY ./sources.list /etc/apt/sources.list
RUN apt-get update

RUN apt-get install software-properties-common python-software-properties language-pack-en-base vim git wget curl -y
RUN locale-gen en_US.UTF-8

ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8

RUN add-apt-repository ppa:ondrej/php && \
    apt-get update

RUN apt-get install php7.2-fpm php7.2-gd php7.2-cli php7.2-curl php7.2-dev php7.2-json php7.2-mbstring php7.2-mcrypt php7.2-mysql php7.2-xml php7.2-zip php7.2-opcache php-redis php7.2-mongodb -y --fix-missing

# install phalcon
RUN curl -s https://packagecloud.io/install/repositories/phalcon/stable/script.deb.sh | bash && \
    apt-get install php7.2-phalcon -y

RUN pecl install swoole && \
    echo "extension=swoole.so" > /etc/php/7.2/mods-available/swoole.ini && \
    ln -s /etc/php/7.2/mods-available/swoole.ini /etc/php/7.2/cli/conf.d/20-swoole.ini && \
    ln -s /etc/php/7.2/mods-available/swoole.ini /etc/php/7.2/fpm/conf.d/20-swoole.ini

RUN cd / && \
    php -r "copy('https://install.phpcomposer.com/installer', 'composer-setup.php');" && \
    php composer-setup.php && \
    php -r "unlink('composer-setup.php');" && \
    mv composer.phar /usr/local/bin/composer && \
    composer config -g repo.packagist composer https://packagist.phpcomposer.com

# install supervisor , cron
RUN apt-get install supervisor cron --allow-unauthenticated -y
RUN service supervisor start

# generate ssh key
RUN ssh-keygen -f 'id_rsa' -t rsa -N ''

# clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /home/wwwroot

COPY ./fpm-pool-www.conf /etc/php/7.2/fpm/pool.d/www.conf
RUN mkdir /run/php/ -p

EXPOSE 9000
CMD ["/usr/sbin/php-fpm7.2", "-F"]