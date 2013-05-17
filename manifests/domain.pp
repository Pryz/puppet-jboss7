class jboss7::domain inherits jboss7 {

    # Generate the password for mgmt-users.properties with :
    # add-user.sh
    # Generate the password for server-identities in host.xml with :
    # echo -n thepasswd | base64

    file { 'domain-mgmt-users.properties' :
        ensure  => present,
        path    => '/opt/jboss-as/domain/configuration/mgmt-users.properties',
        source  => 'puppet:///modules/jboss7/domain-mgmt-users.properties',
        owner   => 'jboss',
        group   => 'jboss',
        mode    => '0644',
        require => Package['jbossas7'],
    }

    file { 'host.xml' :
        ensure  => present,
        path    => '/opt/jboss-as/domain/configuration/host.xml',
        replace => false,
        content => template('jboss7/host-master.xml'),
        owner   => 'jboss',
        group   => 'jboss',
        mode    => '0644',
        require => Package['jbossas7'],
    }

    file { 'domain.xml' :
        ensure  => present,
        path    => '/opt/jboss-as/domain/configuration/domain.xml',
        replace => false,
        content => template('jboss7/domain.xml'),
        owner   => 'jboss',
        group   => 'jboss',
        mode    => '0644',
        require => Package['jbossas7'],
    }

    service{ 'jboss-as-standalone' :
        ensure  => stopped,
        enable  => false,
        require => Package['jbossas7'],
    }

    include myfirewall

    firewall { '100 jboss.management.http.port' :
          chain  => 'INPUT',
          proto  => 'tcp',
          state  => 'NEW',
          dport  => '9990',
          action => 'accept',
    }

    firewall { '101 jboss.management.native.port' :
          chain  => 'INPUT',
          proto  => 'tcp',
          state  => 'NEW',
          dport  => '9999',
          action => 'accept',
    }

}


