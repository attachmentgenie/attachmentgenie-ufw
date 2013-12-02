# Define ufw::limit
#
#   enable connection rate limiting for this $proto
#
define ufw::limit($proto='tcp') {

  exec { "ufw limit ${name}/${proto}":
    path     => '/usr/sbin:/bin:/usr/bin',
    provider => 'posix',
    unless   => "ufw status | grep -qE '^${name}/${proto} +LIMIT +Anywhere'",
    require  => Exec['ufw-default-deny'],
    before   => Exec['ufw-enable'],
  }
}
