package Tap::DBConnection;

use DBI;
use XML::LibXML;
use Carp;

my %dbs;

$dbs{'staging'}{'password'} = 'apr03db2';
$dbs{'staging'}{'user'}     = 'eaadmin';

$dbs{'trails'}{'password'} = 'Blu3pag3';
$dbs{'trails'}{'user'}     = 'eaadmin';

$dbs{'traherp'}{'password'} = 'Gr77nday';
$dbs{'traherp'}{'user'}     = 'eaadmin';

$dbs{'tapdb'}{'password'} = 'may08db2';
$dbs{'tapdb'}{'user'}     = 'tap';

$dbs{'cndb'}{'password'} = 'Jan15nco';
$dbs{'cndb'}{'user'}     = 'cndb';

$dbs{'swasstdb'}{'password'} = 'Jan15nco';
$dbs{'swasstdb'}{'user'} = 'swasset';

$dbs{'invsigdb'}{'password'} = 'APR29db2@#';
$dbs{'invsigdb'}{'user'} = 'swasset';

$dbs{'iammdb'}{'password'} = 'apr03db2';
$dbs{'iammdb'}{'user'} = 'eaadmin';

#Constructor
sub new {
    my ($class) = @_;
    my $self = {
        _database => undef,
        _password => undef,
        _user     => undef
    };
    bless $self, $class;
    return $self;
}

#accessor for database
sub setDatabase {
    my ( $self, $database ) = @_;
    $self->{_database} = $database if defined($database);
    return ( $self->{_database} );
}

sub getDatabase {
    my ( $self ) = @_;
    return ( $self->{_database} );
}

sub setPassword {
    my ( $self, $password ) = @_;
    $self->{_password} = $password if defined($password);
    return ( $self->{_password} );
}

sub getPassword {
    my ( $self ) = @_;
    return ( $self->{_password} );
}

sub setUser {
    my ( $self, $user ) = @_;
    $self->{_user} = $user if defined($user);
    return ( $self->{_user} );
}

sub getUser {
    my ( $self ) = @_;
    return ( $self->{_user} );
}

sub setSchema {
    my ( $self, $schema ) = @_;
    $self->{_schema} = $schema if defined($schema);
    return ( $self->{_schema} );
}

sub getSchema {
    my ( $self ) = @_;
    return ( $self->{_schema} );
}

sub setDbh {
    my ( $self, $dbh ) = @_;
    $self->{_dbh} = $dbh if defined($dbh);
    return ( $self->{_dbh} );
}

sub getDbh {
    my ( $self ) = @_;
    return ( $self->{_dbh} );
}

sub setSql {
    my ( $self, $sql ) = @_;
    $self->{_sql} = $sql if defined($sql);
    return ( $self->{_sql} );
}

sub getSql {
    my ( $self ) = @_;
    return ( $self->{_sql} );
}

sub connect {
    my ( $self ) = @_;

    if( exists($dbs{$self->{_database}}) ) {
        $self->{_password} = $dbs{$self->{_database}}{'password'};
        $self->{_user} = $dbs{$self->{_database}}{'user'};
    }

    my %attr = (
                PrintError => 0
                ,RaiseError => 1
                ,AutoCommit => 1
               );
    my $connect = "dbi:DB2:" . $self->getDatabase;

    eval {
        $self->setDbh( DBI->connect( $connect, $self->getUser, $self->getPassword, \%attr ) );
    };
    if($@) {
        croak("$@ -  DBConnection " . __LINE__ . "\n" . "connect called");
    }
}

sub remoteConnect {
    my ( $self ) = @_;

    my %attr = (
                PrintError => 0
                ,RaiseError => 1
                ,AutoCommit => 1
               );
    my $connect = "dbi:DB2:" . $self->getDatabase;

    eval {
        $self->setDbh( DBI->connect( $connect, $self->getUser, $self->getPassword, \%attr ) );
    };
    if($@) {
        croak("$@ -  DBConnection " . __LINE__ . "\n" . "connect called");
    }

    eval {
        $self->getDbh->do("set current schema = " . $self->getSchema);
    };
    if($@) {
        warn($@);
    }
}

sub prepareSqlQuery {
    my ( $self, $sql ) = @_;
    my $sth;

    eval {
        $sth = $self->getDbh()->prepare($sql);
    };
    if($@) {
        warn $@;
    }    

    return $sth;
}

sub prepareSql {
    my ( $self, $sqlFile ) = @_;

    my %sql;
    my $parser = XML::LibXML->new();
    my $tree = $parser->parse_file($sqlFile);
    my $root = $tree->getDocumentElement;
    my @query_array = $root->getElementsByTagName('query');

    foreach ( @query_array ) {
        my $name  = $_->getAttribute('name');
        my $value = $_->getAttribute('value');

        eval {
            $sql{$_->getAttribute('name')}{sth} = $self->getDbh()->prepare( $_->getAttribute('value') );
        };
        if($@) {
            warn $@;
        }    
    }

    $self->setSql(\%sql); 
}

sub disconnect {
    my ( $self ) = @_;

    $self->getDbh()->disconnect();
}
1;
