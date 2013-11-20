# Define ufw::limit
#
#   enable connection rate limiting for this $proto
#
define ufw::limit($proto='tcp') {
  exec { "ufw limit ${name}/${proto}":
    unless  => "ufw status | grep -qE '^${name}/${proto} +LIMIT +Anywhere'",
    require => Exec['ufw-default-deny'],
    before  => Exec['ufw-enable'],
  }
}
