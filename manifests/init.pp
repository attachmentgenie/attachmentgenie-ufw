# Class ufw
#
#  Installs and enables Ubuntu's "uncomplicated" firewall.
#
#  Be careful calling this class alone, it will by default enable ufw
# and disable all incoming traffic.
class ufw(
  $allow          = $::ufw::params::allow,
  $deny           = $::ufw::params::deny,
  $deny_outgoing  = $::ufw::params::deny_outgoing,
  $forward        = $::ufw::params::forward,
  $limit          = $::ufw::params::limit,
  $log_level      = $::ufw::params::log_level,
  $manage_service = $::ufw::params::manage_service,
  $reject         = $::ufw::params::reject,
  $service_name   = $::ufw::params::service_name,
) inherits ufw::params {
  validate_bool( $deny_outgoing,
    $manage_service,
  )
  validate_hash( $allow,
    $deny,
    $limit,
    $reject
  )
  validate_re( $forward, 'ACCEPT|DROP|REJECT')
  validate_re( $log_level, 'off|low|medium|high|full')
  validate_string( $service_name)

  Exec {
    path     => '/bin:/sbin:/usr/bin:/usr/sbin',
    provider => 'posix',
  }

  anchor { 'ufw::begin': } ->
  class{'::ufw::install':} ->
  class{'::ufw::config':} ~>
  class{'::ufw::service':}
  anchor { 'ufw::end': }

  # Hiera resource creation
  create_resources('::ufw::allow',  $allow)
  create_resources('::ufw::deny', $deny)
  create_resources('::ufw::limit', $limit)
  create_resources('::ufw::reject', $reject)
}