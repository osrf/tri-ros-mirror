$confdir_setting = $settings::confdir

class files {

  define delete_lines($file, $pattern) {
    exec { "/bin/sed -i -r -e '/$pattern/d' $file":
        onlyif => "/bin/grep -E '$pattern' '$file'",
    }
  }

  file_line { "/etc/sudoers":
    ensure => present,
    line   => 'jenkins ALL=(ALL) NOPASSWD:ALL',
    path   => '/etc/sudoers',
  }

  package { "sudo" : 
    ensure => installed,
    before => File_line['/etc/sudoers'],
  }

  # jenkins-slave script seems not be work from the init/rc.2 system
  # workaround by using rc.local
  file_line { "/etc/rc.local":
    ensure => present,
    line   => 'sleep 20 && service jenkins-slave restart',
    path   => '/etc/rc.local',
  }

  delete_lines { "remove exit rc.local":
    file => "/etc/rc.local",
    pattern => "^exit 0",
  }
}
