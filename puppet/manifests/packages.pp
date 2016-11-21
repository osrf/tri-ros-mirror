class packages {

  package { "wget"            : ensure => installed }
  package { "git"             : ensure => installed }
  package { "vim"             : ensure => installed }
  package { "ntp"             : ensure => installed }
  package { "bash-completion" : ensure => installed }
  package { "default-jre-headless" : ensure => installed }

  /*
  aptly::mirror { 'puppetlabs':
    location => 'http://apt.puppetlabs.com/',
    repos    => ['main'],
    key      => '7F438280EF8D349F',
  }
  */

  define url-package ($url, $provider, $package = undef)
  {
    if $package {
      $package_real = $package
    } else {
      $package_real = $title
    }

    $package_path = "/tmp/${package_real}"

    exec {'download':
      command => "/usr/bin/wget -O ${package_path} ${url}"
    }

    package {'install':
      ensure    => installed,
      name      => "${package}",
      provider => 'dpkg',
      source    => "${package_path}",
    }

    file {'cleanup':
      ensure => absent,
      path    => "${package_path}",
    }

    Exec['download'] -> Package['install'] -> File['cleanup']
  }

  url-package { "jenkins-slave" :
    provider  => dpkg,
    url       => 'http://packages.osrfoundation.org/gazebo/ubuntu/pool/main/j/jenkins/jenkins-slave_1.509.2+dfsg-2_all.deb',
  }
}
