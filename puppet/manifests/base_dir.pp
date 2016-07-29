class facts::base_dir {

  if $::operatingsystem == 'OpenBSD' {
    $owner = 'root'
    $group = 'wheel'
  } else {
    $owner = 'root'
    $group = 'root'
  }


  File { owner => $owner, group => $group, mode => '0755' }

  file { ['/etc/facter', '/etc/facter/facts.d']:
    ensure => directory,
  }
}
