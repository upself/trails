package Database::Connection;

use strict;
use Carp qw( croak );
use Base::Utils;
use DBI;

sub new {
    my ( $class, $bankAccount ) = @_;
    my $self = {
                 _bankAccount => $bankAccount,
                 _name        => undef,
                 _user        => undef,
                 _password    => undef,
                 _schema      => undef,
                 _attributes  => undef,
                 _sql         => undef,
                 _dbh         => undef
    };
    bless $self, $class;

    $self->validate;
    $self->setDBInfo;
    $self->connect;

    return $self;
}

sub validate {
    my $self = shift;

    croak 'DB name or bank account is undefined'
      unless defined $self->bankAccount;
}

sub connect {
    my $self = shift;

    my %attr = (
                 PrintError => 0,
                 RaiseError => 1,
                 AutoCommit => 1
    );

    ###Build our string and connect
    my $connect = "dbi:DB2:" . $self->name;
    eval { $self->dbh( DBI->connect( $connect, $self->user, $self->password, \%attr ) ); };
    if ($@) {
        croak( $@ . __LINE__ . "\n" . "connect called" );
    }

    eval { $self->dbh->do( "set current schema = " . $self->schema ) if ( defined $self->schema ); };
    if ($@) {
        wlog($@);
    }
}

sub disconnect {
    my $self = shift;

    ###Call the disconnect
    $self->dbh->disconnect;
}

sub prepareSqlQuery {
    my ( $self, $name, $query ) = @_;

    my $sth;

    if ( ( !defined $self->sql ) || ( !exists $self->sql->{$name} ) ) {

        my $sql = $self->sql;
        eval { $sth = $self->dbh->prepare($query); };
        if ($@) {
            croak( $@ . __LINE__ . "\n" . "prepareSqlQuery called" );
        }

        $sql->{$name} = $sth;
        $self->sql($sql);
    }
}

sub prepareSqlQueryAndFields {
    my ( $self, $name, $query, $fields ) = @_;
    my $sth;

    if ( ( !defined $self->sql ) || ( !exists $self->sql->{$name} ) ) {

        my $sql = $self->sql;
        eval { $sth = $self->dbh->prepare($query); };
        if ($@) {
            croak( $@ . __LINE__ . "\n" . "prepareSqlQueryAndFields called" );    
        }

        $sql->{$name} = $sth;
        $sql->{ $name . "Fields" } = $fields;
        $self->sql($sql);
    }
}

sub setDBInfo {
    my $self = shift;

    if ( $self->bankAccount->isa("Sigbank::OM::BankAccount") ) {
        $self->name( $self->bankAccount->name );
        $self->user( $self->bankAccount->databaseUser );
        $self->password( $self->bankAccount->databasePassword );
        $self->schema( $self->bankAccount->databaseSchema );
    }
    else {

        my %dbs;

            $dbs{'swasset'}{'password'} = 'APR29db2@#';
            $dbs{'swasset'}{'user'}     = 'swasset';
            $dbs{'swasset'}{'name'}     = 'SWASSETR';

            $dbs{'staging'}{'password'} = 'apr03db2';
            $dbs{'staging'}{'user'}     = 'eaadmin';
            $dbs{'staging'}{'name'}     = 'STAGINGR';

            $dbs{'trails'}{'password'} = 'W0nth3cp';
            $dbs{'trails'}{'user'}     = 'eaadmin';
            $dbs{'trails'}{'name'}     = 'TRAILS';

            $dbs{'cndb'}{'password'} = 'OCT18db2';
            $dbs{'cndb'}{'user'}     = 'cndb';
            $dbs{'cndb'}{'name'}     = 'CNDBR';

            $dbs{'swcm'}{'password'} = 'Tru30dds';
            $dbs{'swcm'}{'user'}     = 'tap2swcm';
            $dbs{'swcm'}{'name'}     = 'SWCMPROD';

            $dbs{'sims'}{'password'} = 'ba001ley';
            $dbs{'sims'}{'user'}     = 'simscon';
            $dbs{'sims'}{'name'}     = 'SIMS';
        

       if ( defined $dbs{ $self->bankAccount }{'name'} ) {
            $self->user( $dbs{ $self->bankAccount }{'user'} );
            $self->password( $dbs{ $self->bankAccount }{'password'} );
            $self->name( $dbs{ $self->bankAccount }{'name'} );
        }
    }
}

sub setAttributes {
    my $self = shift;

    ###Setup our attributes
    my %attr = (
                 PrintError => 0,
                 RaiseError => 1,
                 AutoCommit => 1
    );

    $self->attributes( \%attr );
}

sub dbh {
    my $self = shift;
    $self->{_dbh} = shift if scalar @_ == 1;
    return $self->{_dbh};
}

sub sql {
    my $self = shift;
    $self->{_sql} = shift if scalar @_ == 1;
    return $self->{_sql};
}

sub attributes {
    my $self = shift;
    $self->{_attributes} = shift if scalar @_ == 1;
    return $self->{__attributes};
}

sub bankAccount {
    my $self = shift;
    $self->{_bankAccount} = shift if scalar @_ == 1;
    return $self->{_bankAccount};
}

sub user {
    my $self = shift;
    $self->{_user} = shift if scalar @_ == 1;
    return $self->{_user};
}

sub password {
    my $self = shift;
    $self->{_password} = shift if scalar @_ == 1;
    return $self->{_password};
}

sub name {
    my $self = shift;
    $self->{_name} = shift if scalar @_ == 1;
    return $self->{_name};
}

sub schema {
    my $self = shift;
    $self->{_schema} = shift if scalar @_ == 1;
    return $self->{_schema};    
}

1;
