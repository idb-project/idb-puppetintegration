class facts::idrac_ip_to_facter {

  #global schedule on when to update the sources lists.create new facts after that
  #only do this 3 times a day between relevant hours
  schedule { 'idrac-ip-to-facter-scheduler':
    period => daily,
    range  => '18-19',
    repeat => 1,
  }

include facts::base_dir

  file { '/usr/local/bin/idrac_ip_to_facter.sh':
    ensure => present,
    source => 'puppet:///modules/facts/idrac_ip_to_facter.sh',
    mode   => '0700',
  }

  exec { 'create_idrac_ip_fact':
    command  => '/bin/bash /usr/local/bin/idrac_ip_to_facter.sh',
    require  => [File['/usr/local/bin/idrac_ip_to_facter.sh'], File['/etc/facter/facts.d']],
    schedule => 'idrac-ip-to-facter-scheduler'
  }
}
