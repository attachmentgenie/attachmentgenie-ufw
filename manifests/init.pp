class ufw {
  package { "ufw":
    ensure => present,
  }

  Package["ufw"] -> Exec["ufw-default-deny"] -> Exec["ufw-enable"]

  exec { "ufw-default-deny":
    command => "ufw default deny",
    unless => "ufw status verbose | grep \"[D]efault: deny (incoming), allow (outgoing)\"",
  }

  exec { "ufw-enable":
    command => "yes | ufw enable",
    unless => "ufw status | grep \"[S]tatus: active\"",
  }

  service { "ufw":
    ensure => running,
    enable => true,
    hasstatus => true,
    subscribe => Package["ufw"],
  }
}
