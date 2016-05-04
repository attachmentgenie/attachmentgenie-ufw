# Define ufw::allow
define ufw::allow(
  $proto='tcp',
  $port='all',
  $ip='',
  $from='any',
  $ensure='present',
) {

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

  $grep_existing_rule = "${ipadr}:${port}" ? {
    'any:all'    => "grep -qE ' +ALLOW +${from_match}$'",
    /[0-9]:all$/ => "grep -qE '^${ipadr}${proto_match} +ALLOW +${from_match}${from_proto_match}$'",
    /^any:[0-9]/ => "grep -qE '^${port}${proto_match} +ALLOW +${from_match}$'",
    default      => "grep -qE '^${ipadr} ${port}${proto_match} +ALLOW +${from_match}$'",
  }

  $rule = $port ? {
    'all'   => "allow proto ${proto} from ${from} to ${ipadr}",
    default => "allow proto ${proto} from ${from} to ${ipadr} port ${port}",
  }

  if $ensure == 'absent' {
    $command = "ufw delete ${rule}"
    $onlyif = "ufw status | ${grep_existing_rule}"

    exec { "ufw-delete-${proto}-from-${from}-to-${ipadr}-port-${port}":
      command  => $command,
      path     => '/usr/sbin:/bin:/usr/bin',
      provider => 'posix',
      onlyif   => $onlyif,
      require  => Exec['ufw-default-deny'],
      before   => Exec['ufw-enable'],
    }
  }
  else {
    $command = "ufw ${rule}"
    $unless = "ufw status | ${grep_existing_rule}"

    exec { "ufw-allow-${proto}-from-${from}-to-${ipadr}-port-${port}":
      command  => $command,
      path     => '/usr/sbin:/bin:/usr/bin',
      provider => 'posix',
      unless   => $unless,
      require  => Exec['ufw-default-deny'],
      before   => Exec['ufw-enable'],
    }
  }
}
