class facts::yum_to_facter {

  if ($::operatingsystem == 'centos') {


  include facts::base_dir

  file { '/usr/local/bin/yum_pending_updates_to_facter.sh':
    ensure => present,
    source => 'puppet:///modules/facts/yum_pending_updates_to_facter.sh',
    mode   => '0700',
  }

  #global schedule on when to update the sources lists.create new facts after that
  #only do this 3 times a day between relevant hours
  schedule { 'yum-to-facter-scheduler':
    period => daily,
    range  => '8-22',
    repeat => 3,
  }


  exec { 'yum_pending_updates_to_facter.sh':
    path     => '/usr/bin:/usr/sbin:/bin:/sbin:/usr/local/bin:/usr/local/sbin',
    command  => '/bin/bash /usr/local/bin/yum_pending_updates_to_facter.sh',
    require  => [File['/usr/local/bin/yum_pending_updates_to_facter.sh'], File['/etc/facter/facts.d']],
    schedule => 'yum-to-facter-scheduler'
  }
}
}

