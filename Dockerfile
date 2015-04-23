FROM ubuntu:trusty
MAINTAINER Chris Lyon

# Install software
RUN apt-get update
RUN apt-get install -y nano wget dialog net-tools
RUN apt-get install -y build-essential git
RUN apt-get install -y python python-dev python-setuptools
RUN apt-get install -y nginx nginx-extras supervisor
RUN easy_install pip
RUN pip install uwsgi

# Configure nginx
RUN rm -v /etc/nginx/nginx.conf
ADD nginx.conf /etc/nginx/

# Expose ports
EXPOSE 80

# Default command to run when container is started
CMD export DOCKER_HOST_IP="$(ip route | awk "/default/ { print \$3 }")" ; service nginx start
