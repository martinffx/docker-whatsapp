FROM ubuntu:15.04
MAINTAINER Martinffx <martinffx@gmail.com>

# Updates apt repository
RUN apt-get update -y

# Installs PHP5.6, some extensions and apcu.
RUN apt-get install -y software-properties-common
RUN add-apt-repository ppa:ondrej/php5-5.6
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y php5 php5-dev

# Installs curl, pear, wget, git, memcached and mysql-server
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y curl php-pear wget git memcached

#Installs PHPUnit
RUN wget https://phar.phpunit.de/phpunit.phar
RUN chmod +x phpunit.phar
RUN mv phpunit.phar /usr/local/bin/phpunit

# Installs Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Installs PHP CodeSniffer
RUN pear install PHP_CodeSniffer

# Fetches a sample php.ini file with most configurations already good-to-go.
RUN wget https://raw.githubusercontent.com/naroga/docker-php56/master/php.ini
RUN rm -r /etc/php5/cli/php.ini
RUN cp php.ini /etc/php5/cli/php.ini

# Whatsapp dependencies
ADD ./dependencies.sh /tmp/start.sh
RUN chmod +x /tmp/start.sh
RUN /tmp/start.sh
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y ffmpeg
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y php5-gd
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y php5-curl
# RUN apt-get install -y libapache2-mod-php5  #php5-sockets
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y php5-sqlite
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y php5-mcrypt
RUN php5enmod mcrypt

# Tests build
RUN php -v
RUN phpunit --version
RUN composer --version
RUN phpcs --version
RUN php -i | grep timezone
RUN php -r "echo json_encode(get_loaded_extensions());"
