class users {

  user { "jenkins":
       ensure     => 'present',
       shell      => '/bin/bash',
       managehome => 'true',
       groups     => 'sudo',
  }

  gnupg_key { 'ros_repo_key_jenkins':
    ensure     => present,
    key_id     => 'B01FA116',
    user       => 'jenkins',
    key_server => 'hkp://ha.pool.sks-keyservers.net:80',
    key_type   => public,
    require    => User['jenkins']
  }
}
