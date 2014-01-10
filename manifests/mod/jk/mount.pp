# Class: apache_modjk::mod::jk::mount
#
# This class configures Apache mod_jk mount points
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
# - Configure Apache mod_jk mount points
#
# Requires:
# - The apache class
# - The apache_modjk::mod::jk class
#
# Sample Usage:
#
#  # Simple usage allowing access from localhost and a private subnet
#  apache_modjk::mod::jk::mount { '/*.jsp':
#     worker => 'tcapp01',
#  }
#
define apache_modjk::mod::jk::mount (
  $worker,
){
  $url_prefix = $name
  validate_string($url_prefix)
  validate_string($worker)

  concat::fragment { $url_prefix:
    target  => "${::apache::mod_dir}/jk_mount.conf",
    content => "JkMount ${url_prefix} ${worker}/n"
  }
}
