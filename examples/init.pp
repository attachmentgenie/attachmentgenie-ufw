class { 'ufw': }
ufw::allow { 'allow-ssh-from-all':
  port => 22,
}
