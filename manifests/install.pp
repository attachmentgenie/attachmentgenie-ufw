#  Installs and enables Ubuntu's "uncomplicated" firewall.
#
class ufw::install inherits ufw {
  package { 'ufw':
    ensure => present,
  }
  Package['ufw'] -> Exec['ufw-default-deny'] -> Exec['ufw-enable']
}