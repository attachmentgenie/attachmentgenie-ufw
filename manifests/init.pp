# Class ufw
#
#  installs and enables Ubuntu's "uncomplicated" firewall.
#  Careful calling this class alone, was it will by default
#  enable ufw, and disable all incoming traffic.
class ufw(
  $allow   = {},
  $deny    = {},
  $limit   = {},
  $logging = {},
  $reject  = {},
  $forward = 'DROP',
) {

  validate_re($forward, 'ACCEPT|DROP|REJECT')

  Exec {
    path     => '/sbin:/usr/sbin:/bin:/usr/bin',
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

  case $::lsbdistcodename {
    'squeeze': {
      exec { 'ufw-enable':
        command => 'yes | ufw enable',
        unless  => 'ufw status | grep "Status: active"',
      }
    }
    default: {
      exec { 'ufw-enable':
        command => 'ufw --force enable',
        unless  => 'ufw status | grep "Status: active"',
      }
    }
  }

  file_line { 'forward policy':
    path   => '/etc/default/ufw',
    line   => "DEFAULT_FORWARD_POLICY=\"${forward}\"",
    match  => '^DEFAULT_FORWARD_POLICY=',
    notify => Service['ufw'],
  }

  service { 'ufw':
    ensure    => running,
    enable    => true,
    hasstatus => true,
    subscribe => Package['ufw'],
  }

  # Hiera resource creation
  create_resources('ufw::allow', hiera_hash('ufw::allow', $allow))
  create_resources('ufw::deny', hiera_hash('ufw::deny', $deny))
  create_resources('ufw::limit', hiera_hash('ufw::limit', $limit))
  create_resources('ufw::logging', hiera_hash('ufw::logging', $logging))
  create_resources('ufw::reject', hiera_hash('ufw::reject', $reject))
}
