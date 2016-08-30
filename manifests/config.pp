#  Installs and enables Ubuntu's "uncomplicated" firewall.
#
class ufw::config inherits ufw {
  exec { "ufw-logging-${::ufw::log_level}":
    command => "ufw logging ${::ufw::log_level}",
    unless  => "grep -qE '^LOGLEVEL=${::ufw::log_level}$' /etc/ufw/ufw.conf",
    require => Exec['ufw-default-deny'],
    before  => Exec['ufw-enable'],
  }

  exec { 'ufw-default-deny':
    command => 'ufw default deny',
    unless  => 'ufw status verbose | grep -q "Default: deny (incoming)"',
  }

  if ($::ufw::deny_outgoing) {
    exec { 'ufw-default-deny-outgoing':
      command => 'ufw default deny outgoing',
      unless  => 'ufw status verbose | grep -q "Default: deny (outgoing)"',
    }
  }

  file_line { 'forward policy':
    line    => "DEFAULT_FORWARD_POLICY=\"${::ufw::forward}\"",
    match   => '^DEFAULT_FORWARD_POLICY=',
    notify  => Service['ufw'],
    path    => '/etc/default/ufw',
    require => Package['ufw'],
  }
}