#
# example1 illustrates the need to reverse the order of the relationships when one
# wishes to uninstall (ensure==absent) components
#
# usage:
#  mkdir vm
#  cp Vagrantfile.example1 vm/
#  cd vm
#  vagrant up
#  vagrant ssh
#  sudo puppet apply --parser future --debug --modulepath=/puppet/modules /puppet/manifests/example1/
#
node example1 {

  # toggle these back and forth to examine the different sequence in the puppet logs
  #$ensure = absent
  $ensure = present

  # define the 3 resources to illustrate the install/uninstall sequences
  example1::service1 { 's1':
    ensure => $ensure,
  }
  example1::files1 { 'f1':
    ensure => $ensure,
  }
  example1::systemd_reload { 'systemd_reload': }

  if $ensure == present {
    # comment out the encasing if-else block, and only keep this line to see the incorrect sequencing if the relationships are not reversed
    Example1::Files1['f1'] -> Example1::Systemd_reload['systemd_reload'] -> Example1::Service1['s1']
  }
  else {
    Example1::Service1['s1'] -> Example1::Systemd_reload['systemd_reload'] -> Example1::Files1['f1']
  }
}
