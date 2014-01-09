# Define: apache_modjk::mod::jk::lb_worker
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
#  apache_modjk::mod::jk::lb_worker { 'apisrv01':
#     host => 'tomcat.example.com',
#  }
#
define apache_modjk::mod::jk::lb_worker (
){

  if ! defined(Class['apache_modjk::mod::jk']) {
    fail('You must include the apache_modjk::mod::jk class before creating any lb_worker defined resources')
  }

  validate_string($name)

  concat::fragment { $name:
    target  => $::apache_modjk::mod::jk::jkworkersfile,
    content => template("${module_name}/mod/jk/lb_worker.erb"),
  }
}
