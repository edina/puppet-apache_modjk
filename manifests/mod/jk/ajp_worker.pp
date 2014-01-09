# Define: apache_modjk::mod::jk::ajp_worker
#
# This class configures Apache mod_jk ajp workers
# See: http://tomcat.apache.org/connectors-doc/reference/apache.html
#
# Parameters:
# - $allow_from is an array of hosts, ip addresses, partial network numbers
#   or networks in CIDR notation specifying what hosts can view the special
#   /server-status URL.  Defaults to ['127.0.0.1', '::1'].
# - $extended_status track and display extended status information. Valid
#   values are 'On' or 'Off'.  Defaults to 'On'.
#
# Actions:
# - Configure Apache mod_jk ajp workers
#
# Requires:
# - The apache class
# - The apache_modjk::mod::jk class
#
# Sample Usage:
#
#  # Simple usage allowing access from localhost and a private subnet
#  apache_modjk::mod::jk::ajp_worker { 'apisrv01':
#     host => 'tomcat.example.com',
#  }
#
define apache_modjk::mod::jk::ajp_worker (
  $host,
  $type             = 'ajp13',
  $port             = 8009,
  $socket_keepalive = false,
  $socket_timeout   = 0,
  $parent_balancer  = undef,
){

  if ! defined(Class['apache_modjk::mod::jk']) {
    fail('You must include the apache_modjk::mod::jk class before creating any ajp_worker defined resources')
  }

  validate_string($name)
  $_type = downcase($type)
  validate_re($type, '^(ajp13|ajp14)$', "\"${type}\" is not supported for type. Allowed values are 'ajp13' or 'ajp14'.")
  validate_bool($socket_keepalive)

  if $parent_balancer {
    validate_string($parent_balancer)
  }

  concat::fragment { $name:
    target  => $::apache_modjk::mod::jk::jkworkersfile,
    content => template("${module_name}/mod/jk/ajp_worker.erb"),
  }
}
