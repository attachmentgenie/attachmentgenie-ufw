class ufw {
  package { 'ufw':
    ensure => present,
  }

  Package['ufw'] -> Exec['ufw-default-deny'] -> Exec['ufw-enable']

  exec { 'ufw-default-deny':
    command => '/usr/sbin/ufw default deny',
    unless  => 'ufw status verbose | grep "Default: deny (incoming), allow (outgoing)"',
  }

  exec { 'ufw-enable':
    command => '/usr/sbin/ufw --force enable',
    unless  => 'ufw status | grep "Status: active"',
  }

  service { 'ufw':
    ensure    => running,
    enable    => true,
    hasstatus => true,
    subscribe => Package['ufw'],
  }
}
