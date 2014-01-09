# Class: apache_modjk::mod::jk
#
# This class enables and configures Apache mod_jk
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
# - Configure Apache mod_jk
#
# Requires:
# - The apache class
#
# Sample Usage:
#
#  # Simple usage allowing access from localhost and a private subnet
#  class { 'apache_modjk::mod::jk':
#    $jkworkersfile => '/etc/httpd/conf.d/workers.properties',
#  }
#
class apache_modjk::mod::jk (
  $package       = undef,
  $jkworkersfile = "${::apache::mod_dir}/jk.workers.properties",
  $jklogfile     = 'logs/mod_jk.log',
  $jkloglevel    = 'info',
){
  validate_absolute_path($jkworkersfile)
  validate_string($jklogfile)
  validate_re(downcase($jkloglevel), '^(debug|info|warn|error|trace)$', "${jkloglevel} is not supported for jkloglevel. Allowed values are 'debug', 'info', 'warn', 'error', or 'trace'.")

  apache::mod { 'jk':
    package => $package,
  }

  # Template uses $jkworkersfile, $jklogfile, $jkloglevel
  file { 'jk.conf':
    ensure  => file,
    path    => "${::apache::mod_dir}/jk.conf",
    content => template("${module_name}/mod/jk.conf.erb"),
    require => Exec["mkdir ${::apache::mod_dir}"],
    before  => File[$::apache::mod_dir],
    notify  => Service['httpd'],
  }

  # Concat target for global JkMount directives
  concat { 'jk_mount.conf':
    name    => "${::apache::mod_dir}/jk_mount.conf",
    notify  => Service['httpd'],
  }

  concat::fragment {'jk_mount_header':
    target  => "${::apache::mod_dir}/jk_mount.conf",
    content => "## mod_jk Global Mount Configuration\n## This file is controlled by Puppet\n##\n\n",
    order   => '01',
  }

  # Concat target for building JK Worker settings file
  concat { 'jk.workers.properties':
    name    => $jkworkersfile,
    notify  => Service['httpd'],
  }

  concat::fragment {'jk_worker_header':
    target  => $jkworkersfile,
    content => "## mod_jk Worker Properties Configuration\n## This file is controlled by Puppet\n##\n\n",
    order   => '01',
  }
}
