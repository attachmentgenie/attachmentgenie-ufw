# Define ufw::allow
define ufw::allow($proto='tcp', $port='all', $ip='', $from='any', $direction='in') {

  $dir = $direction ? {
    'out'   => 'OUT',
    default => ''
  }

  if $ip == '' {
    $ipadr = pick($::ipaddress_eth0, $::ipaddress, 'any')
  } else {
    # Use $ip as ufw 'to' address when supplied
    $ipadr = $ip
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

  $proto_match = $proto ? {
    'any'   => '',
    default => "/${proto}",
  }

  $from_proto_match = $from ? {
    'any'   => '',
    default => $proto_match,
  }

  $command = $port ? {
    'all'   => "ufw allow ${dir} proto ${proto} from ${from} to ${ipadr}",
    default => "ufw allow ${dir} proto ${proto} from ${from} to ${ipadr} port ${port}",
  }

  $unless  = "${ipadr}:${port}" ? {
    'any:all'    => "ufw status | grep -qE ' +ALLOW ${dir} +${from_match}$'",
    /[0-9]:all$/ => "ufw status | grep -qE '^${ipadr_match}${proto_match} +ALLOW +${from_match}${from_proto_match}$'",
    /^any:[0-9]/ => "ufw status | grep -qE '^${port}${proto_match} +ALLOW +${from_match}$'",
    default      => "ufw status | grep -qE '^${ipadr_match} ${port}${proto_match} +ALLOW +${from_match}$'",
  }

  exec { "ufw-allow-${direction}-${proto}-from-${from}-to-${ipadr}-port-${port}":
    command  => $command,
    path     => '/usr/sbin:/bin:/usr/bin',
    provider => 'posix',
    unless   => $unless,
    require  => Exec['ufw-default-deny'],
    before   => Exec['ufw-enable'],
  }
}
