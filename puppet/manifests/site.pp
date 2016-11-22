import "files"
import "packages"
import "services"
import "users"

include packages
include users
include files
include services

include apt
include gpgkey

node default {

  class {  '::aptly' :
      config  => {
         'rootDir' => '/srv/aptly',
       },
  }

  gpgkey { 'aptly_key': 
    ensure    => present,
    keytype   => 'RSA',
    keylength =>  2048,
    name      => 'TRI ROS Mirror repo',
  }

  aptly::mirror { 'ros_stable':
    location      => 'http://packages.ros.org/ros/ubuntu',
    release       => 'trusty',
    architectures => ['amd64'],
    key           => 'B01FA116'
  }
}
