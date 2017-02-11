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
  }

  file { '/usr/local/status/lib':
    ensure  => directory,
    source  => "puppet:///${module_name}/lib",
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
    source  => "puppet:///${module_name}/bin/status",
  }

  bash::alias { 'status-run':
    content => 'run-parts /usr/local/status/bin/ ; /usr/local/bin/status | ccze -A',
  }

  class { '::xinetd': }

  xinetd::service { 'status':
    port        => '7979',
    server      => '/usr/local/bin/status',
  }
}
