define ufw::allow($proto='tcp', $port='all', $ip='', $from='any') {

  $ipadr = $ip ? {
    ''  => $::ipaddress_eth0 ? {
      undef   => 'any',
      default => $::ipaddress_eth0,
    },
    default => $ip,
  }

  $from_match = $from ? {
    'any'   => 'Anywhere',
    default => "$from",
  }

  exec { "ufw-allow-${proto}-from-${from}-to-${ipadr}-port-${port}":
    command => $port ? {
      'all'   => "ufw allow proto $proto from $from to $ipadr",
      default => "ufw allow proto $proto from $from to $ipadr port $port",
    },
    unless  => "$ipadr:$port" ? {
      'any:all'    => "ufw status | grep -E \" +ALLOW +$from_match\"",
      /[0-9]:all$/ => "ufw status | grep -E \"$ipadr/$proto +ALLOW +$from_match\"",
      /^any:[0-9]/ => "ufw status | grep -E \"$port/$proto +ALLOW +$from_match\"",
      default      => "ufw status | grep -E \"$ipadr $port/$proto +ALLOW +$from_match\"",
    },
    require => Exec['ufw-default-deny'],
    before  => Exec['ufw-enable'],
  }
}
