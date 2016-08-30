class { 'ufw': }
ufw::allow { 'allow-ssh-from-all':
  port => '22',
}
ufw::allow { "allow-replication-from-${::fqdn}":
  proto => 'tcp',
  from  => '42.42.42.42',
  ip    => 'any',
}