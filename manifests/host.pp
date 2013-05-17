class jboss7::host inherits jboss7 {

    # Generate the password for server-identities in host.xml with :
    # echo -n thepasswd | base64

    file { 'host.xml' :
        ensure  => present,
        path    => '/opt/jboss-as/domain/configuration/host.xml',
        replace => false,
        content => template('jboss7/host-slave.xml'),
        owner   => 'jboss',
        group   => 'jboss',
        mode    => '0644',
        require => Package['jbossas7'],
    }

    file { 'domain.xml' :
        ensure => absent,
        path   => '/opt/jboss-as/domain/configuration/domain.xml',
    }

    service{ 'jboss-as-standalone' :
        ensure  => stopped,
        enable  => false,
        require => Package['jbossas7'],
    }

    include myfirewall

    firewall { '100 jboss.http.port' :
          chain  => 'INPUT',
          proto  => 'tcp',
          state  => 'NEW',
          dport  => '8080',
          action => 'accept',
    }

    firewall { '101 jboss.http.port with offset' :
          chain  => 'INPUT',
          proto  => 'tcp',
          state  => 'NEW',
          dport  => '9080',
          action => 'accept',
    }

    firewall { '102 jboss messaging' :
          chain  => 'INPUT',
          proto  => 'tcp',
          state  => 'NEW',
          dport  => '5595',
          action => 'accept',
    }

    firewall { '103 jboss TCP cluster' :
          chain  => 'INPUT',
          proto  => 'tcp',
          state  => 'NEW',
          dport  => [ '7600', '8600'],
          action => 'accept',
    }

}

