class services  {
  service { "jenkins-slave":
       enable => true,
       ensure => running,
       hasrestart => true,
  }

  # The aptly service won't start as long as nothing has been published in it 
  # service { "aptly":
  #     enable => true,
  #     ensure => running,
  #     hasrestart => true,
  # }
}
