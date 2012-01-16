define ufw::allow($proto="tcp", $port="all", $ip="", $from="any") {

  if $::ipaddress_eth0 != undef {
    $ipadr = $ip ? {
      "" => $::ipaddress_eth0,
      default => $ip,
    }
  } else {
    $ipadr = "any"
  }

  $from_match = $from ? {
    "any" => "Anywhere",
    default => "$from/$proto",
  }

  exec { "ufw-allow-${proto}-from-${from}-to-${ipadr}-port-${port}":
    command => $port ? {
      "all" => "ufw allow proto $proto from $from to $ipadr",
      default => "ufw allow proto $proto from $from to $ipadr port $port",
    },
    unless => $port ? {
      "all" => "ufw status | grep -E \"$ipadr/$proto +ALLOW +$from_match\"",
      default => "ufw status | grep -E \"$ipadr $port/$proto +ALLOW +$from_match\"",
    },
    require => Exec["ufw-default-deny"],
    before => Exec["ufw-enable"],
  }
}
