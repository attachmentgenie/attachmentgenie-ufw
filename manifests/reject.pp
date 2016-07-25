define ufw::reject($proto='tcp', $port='all', $ip='', $from='any') {

  # For 'reject' action, the default is to deny to any address
  $ipadr = $ip ? {
    ''      => 'any',
    default => $ip,
  }

  $ipver = $ipadr ? {
    /:/     => 'v6',
    default => 'v4',
  }

  $from_match = $from ? {
    'any'   => $ipver ? {
      'v4' => 'Anywhere',
      'v6' => 'Anywhere \(v6\)',
      },
    default => $from,
  }

  $command  = $port ? {
    'all'   => "ufw reject proto ${proto} from ${from} to ${ipadr}",
    default => "ufw reject proto ${proto} from ${from} to ${ipadr} port ${port}",
  }

  $unless   = $port ? {
    'all'   => "ufw status | grep -qE '^${ipadr}/${proto} +REJECT +${from_match}( +.*)?$'",
    default => "ufw status | grep -qEe '^${ipadr} ${port}/${proto} +REJECT +${from_match}( +.*)?$' -qe '^${port}/${proto} +REJECT +${from_match}( +.*)?$'", # lint:ignore:140chars
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
