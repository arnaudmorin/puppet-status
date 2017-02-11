#
# Mailops Team
#
# Add a probe to status

define status::probe (
  $ensure   = present,
  $source   = undef,
  $minute   = '*',
){
  File {
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
  }

  if ! $source {
    fail("Missing source, cannot set status::probe ${name}")
  }

  if $ensure == 'present' {
    file { "/usr/local/status/bin/${name}":
      ensure => file,
      source => $source,
    }

    cron { "status-probe-${name}":
      command   => "/usr/local/status/bin/${name}",
      user      => 'root',
      minute    => $minute,
    }
  }
  else {
    file { "/usr/local/status/bin/${name}":
      ensure => absent,
    }

    file { "/usr/local/status/results/${name}":
      ensure => absent,
    }

    cron { "status-probe-${name}":
      ensure => absent,
    }
  }
}
