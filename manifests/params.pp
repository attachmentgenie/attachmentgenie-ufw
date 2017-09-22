# Class to manage ufw parameters.
#
# Dont include this class directly.
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