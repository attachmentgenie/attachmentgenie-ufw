# Define ufw::deny enables us to define deny rules for ufw
define ufw::deny($proto='tcp', $port='all', $ip='', $from='any', $direction='in') {

  $dir = $direction ? {
    'out'   => 'OUT',
    default => ''
  }

  # For 'deny' action, the default is to deny to any address
  $ipadr = $ip ? {
    ''      => 'any',
    default => $ip,
  }

  $ipver = $ipadr ? {
    /:/     => 'v6',
    default => 'v4',
  }

  $ipadr_match = $ipadr ? {
    'any'   => $ipver ? {
      'v4' => 'Anywhere',
      'v6' => 'Anywhere \(v6\)',
    },
    default => $ipadr,
  }

  $from_match = $from ? {
    'any'   => $ipver ? {
      'v4' => 'Anywhere',
      'v6' => 'Anywhere \(v6\)',
    },
    default => $from,
  }

  $command = $port ? {
    'all'   => "ufw deny ${dir} proto ${proto} from ${from} to ${ipadr}",
    default => "ufw deny ${dir} proto ${proto} from ${from} to ${ipadr} port ${port}",
  }

  $unless    = $port ? {
    'all'   => "ufw status | grep -qE '${ipadr_match}/${proto} +DENY ${dir} +${from_match}'",
    default => "ufw status | grep -qEe '^${ipadr_match} ${port}/${proto} +DENY ${dir} +${from_match}$' -qe '^${port}/${proto} +DENY +${from_match}$'",
  }

  exec { "ufw-deny-${direction}-${proto}-from-${from}-to-${ipadr}-port-${port}":
    command  => $command,
    path     => '/usr/sbin:/bin:/usr/bin',
    provider => 'posix',
    unless   => $unless,
    require  => Exec['ufw-default-deny'],
    before   => Exec['ufw-enable'],
  }
}
