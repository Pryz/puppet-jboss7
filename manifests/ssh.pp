class jboss::ssh {
    include concat::setup

    concat { '/opt/jboss-as/.ssh/authorized_keys' :
        owner   => 'jboss',
        group   => 'jboss',
        mode    => '0600',
    }

    concat::fragment { 'lofickey4jboss' :
        target => '/opt/jboss-as/.ssh/authorized_keys',
        source => 'puppet:///modules/ssh/authorized_keys-lofic@beaker',
        order  => 01,
    }
}