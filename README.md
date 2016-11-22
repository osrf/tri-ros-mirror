# tri-ros-mirror

Repository containing code related to the creato of a ROS mirror
* puppet/ (puppet scripts to setup the server)

## Install
* `git clone https://github.com/osrf/tri-ros-mirror.git`
* `cd tri-ros-mirror/puppet/`
* `sudo python install.py`

#### Manual installation
* `sudo gpg --gen-keys`
* `sudo gpg --no-default-keyring --keyring trustedkeys.gpg --keyserver keys.gnupg.net --recv-keys 5523BAEEB01FA116`
* `sudo /usr/bin/aptly -config /etc/aptly.conf mirror create -architectures="amd64" -with-sources=false -with-udebs=false ros_stable http://packages.ros.org/ros/ubuntu trusty`

## Update the internal mirror
* `sudo aptly mirror update ros_stable`

## Create an internal snapshot of the mirror
* `sudo aptly snapshot create <snapshot_name> from mirror ros_stable`

## Publish/Update from the internal snapshot to the visible repo
* `sudo aptly publish snapshot <snapshot_name>`
