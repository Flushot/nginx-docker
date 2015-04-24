#!/usr/bin/env python
from __future__ import with_statement

from fabric.api import task, run, local, settings, abort, cd, env, execute
from fabric.operations import sudo

IMAGE_NAME = 'nginx_img'
CONTAINER_NAME = 'nginx_cont'


@task
def build():
    """
    Builds the Docker container image.
    """
    local('docker build --rm -t %s .' % IMAGE_NAME)


@task
def clean():
    """
    Clean the Docker image.
    """
    stop_if_running()

    local('docker rmi -f %s' % IMAGE_NAME)


@task
def clean_untagged():
    """
    Clean untagged Docker images.
    These usually get left behind after repeated builds.
    """
    clean()

    local(r'docker rmi -f $(docker images | grep "^<none>" | awk "{print \$3}")')


@task
def start():
    """
    Starts the Docker container.
    """
    stop_if_running()

    # Start new container
    local('docker run --name %s -d -p 80:80/tcp %s' % (CONTAINER_NAME, IMAGE_NAME))


def stop_if_running():
    # Stop the container if it's already running
    with settings(warn_only=True):
        stop()

@task
def stop():
    """
    Stops the Docker container.
    """
    local('docker stop %s' % CONTAINER_NAME)
    local('docker rm -f %s' % CONTAINER_NAME)


@task(default=True)
def default():
    """
    Default Fabric task.
    """
    build()
    start()
