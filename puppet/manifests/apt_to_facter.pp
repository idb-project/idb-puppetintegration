class facts::apt_to_facter {

  #global schedule on when to update the sources lists.create new facts after that
  #only do this 3 times a day between relevant hours
  schedule { 'apt-to-facter-scheduler':
    period => daily,
    range  => '8-22',
    repeat => 3,
  }

  if ($::operatingsystem == 'ubuntu'and $::lsbmajdistrelease != '10') or ($::operatingsystem == 'debian' and $::lsbmajdistrelease != '8') {

include facts::base_dir

  ensure_packages(['bc', 'update-notifier-common'])

  file { '/usr/local/bin/apt_pending_updates_to_facter.sh':
    ensure => present,
    source => 'puppet:///modules/facts/apt_pending_updates_to_facter.sh',
    mode   => '0700',
  }

  exec { '/usr/bin/apt-get update':
    schedule => 'apt-to-facter-scheduler',
}


  exec { 'apt_pending_updates_to_facter.sh':
    path     => '/usr/bin:/usr/sbin:/bin:/sbin:/usr/local/bin:/usr/local/sbin',
    command  => '/bin/bash /usr/local/bin/apt_pending_updates_to_facter.sh',
    require  => [File['/usr/local/bin/apt_pending_updates_to_facter.sh'], File['/etc/facter/facts.d']],
    schedule => 'apt-to-facter-scheduler'
  }
}

  elsif  $::operatingsystem == 'Debian' and $::lsbmajdistrelease == '8' {

include facts::base_dir

  file { '/usr/local/bin/apt_pending_updates_to_facter.sh':
    ensure => present,
    source => 'puppet:///modules/facts/apt_pending_updates_to_facter.sh',
    mode   => '0700',
  }

  exec { '/usr/bin/apt-get update':
    schedule => 'apt-to-facter-scheduler',
}

  exec { 'apt_pending_updates_to_facter.sh':
    path     => '/usr/bin:/usr/sbin:/bin:/sbin:/usr/local/bin:/usr/local/sbin',
    command  => '/bin/bash /usr/local/bin/apt_pending_updates_to_facter.sh',
    require  => [File['/usr/local/bin/apt_pending_updates_to_facter.sh'], File['/etc/facter/facts.d']],
    schedule => 'apt-to-facter-scheduler'
  }
}
}

