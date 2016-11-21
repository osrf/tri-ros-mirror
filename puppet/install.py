#!/usr/bin/env python


# Mostly copied from wg-buildfarm by Tully Foote

from optparse import OptionParser
import sys
import subprocess
import platform

def run_cmd(cmd, quiet=True, extra_args=None, feed=None):
    args = {'shell': True}
    if quiet:
        args['stderr'] = args['stdout'] = subprocess.PIPE
    if feed is not None:
        args['stdin'] = subprocess.PIPE
    if extra_args is not None:
        args.update(extra_args)
    p = subprocess.Popen(cmd, **args)
    if feed is not None:
        p.communicate(feed)
    return p.wait()

def get_ubuntu_version():
    return platform.dist()[2]

def is_ubuntu():
    return platform.dist()[0] == 'Ubuntu'

def configure_puppet():
    """
    Configure puppet in the system slave
     - Install puppet and git
     - donwload repo
     - run puppet
    """

    # do stuff with slave
    # first, install puppet
    print("updating apt")
    if run_cmd('apt-get update'):
        return False

    print("installing puppet, ruby and git")
    if run_cmd('apt-get install -y puppet ruby git'):
        return False

    print("installing puppet-librarian")
    if run_cmd('gem install librarian-puppet'):
        return False

    print("stopping puppet")
    # stop puppet
    if run_cmd('service puppet stop'):
        return False

    print("Clearing /etc/puppet")
    if run_cmd('rm -rf /etc/puppet'):
        return False

    print("cloning puppet repo")
    if run_cmd('git clone https://github.com/osrf/tri-ros-mirros.git /tmp/repo', quiet=False):
        return False
    if run_cmd('cp -a /tmp/repo/puppet/* /etc/puppet'):
        return False

    print("running puppet librarian to install modules")
    if run_cmd('pushd /tmp/deb-cache-tri/puppet/ && librarian-puppet install && popd', quiet=False):
        return False
 
    print("running puppet apply site.pp")
    if run_cmd('puppet apply /etc/puppet/manifests/site.pp', quiet=False):
        return False
 
    return True

parser = OptionParser()

if not is_ubuntu():
    print("Not ubuntu systems are not supported")
    sys.exit(-1)

configure_puppet()
