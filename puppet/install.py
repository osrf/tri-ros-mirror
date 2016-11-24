#!/usr/bin/env python


# Mostly copied from wg-buildfarm by Tully Foote

import argparse

import sys
import subprocess
import platform

REPO_TMP_DIR   = '/tmp/repo'
PUPPET_TMP_DIR = REPO_TMP_DIR + '/puppet'

class Command:
    def __init__(self, _force_verbose=False):
        self.force_verbose = _force_verbose

    def run(self, cmd, quiet=True, extra_args=None, feed=None):
        args = {'shell': True}
        if not self.force_verbose and quiet:
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

def configure_puppet(args):
    """
    Configure puppet in the system slave
     - Install puppet and git
     - donwload repo
     - run puppet
    """

    cmd = Command(_force_verbose=args.verbose)

    # do stuff with slave
    # first, install puppet
    print("updating apt")
    if cmd.run('apt-get update'):
        return False

    print("installing puppet and git")
    if cmd.run('apt-get install -y puppet git'):
        return False

    print("installing puppet-librarian")
    if cmd.run('gem install librarian-puppet'):
        return False

    print("stopping puppet")
    # stop puppet
    if cmd.run('service puppet stop'):
        return False

    print("Clearing /etc/puppet and temp repo")
    if cmd.run('rm -rf /etc/puppet && mkdir /etc/puppet'):
        return False
    if cmd.run('rm -rf ' + REPO_TMP_DIR + 'mkdir ' + REPO_TMP_DIR):
        return False

    print("cloning puppet repo")
    if cmd.run('git clone https://github.com/osrf/tri-ros-mirror.git ' +
                                                                REPO_TMP_DIR):
        return False

    print("running puppet librarian to install modules")
    # can not use pushd (bash not default in shell called from python)
    if cmd.run('cd ' + PUPPET_TMP_DIR + ' && ' +
               'librarian-puppet install && ' +
               'cd -'):
        return False
    
    if cmd.run('cp -a /tmp/repo/puppet/* /etc/puppet'):
        return False

    print("running puppet apply site.pp")
    if cmd.run('puppet apply /etc/puppet/manifests/site.pp'):
        return False

    return True

parser = argparse.ArgumentParser()
parser.add_argument("--verbose",
                  action="store_true",
                  dest="verbose", default=False,
                  help="enable debug messages")
args = parser.parse_args()

if not is_ubuntu():
    print("Not ubuntu systems are not supported")
    sys.exit(-1)

configure_puppet(args)
