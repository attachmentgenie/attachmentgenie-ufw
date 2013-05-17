define ufw::logging($level='low') {

  exec { "ufw-logging-${level}":
    command => "ufw logging $level",
    require => Exec['ufw-default-deny'],
    before  => Exec['ufw-enable'],
  }
}
