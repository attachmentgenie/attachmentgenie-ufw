define ufw::reject($proto='tcp', $port='all', $ip='', $from='any') {

  $ipadr = $ip ? {
    ''  => $::ipaddress_eth0 ? {
      undef   => 'any',
      default => $::ipaddress_eth0,
    },
    default => $ip,
  }

  $from_match = $from ? {
    'any'   => 'Anywhere',
    default => $from,
  }

  $command  = $port ? {
    'all'   => "ufw reject proto ${proto} from ${from} to ${ipadr}",
    default => "ufw reject proto ${proto} from ${from} to ${ipadr} port ${port}",
  }

  $unless   = $port ? {
    'all'   => "ufw status | grep -qE '^${ipadr}/${proto} +REJECT +${from_match}$'",
    default => "ufw status | grep -qEe '^${ipadr} ${port}/${proto} +REJECT +${from_match}$' -qe '^${port}/${proto} +REJECT +${from_match}$'",
  }

  exec { "ufw-reject-${proto}-from-${from}-to-${ipadr}-port-${port}":
    path     => '/usr/sbin:/bin:/usr/bin',
    provider => 'posix',
    command  => $command,
    unless   => $unless,
    require  => Exec['ufw-default-deny'],
    before   => Exec['ufw-enable'],
  }
}
