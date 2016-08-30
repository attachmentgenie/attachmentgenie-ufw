#  Installs and enables Ubuntu's "uncomplicated" firewall.
#
class ufw::service inherits ufw {
  $manage_service_ensure = $::ufw::manage_service ? {
    true    => 'running',
    false   => undef,
    default => undef,
  }

  service { $::ufw::service_name:
    ensure    => $manage_service_ensure,
    enable    => true,
    hasstatus => true,
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
}
