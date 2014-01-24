# Class ufw
#
#  installs and enables Ubuntu's "uncomplicated" firewall.
#  Careful calling this class alone, was it will by default
#  enable ufw, and disable all incoming traffic.
class ufw(
  $allows   = {},
  $denies   = {},
  $limits   = {},
  $loggings = {},
  $rejects  = {},
  ) {

  Exec {
    path     => '/usr/sbin:/bin:/usr/bin',
    provider => 'posix',
  }

  package { 'ufw':
    ensure => present,
  }

  Package['ufw'] -> Exec['ufw-default-deny'] -> Exec['ufw-enable']

  exec { 'ufw-default-deny':
    command => 'ufw default deny',
    unless  => 'ufw status verbose | grep -q "Default: deny (incoming), allow (outgoing)"',
  }

  exec { 'ufw-enable':
    command => 'ufw --force enable',
    unless  => 'ufw status | grep -q "Status: active"',
  }

  service { 'ufw':
    ensure    => running,
    enable    => true,
    hasstatus => true,
    subscribe => Package['ufw'],
  }

  # Hiera resource creation
  create_resources('ufw::allow', $allows)
  create_resources('ufw::deny', $denies)
  create_resources('ufw::limit', $limits)
  create_resources('ufw::logging', $loggings)
  create_resources('ufw::reject', $rejects)
}
