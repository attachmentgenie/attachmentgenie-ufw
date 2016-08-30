#  Installs and enables Ubuntu's "uncomplicated" firewall.
#
class ufw::params {
  $allow          = {}
  $deny           = {}
  $deny_outgoing  = false
  $forward        = 'DROP'
  $limit          = {}
  $log_level      = 'low'
  $manage_service = true
  $reject         = {}
  $service_name   = 'ufw'
}