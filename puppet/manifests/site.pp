import "files"
import "packages"
import "services"
import "users"

include packages
include users
include files
include services

include apt
include aptly

node default {

  aptly::mirror { 'ros_stable':
    location      => 'http://packages.ros.org/ros/ubuntu',
    release       => 'trusty',
    architectures => ['amd64'],
    key           => 'B01FA116'
  }
}
