# Class ufw
#
#  Installs and enables Ubuntu's "uncomplicated" firewall.
#
#  Be careful calling this class alone, it will by default enable ufw
# and disable all incoming traffic.
class ufw(
  $allow   = {},
  $deny    = {},
  $forward = 'DROP',
  $limit   = {},
  $logging = {},
  $reject  = {},
) {

  validate_re($forward, 'ACCEPT|DROP|REJECT')

  Exec {
    path     => '/bin:/sbin:/usr/bin:/usr/sbin',
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
    line    => "DEFAULT_FORWARD_POLICY=\"${forward}\"",
    match   => '^DEFAULT_FORWARD_POLICY=',
    notify  => Service['ufw'],
    path    => '/etc/default/ufw',
    require => Package['ufw'],
  }

  service { 'ufw':
    ensure    => running,
    enable    => true,
    hasstatus => true,
    subscribe => Package['ufw'],
  }

  # Hiera resource creation
  create_resources('::ufw::allow',  $allow)
  create_resources('::ufw::deny', $deny)
  create_resources('::ufw::limit', $limit)
  create_resources('::ufw::logging', $logging)
  create_resources('::ufw::reject', $reject)
}
