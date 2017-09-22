#  Installs and enables Ubuntu's "uncomplicated" firewall.
#
#  Be careful calling this class alone, it will by default enable ufw
# and disable all incoming traffic.
#
#
# @example when declaring the ufw class
#  ufw::deny { 'deny-ssh-from-all':
#    port => '22',
#  }
#
# @param direction The first parameter for this class
# @param from Ip address to allow access from. default: any
# @param ip Ip address to allow access to. default: ''
# @param port Port to act on. default: all
# @param proto Protocol to use. default: tcp
define ufw::deny(
  Enum['IN','OUT'] $direction ='IN',
  String $from = 'any',
  String $ip = '',
  String $port = 'all',
  Enum[ 'tcp','udp','any'] $proto = 'tcp',
) {
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
    default => "ufw status | grep -qEe '^${ipadr_match} ${port}/${proto} +DENY ${dir} +${from_match}( +.*)?$' -qe '^${port}/${proto} +DENY +${from_match}( +.*)?$'", # lint:ignore:140chars
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
