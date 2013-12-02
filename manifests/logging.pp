# Define ufw::logging
#
#   configure ufw's log verbosity
#
define ufw::logging($level='low') {

  exec { "ufw-logging-${level}":
    command  => "ufw logging ${level}",
    path     => '/usr/sbin:/bin:/usr/bin',
    provider => 'posix',
    require  => Exec['ufw-default-deny'],
    before   => Exec['ufw-enable'],
  }
}
