#  Installs and enables Ubuntu's "uncomplicated" firewall.
#
#  Be careful calling this class alone, it will by default enable ufw
# and disable all incoming traffic.
#
#
# @example when declaring the ufw class
#  ufw::deny { 'deny-ssh-from-all':
#    port => '22',
#  }
#
# @param proto (String) Protocol to use default: tcp
define ufw::limit(
  $proto='tcp'
) {
  validate_re($proto, 'tcp|udp')

  exec { "ufw limit ${name}/${proto}":
    path     => '/usr/sbin:/bin:/usr/bin',
    provider => 'posix',
    unless   => "ufw status | grep -qE '^${name}/${proto} +LIMIT +Anywhere'",
    require  => Exec['ufw-default-deny'],
    before   => Exec['ufw-enable'],
  }
}
