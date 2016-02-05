#
# service definition
#
define example1::service1 (
  $ensure
) {
  # these two logging statements illustrate that the resource is executed twice... and yet
  # only on the 2nd iteration are the changes 'run/applied'
  debug( "--- in service1: ${ensure}, runs ONCE" )
  notice( "--- in service1: ${ensure}, runs TWICE" )

  $service_enable = $ensure ? {
    absent  => false,
    default => true,
  }
  $service_ensure = $ensure ? {
    absent  => stopped,
    default => running,
  }
  service { 'svc1.service':
    ensure => $service_ensure,
    enable => $service_enable,
    provider => systemd,
  }
}

#
# systemd unit file
#
define example1::files1 (
  $ensure
) {
# these two logging statements illustrate that the resource is executed twice... and yet
# only on the 2nd iteration are the changes 'run/applied'
  debug( "--- in files1: ${ensure}, runs ONCE" )
  notice( "--- in files1: ${ensure}, runs TWICE" )

  file { '/usr/lib/systemd/system/svc1.service' :
    ensure => $ensure,
    content => "[Unit]\nDescription=svc1 service 2\n\n[Service]\nType=simple\nExecStart=/usr/bin/sh -c 'while true; do sleep 1; done;'\nKillMode=process\n\n[Install]\nWantedBy=multi-user.target\n",
  }
}

#
# reloads Unit file changes into systemd
#
define example1::systemd_reload {
  exec { 'systemctl-daemon-reload' :
    command => '/usr/bin/systemctl daemon-reload'
  }
}
