package Database::Connection;

use strict;
use Carp qw( croak );
use Base::Utils;
use DBI;
use Config::Properties::Simple;

sub new {
    my ( $class,$bankAccount,$retry,$sleepPeriod ) = @_;
    my $self = {
                 _bankAccount => $bankAccount,
                 _retry       => $retry,
                 _sleepPeriod   => $sleepPeriod,
                 _name        => undef,
                 _user        => undef,
                 _password    => undef,
                 _schema      => undef,
                 _attributes  => undef,
                 _sql         => undef,
                 _dbh         => undef,
                 _cNo         => 0
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

    $self->cNo(0);
    
    while(1)
    {
      ###Build our string and connect
      my $connect = "dbi:DB2:" . $self->name;
      eval { $self->dbh( DBI->connect( $connect, $self->user, $self->password, \%attr ) ); };
      
      if ($@) {
          if( defined $self->sleepPeriod && defined $self->retry 
            && ($@ =~ /SQL30081N/ || $@ =~ /SQL30082N/)
            && $self->cNo< $self->retry){
             
              $self->cNo($self->cNo+1);
              dlog("Error:$@ reconnect in ". $self->sleepPeriod." seconds");
              sleep $self->sleepPeriod;
              dlog("reconnecting ".$self->cNo." time(s)");
              next;
          }
        
        croak( $@ . __LINE__ . "\n" . "connect called" );
        last;
      }
      last;
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
        my $cfg=Config::Properties::Simple->new(file=>'/opt/staging/v2/config/connectionConfig.txt');        
        my %dbs;

            $dbs{'swasset'}{'password'} = $cfg->getProperty('swasset.password');
            $dbs{'swasset'}{'user'}     = $cfg->getProperty('swasset.user');
            $dbs{'swasset'}{'name'}     = $cfg->getProperty('swasset.name');
            $dbs{'swasset'}{'schema'}   = 'SWASSET';

            $dbs{'staging'}{'password'} = $cfg->getProperty('staging.password');
            $dbs{'staging'}{'user'}     = $cfg->getProperty('staging.user');
            $dbs{'staging'}{'name'}     = $cfg->getProperty('staging.name');
            $dbs{'staging'}{'schema'}   = undef;
            
            $dbs{'trails'}{'password'} = $cfg->getProperty('trails.password');
            $dbs{'trails'}{'user'}     = $cfg->getProperty('trails.user');
            $dbs{'trails'}{'name'}     = $cfg->getProperty('trails.name');
            $dbs{'trails'}{'schema'}   = undef;

            $dbs{'cndb'}{'password'} = $cfg->getProperty('cndb.password');
            $dbs{'cndb'}{'user'}     = $cfg->getProperty('cndb.user');
            $dbs{'cndb'}{'name'}     = $cfg->getProperty('cndb.name');
            $dbs{'cndb'}{'schema'}   = 'CNDB';

            $dbs{'swcm'}{'password'} = $cfg->getProperty('swcm.password');
            $dbs{'swcm'}{'user'}     = $cfg->getProperty('swcm.user');
            $dbs{'swcm'}{'name'}     = $cfg->getProperty('swcm.name');
            $dbs{'swcm'}{'schema'}   = undef;
            
            $dbs{'sims'}{'password'} = $cfg->getProperty('sims.password');
            $dbs{'sims'}{'user'}     = $cfg->getProperty('sims.user');
            $dbs{'sims'}{'name'}     = $cfg->getProperty('sims.name');
            $dbs{'sims'}{'schema'}   = undef;
            
            $dbs{'trailsrp'}{'password'} = $cfg->getProperty('trailsrp.password');
            $dbs{'trailsrp'}{'user'}     = $cfg->getProperty('trailsrp.user');
            $dbs{'trailsrp'}{'name'}     = $cfg->getProperty('trailsrp.name');
            $dbs{'trailsrp'}{'schema'}   = undef;                       
            
            $dbs{'trailsst'}{'password'} = $cfg->getProperty('trailsst.password');
            $dbs{'trailsst'}{'user'}     = $cfg->getProperty('trailsst.user');
            $dbs{'trailsst'}{'name'}     = $cfg->getProperty('trailsst.name');
            $dbs{'trailsst'}{'schema'}   = undef;            

        if ( defined $dbs{ $self->bankAccount }{'name'} ) {
            $self->user( $dbs{ $self->bankAccount }{'user'} );
            $self->password( $dbs{ $self->bankAccount }{'password'} );
            $self->name( $dbs{ $self->bankAccount }{'name'} );
        	$self->schema( $dbs{ $self->bankAccount }{'schema'} );
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

sub retry {
    my $self = shift;
    $self->{_retry} = shift if scalar @_ == 1;
    return $self->{_retry};
}

sub cNo{
    my $self = shift;
    $self->{_cNo} = shift if scalar @_ == 1;
    return $self->{_cNo};
}

sub sleepPeriod{
    my $self = shift;
    $self->{_sleepPeriod} = shift if scalar @_ == 1;
    return $self->{_sleepPeriod};
}
1;
