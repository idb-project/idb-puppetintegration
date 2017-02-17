class facts::zypper_to_facter {

  #global schedule on when to refresh repos and create new facts after that
  #only do this 3 times a day between relevant hours
  schedule { 'zypper-to-facter-scheduler':
    period => daily,
    range  => '8-22',
    repeat => 3,
  }

include facts::base_dir


  file { '/usr/local/bin/zypper_pending_updates_to_facter.sh':
    ensure => present,
    source => 'puppet:///modules/facts/zypper_pending_updates_to_facter.sh',
    mode   => '0700',
  }

  exec { '/usr/bin/zypper refresh':
    schedule => 'zypper-to-facter-scheduler',
}


  exec { 'zypper_pending_updates_to_facter.sh':
    path     => '/usr/bin:/usr/sbin:/bin:/sbin:/usr/local/bin:/usr/local/sbin',
    command  => '/bin/bash /usr/local/bin/zypper_pending_updates_to_facter.sh',
    require  => [File['/usr/local/bin/zypper_pending_updates_to_facter.sh'], File['/etc/facter/facts.d']],
    schedule => 'zypper-to-facter-scheduler'
  }
}
