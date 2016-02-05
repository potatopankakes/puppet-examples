define example1::service1 (
  $ensure
) {
  debug( "--- in service1: ${ensure}, runs ONCE" )
  notice( "--- in service1: ${ensure}, runs TWICE" )
  #notify { "---  -- in service1: ${ensure}, runs ONCE": }
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

define example1::files1 (
  $ensure
) {
  debug( "--- in files1: ${ensure}, runs ONCE" )
  notice( "--- in files1: ${ensure}, runs TWICE" )
  #notify{ "--- -- in files1: ${ensure}, runs ONCE": }
  file { '/usr/lib/systemd/system/svc1.service' :
    ensure => $ensure,
    content => "[Unit]\nDescription=svc1 service 2\n\n[Service]\nType=simple\nExecStart=/usr/bin/sh -c 'while true; do sleep 1; done;'\nKillMode=process\n\n[Install]\nWantedBy=multi-user.target\n",
  }
}

define example1::systemd_reload {
  exec { 'systemctl-daemon-reload' :
    command => '/usr/bin/systemctl daemon-reload'
  }
}
