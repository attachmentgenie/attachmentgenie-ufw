Exec {
  path => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
}

ufw::deny { "allow-all-from-trusted":
  proto => "tcp",
  port => 81,
  ip => "10.0.0.3",
  from => "10.0.0.4",
}