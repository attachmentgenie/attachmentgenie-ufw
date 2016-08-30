define ufw::reject(
  $direction ='IN',
  $from = 'any',
  $ip = '',
  $port = 'all',
  $proto = 'tcp',
) {
  validate_re($direction, 'IN|OUT')
  validate_re($proto, 'tcp|udp')
  validate_string($from,
    $ip,
    $port
  )

  $dir = $direction ? {
    'out'   => 'OUT',
    default => ''
  }

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

  $ipadr_match = $ipadr ? {
    'any'   => $ipver ? {
      'v4' => 'Anywhere',
      'v6' => 'Anywhere \(v6\)',
    },
    default => $ipadr,
  }

  $command  = $port ? {
    'all'   => "ufw reject ${dir} proto ${proto} from ${from} to ${ipadr}",
    default => "ufw reject ${dir} proto ${proto} from ${from} to ${ipadr} port ${port}",
  }

  $unless   = $port ? {
    'all'   => "ufw status | grep -qE '^${ipadr_match}/${proto} +REJECT ${dir} +${from_match}( +.*)?$'",
    default => "ufw status | grep -qEe '^${ipadr_match} ${port}/${proto} +REJECT ${dir} +${from_match}( +.*)?$' -qe '^${port}/${proto} +REJECT ${dir} +${from_match}( +.*)?$'", # lint:ignore:140chars
  }

  exec { "ufw-reject-${direction}-${proto}-from-${from}-to-${ipadr}-port-${port}":
    path     => '/usr/sbin:/bin:/usr/bin',
    provider => 'posix',
    command  => $command,
    unless   => $unless,
    require  => Exec['ufw-default-deny'],
    before   => Exec['ufw-enable'],
  }
}
