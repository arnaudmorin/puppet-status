#
# Mailops Team
#
# Configure status

class status {
  File {
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
  }

  file { '/usr/local/status':
    ensure  => directory,
  }

  file { '/usr/local/status/bin':
    ensure  => directory,
    require => File['/usr/local/status'],
    purge   => true,
  }

  file { '/usr/local/status/lib':
    ensure  => directory,
    source  => "puppet:///modules/${module_name}/lib",
    recurse => true,
    purge   => true,
    require => File['/usr/local/status'],
  }

  file { '/usr/local/status/results':
    ensure  => directory,
    require => File['/usr/local/status'],
  }

  file { '/usr/local/bin/status':
    ensure  => file,
    source  => "puppet:///modules/${module_name}/bin/status",
  }

  bash::alias { 's':
    content => 'run-parts /usr/local/status/bin/ ; /usr/local/bin/status --debug | ccze -A',
  }

  class { '::xinetd': }

  ::xinetd::service { 'status':
    port        => '7979',
    server      => '/usr/local/bin/status',
  }

  ::etc_services { 'status/tcp':
    port    => '7979',
    comment => 'status service from mailops team'
  }
  
  file { '/etc/logrotate.d/status':
    ensure  => file,
    source  => "puppet:///modules/${module_name}/logrotate.d/status",
    mode    => '0644',
  }
}
