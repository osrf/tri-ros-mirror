import "files"
import "packages"
import "services"
import "users"

include apt
include packages
include users
include files
include services

node default {

  $aptly_root_dir         = '/srv/aptly'
  $aptly_public_dir       = "$aptly_root_dir/public"
  $aptly_published_name   = "ros-stable-trusty-pkgs"

  file { [ $aptly_root_dir, $aptly_public_dir] :
    ensure => 'directory',
  }

  class {  '::aptly' :
      config => {
         'rootDir' => "$aptly_public_dir"
       },
  }

  aptly::mirror { 'ros_stable':
    location      => 'http://packages.ros.org/ros/ubuntu',
    release       => 'trusty',
    architectures => ['amd64'],
    key           => 'B01FA116'
  }

  class { 'apache':
    default_vhost => false,
  }

  $apache_doc_root = "$aptly_public_dir/$aptly_published_name"

  apache::vhost { 'mirror site':
    servername => 'my_server',
    port       => '80',
    docroot    => "$apache_doc_root",
    ssl        => true,
    options    => 'Indexes MultiViews',
  }

  gnupg_key { 'ros_repo_key_root':
    ensure     => present,
    key_id     => 'B01FA116',
    user       => 'root',
    key_server => 'hkp://ha.pool.sks-keyservers.net:80',
    key_type   => public,
  }
}
