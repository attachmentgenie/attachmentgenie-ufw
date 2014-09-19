# Define ufw::deny enables us to define deny rules for ufw
define ufw::deny($proto='tcp', $port='all', $ip='', $from='any') {

  # For 'deny' action, the default is to deny to any address
  $ipadr = $ip ? {
    ''      => 'any',
    default => $ip,
  }

  $from_match = $from ? {
    'any'   => 'Anywhere',
    default => $from,
  }

  $command = $port ? {
    'all'   => "ufw deny proto ${proto} from ${from} to ${ipadr}",
    default => "ufw deny proto ${proto} from ${from} to ${ipadr} port ${port}",
  }

  $unless    = $port ? {
    'all'   => "ufw status | grep -qE '${ipadr}/${proto} +DENY +${from_match}'",
    default => "ufw status | grep -qEe '^${ipadr} ${port}/${proto} +DENY +${from_match}$' -qe '^${port}/${proto} +DENY +${from_match}$'",
  }

  exec { "ufw-deny-${proto}-from-${from}-to-${ipadr}-port-${port}":
    command  => $command,
    path     => '/usr/sbin:/bin:/usr/bin',
    provider => 'posix',
    unless   => $unless,
    require  => Exec['ufw-default-deny'],
    before   => Exec['ufw-enable'],
  }
}
