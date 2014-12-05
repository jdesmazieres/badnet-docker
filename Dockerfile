FROM tutum/lamp
MAINTAINER Jacques Desmazieres <jacques.desmazieres@gmail.com>

# install unzip command
RUN apt-get -q -y install unzip wget

# Apache badnet virtualhost configuration (port: 8080)
RUN rm -f /etc/apache2/sites-available/000-default.conf
ADD scripts/000-default.conf /etc/apache2/sites-available/000-default.conf

# create badnet deploy dir
RUN mkdir -p /badnet/archive && mkdir -p /badnet/scripts
ADD scripts/*.sh /badnet/scripts/
RUN chmod +x /badnet/scripts/*.sh

# install Badnet web site
# a) from zip archive previously downloaded
ADD resources/*.zip /badnet/archive/

# b) ideally, retrieve badnet from a git repository
# git clone https://github.com/username/customapp.git /badnet

# c) alternativelly download lastest version of badnet from badnet.org
# RUN wget -O /badnet/archive/badnet.zip http://www.badnet.org/badnet/src/index.php?bnAction=65542&file=badnet_v2.9r2.zip&ajax=false

RUN /badnet/scripts/install-badnet.sh

# expose Http and MySql ports for external connection
EXPOSE 80 3306

CMD ["/run.sh"]

