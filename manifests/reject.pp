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
define ufw::reject(
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
