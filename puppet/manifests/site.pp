import "files"
import "packages"
import "services"
import "users"

include packages
include users
include files
include services

include apt

node default {

  class {  '::aptly' :
      config => {
         'rootDir' => '/srv/aptly',
       },
  }

  aptly::mirror { 'ros_stable':
    location      => 'http://packages.ros.org/ros/ubuntu',
    release       => 'trusty',
    architectures => ['amd64'],
    key           => 'B01FA116'
  }
}
