class jboss7::standalone inherits jboss7 {

    file { 'standalone.conf' :
        ensure  => present,
        path    => '/opt/jboss-as/bin/standalone.conf',
        owner   => 'jboss',
        group   => 'jboss',
        mode    => '0644',
        content => template('jboss7/standalone.conf'),
        require => File['/opt/jboss-as/bin'],
    }

    file { 'standalone-mgmt-users.properties' :
        ensure  => present,
        path    =>
                '/opt/jboss-as/standalone/configuration/mgmt-users.properties',
        source  => 'puppet:///modules/jboss7/standalone-mgmt-users.properties',
        owner   => 'jboss',
        group   => 'jboss',
        mode    => '0644',
        require => Package['jbossas7'],
    }

    file { 'domain-mgmt-users.properties' :
        ensure  => present,
        path    => '/opt/jboss-as/domain/configuration/mgmt-users.properties',
        source  => 'puppet:///modules/jboss7/domain-mgmt-users.properties',
        owner   => 'jboss',
        group   => 'jboss',
        mode    => '0644',
        require => Package['jbossas7'],
    }

    service{ 'jboss-as-standalone' :
        ensure  => $up? {   true    => running,
                            'true'  => running,
                            default => stopped },
        enable  => $up? {   true    => true,
                            'true'  => true,
                            default => false },
        #hasstatus => false,
        require => [  Package['jbossas7'],
                      File['standalone.conf'],],
    }

    include myfirewall

    firewall { '100 jboss.http.port' :
          chain  => 'INPUT',
          proto  => 'tcp',
          state  => 'NEW',
          dport  => '8080',
          action => 'accept',
    }

    firewall { '101 jboss.management.http.port' :
          chain  => 'INPUT',
          proto  => 'tcp',
          state  => 'NEW',
          dport  => '9990',
          action => 'accept',
    }


}


