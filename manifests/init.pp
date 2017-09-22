#  Installs and enables Ubuntu's "uncomplicated" firewall.
#
#  Be careful calling this class alone, it will by default enable ufw
# and disable all incoming traffic.
#
#
# @example when declaring the ufw class
#   include ufw
#
# @param allow Set of connections to allow. default: {}
# @param deny Set of connections to deny. default: {}
# @param deny_outgoing Block out going connections. default:false
# @param forward Behavior for forwards. default: DROP
# @param limit Hash of connections to limit. default: {}
# @param log_level Level to log with. default: low
# @param manage_service Manage the service. default: true
# @param reject Hash of connections to reject. default: {}
# @param service_name Name of service to manage. default: ufw
class ufw(
  Hash $allow = $::ufw::params::allow,
  Hash $deny = $::ufw::params::deny,
  Boolean $deny_outgoing = $::ufw::params::deny_outgoing,
  Enum['ACCEPT','DROP','REJECT'] $forward = $::ufw::params::forward,
  Hash $limit = $::ufw::params::limit,
  Enum['off','low','medium','high','full'] $log_level = $::ufw::params::log_level,
  Boolean $manage_service = $::ufw::params::manage_service,
  Hash $reject = $::ufw::params::reject,
  String $service_name = $::ufw::params::service_name,
) inherits ufw::params {
  Exec {
    path     => '/bin:/sbin:/usr/bin:/usr/sbin',
    provider => 'posix',
  }

  anchor { 'ufw::begin': }
  -> class{ '::ufw::install': }
  -> class{ '::ufw::config': }
  ~> class{ '::ufw::service': }
  -> anchor { 'ufw::end': }

  # Hiera resource creation
  create_resources('::ufw::allow',  $allow)
  create_resources('::ufw::deny', $deny)
  create_resources('::ufw::limit', $limit)
  create_resources('::ufw::reject', $reject)
}