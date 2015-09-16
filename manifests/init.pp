class puppetserver(
    $server_ipaddr = '192.168.200.150',
    $server_hostid = 'puppetserver',
    $server_domain = 'hacklab',
    $jvm_heap_mem  = '512m',
    $jvm_perm_mem  = '512m',
    $start_timeout = '300'
    ) {

  yumrepo { 'puppetlabs-pc1':
    ensure   => 'present',
    baseurl  => 'http://yum.puppetlabs.com/el/7/PC1/$basearch',
    descr    => 'Puppet Labs PC1 Repository el 7 - $basearch',
    enabled  => '1',
    gpgcheck => '0',
    gpgkey   => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-puppetlabs',
  }

  host { 'localhost':
    ensure       => 'present',
    ip           => '127.0.0.1',
    target       => '/etc/hosts',
  }

  host { "${server_hostid}.${server_domain}":
    ensure       => 'present',
    host_aliases => [ $server_hostid, 'puppet', 'master', ],
    ip           => $server_ipv4,
    target       => '/etc/hosts',
    notify       => Exec['ajusta_hostname'],
  }
  
  exec { 'ajusta_hostname':
    command     => "hostnamectl set-hostname ${server_hostid}.${server_domain}",
    path        => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
    refreshonly => true,
  }

  file { '/etc/hostname':
    ensure  => file,
    content => "${server_hostid}.${server_domain}\n",
  }

  file { '/etc/profile.d/puppet_path.sh':
    ensure  => file,
    content => 'export PATH=$PATH:/opt/puppetlabs/bin',
  }

  package { 'puppetserver':
    ensure => latest,
    notify => Exec['gera_ca']
  }

  exec { 'gera_ca':
    command     => 'puppet cert list -a',
    path        => '/usr/bin:/usr/sbin:/bin:/usr/local/bin:/opt/puppetlabs/puppet/bin',
    refreshonly => true,
    notify      => Exec['gera_puppetserver_certs'],
  }

  exec { 'gera_puppetserver_certs':
    command      => "puppet cert generate ${server_hostid}.${server_domain} --dns_alt_names=puppet",
    path        => '/usr/bin:/usr/sbin:/bin:/usr/local/bin:/opt/puppetlabs/puppet/bin',
    refreshonly => true,
  }

  file { '/etc/sysconfig/puppetserver':
    ensure   => file,
    owner    => 'root',
    group    => 'root',
    mode     => '0644',
    content  => template('puppetserver/puppetserver.erb'),
  }

  exec { 'ajusta_puppet_conf_agent':
    command     => "echo '[agent]\ncertname = ${server_hostid}.${server_domain} >> /etc/puppetlabs/puppet/puppet.conf",
    path        => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
    refreshonly => true,
  }

  service { 'puppetserver':
    ensure => running,
    enable => true,

  }
  
}
