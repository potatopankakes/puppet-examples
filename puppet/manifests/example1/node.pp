node example1 {
    $ensure = absent
    example1::service1 { 's1':
      ensure => $ensure,
    }
    example1::files1 { 'f1':
      ensure => $ensure,
    }
    example1::systemd_reload { 'systemd_reload': }

    if $ensure == present {
      Example1::Files1['f1'] -> Example1::Systemd_reload['systemd_reload'] -> Example1::Service1['s1']
    }
    else {
      Example1::Service1['s1'] -> Example1::Systemd_reload['systemd_reload'] -> Example1::Files1['f1']
    }
    #Example1::Files1['f1'] ~> Example1::Service1['s1']
}
