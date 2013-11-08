define ufw::reject($proto='tcp', $port='all', $ip='', $from='any') {

  if $::ipaddress_eth0 != undef {
    $ipadr = $ip ? {
      ''      => $::ipaddress_eth0,
      default => $ip,
    }
  } else {
    $ipadr = 'any'
  }

  $from_match = $from ? {
    'any'   => 'Anywhere',
    default => "$from",
  }

  exec { "ufw-reject-${proto}-from-${from}-to-${ipadr}-port-${port}":
    command => $port ? {
      'all'   => "ufw reject proto $proto from $from to $ipadr",
      default => "ufw reject proto $proto from $from to $ipadr port $port",
    },
    unless  => $port ? {
      'all'   => "ufw status | grep -E \"^${ipadr}/${proto} +REJECT +${from_match}$\"",
      default => "ufw status | grep -Ee \"^${ipadr} ${port}/${proto} +REJECT +${from_match}$\" -e \"^${port}/${proto} +REJECT +${from_match}$\"",
    },
    require => Exec['ufw-default-deny'],
    before  => Exec['ufw-enable'],
  }
}
