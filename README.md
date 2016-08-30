[![Build Status](https://secure.travis-ci.org/attachmentgenie/attachmentgenie-ufw.png)](http://travis-ci.org/attachmentgenie/attachmentgenie-ufw)

Puppet UFW Module
=================

Module for configuring UFW (Uncomplicated Firewall).

Usage
-----

If you include the ufw class the package will be installed, the service
will be enabled, and all incomming connections will be denied:

```puppet
include ufw
```

You can change the forward policy, which defaults to `DROP`:

```puppet
class { 'ufw':
  forward => 'ACCEPT',
}
```

You can change block also the outgoing traffic by default:

```puppet
class { 'ufw':
  deny_outgoing => true,
}
```

You can then allow certain connections:

```puppet
ufw::allow { "allow-ssh-from-all":
  port => '22',
}

ufw::allow { "allow-all-from-trusted":
  from => "10.0.0.145",
}

ufw::allow { "allow-http-on-specific-interface":
  port => '80',
  ip => "10.0.0.20",
}

ufw::allow { "allow-outgoing-dns-over-udp":
  port => '53',
  proto => "udp",
  direction => "out",
}
```

Ranges are created via

```puppet
ufw::allow { 'all http ports'
  port  => '8000:8999',
  proto => 'tcp'.
}
```

n.b.: ranges require the protocol to be tcp or udp. It cannot be any.

You can also rate limit certain ports (the IP is blocked if it initiates
6 or more connections within 30 seconds):

```puppet
ufw::limit { '22': }
```

To delete a single rule, add `ensure => absent` to the allow.
```puppet
ufw::allow { "allow-ssh-from-all":
  ensure => absent,
  port   => '22',
}
```
Like most Puppet resources, allow this to successfully run on all your machines
at least once before removing it, in order to assure that the rule is gone.


## Known Limitations ##
Currently it is not possible to purge unmanaged rules and remove defined rules this will need to be done manually. (see #21 )
