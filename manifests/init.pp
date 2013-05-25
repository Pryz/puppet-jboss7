class jboss7( $up = hiera('jboss::up', true) ) {

    include 'java'

    yumrepo { 'jboss' :
        baseurl  =>
          'http://www.kermit.fr/repo/rpm/el$releasever/$basearch/jboss/',
        descr    => 'JBoss',
        enabled  => 1,
        gpgcheck => 0,
    }

    user { 'jboss' :
        ensure     => present,
        comment    => 'jboss',
        managehome => true,
        home       => '/opt/jboss-as',
        password   =>
          '$6$cVa9SAkF$Yx1YEsWVCWIUkAwZJx58c.ztYbZwaxb6U7XvLk.WNf8dQNGkBqnizyWU89UzNn3BT1iWMgP/jkX96XbIYmUaE1',
    }

    file { '/opt/jboss-as' :
        ensure  => directory,
        owner   => 'jboss',
        group   => 'jboss',
        mode    => '0755',
        require => User[ 'jboss' ],
    }

    file { 'jboss_bash_profile' :
        ensure  => present,
        path    => '/opt/jboss-as/.bash_profile',
        source  => 'puppet:///modules/jboss7/jboss_bash_profile',
        owner   => 'jboss',
        group   => 'jboss',
        mode    => '0644',
        require => File[ '/opt/jboss-as' ],
    }

    file { 'jboss_bashrc' :
        ensure  => present,
        path    => '/opt/jboss-as/.bashrc',
        source  => 'puppet:///modules/jboss7/jboss_bashrc',
        owner   => 'jboss',
        group   => 'jboss',
        mode    => '0644',
        require => File[ '/opt/jboss-as' ],
    }

    realize Package[ 'java-1.6.0-openjdk' ]

    realize Package[ 'java-1.6.0-openjdk-devel' ]

    package { 'jbossas7' :
        ensure  => present,
        notify  => Exec[ 'Delete default JBoss conf' ],
        require => Package[ 'java-1.6.0-openjdk', 'java-1.6.0-openjdk-devel' ],
    }

    exec { 'Delete default JBoss conf' :
        refreshonly => true,
        path        => [ '/bin' ],
        command     =>
            'rm -f /opt/jboss-as/domain/configuration/{host.xml,domain.xml}',
    }

    file { '/opt/jboss-as/bin' :
        ensure  => directory,
        owner   => 'jboss',
        group   => 'jboss',
        mode    => '0755',
        require => File[ '/opt/jboss-as' ],
    }

    file { '/opt/jboss-as/.ssh' :
        ensure  => directory,
        owner   => 'jboss',
        group   => 'jboss',
        mode    => '0700',
        require => File[ '/opt/jboss-as' ],
    }

}

