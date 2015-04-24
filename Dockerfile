FROM ubuntu:trusty

MAINTAINER Chris Lyon <flushot@gmail.com>
LABEL version="1.0"
LABEL description="Simple Docker container for Flask reverse proxy"

# Common utils
RUN apt-get update
RUN apt-get install -y nano unzip net-tools build-essential git

# Configure uwsgi and supervisor
RUN apt-get install -y python python-dev python-setuptools
RUN easy_install pip
RUN pip install supervisor
RUN pip install uwsgi

# Configure nginx
RUN apt-get install -y nginx nginx-extras
RUN rm -v /etc/nginx/nginx.conf
ADD container_files/nginx.conf /etc/nginx/
EXPOSE 80

# Configure consul
ADD https://dl.bintray.com/mitchellh/consul/0.5.0_linux_amd64.zip /tmp/
ADD container_files/consul.conf /etc/init/
RUN mkdir /etc/consul.d
# TODO: Add consul configuration files
RUN cd /tmp && unzip 0.5.0_linux_amd64.zip && mv consul /usr/local/bin
EXPOSE 8300 8301 8301/udp 8302 8302/udp 8400 8500

# Default command to run when container is started
ADD container_files/init_container /usr/local/bin/
RUN chmod 755 /usr/local/bin/init_container
CMD init_container
