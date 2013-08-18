package BRAVO::Archive::Archive;

use strict;
use Base::Utils;
use Carp qw( croak );
use IO::File;
use Net::FTP;
use BRAVO::OM::HardwareLpar;
use BRAVO::Archive::HardwareLpar;
use BRAVO::OM::Hardware;
use BRAVO::Archive::Hardware;
use BRAVO::OM::InstalledSoftware;
use BRAVO::Archive::InstalledSoftware;
use BRAVO::OM::SoftwareLpar;
use BRAVO::Archive::SoftwareLpar;

sub new {
    my ($class, $connection, $testMode, $customer, $age
    ) = @_;
    my $self = {
        _connection  => $connection,
        _testMode    => $testMode,
        _customer    => $customer,
        _age         => $age,
    };
    bless $self, $class;
    dlog("instantiated self");

    $self->validate;

    return $self;
}

sub validate {
    my $self = shift;

    croak 'Connection is undefined'
        unless defined $self->connection;

    croak 'Customer is undefined'
        unless defined $self->customer;
}

sub archive {
    my $self = shift;
    
    mlog('Archiving hardware lpar objects');
    $self->archiveHardwareLpar;
    mlog('Archived hardware lpar objects');

    mlog('Archiving hardware objects');
    $self->archiveHardware;
    mlog('Archived hardware objects');

    mlog('Archiving software objects');
    $self->archiveInstalledSoftware;
    mlog('Archived software objects');
    
    mlog('Archiving software objects');
    $self->archiveSoftwareLpar;
    mlog('Archived software objects');
}

sub exec_sql_rc {
	my $self = shift;
    my $dbconnection = shift;
    my $methodName = shift;
    my $method = shift;  
    my @rs = ();
    dlog(" ***$methodName ***$method **  ");
    eval {
            $dbconnection->prepareSqlQuery( $methodName,$method );
            my $sth = $dbconnection->sql->{ $methodName };
            if ( $methodName eq 'installedSwCount'){
            	  $sth->execute( $self->customer->id, $self->age , $self->age );
            }
            else{
            	  $sth->execute( $self->customer->id, $self->age );
            }
        push @rs, [ @{ $sth->{NAME} } ];
        while (my @row = $sth->fetchrow_array()) {
            push @rs, [ @row ];
        }
        $sth->finish();
    };
    if ($@) {
        die "Unable to execute sql command ($method): $@\n";
    }
    return @rs;
}

sub archiveHardwareLpar {
    my $self = shift;
    my @count = $self->exec_sql_rc( $self->connection, $self->queryHardwareLparCount );
    mlog('Archiving amount of hardware lpars is ' . $count[1][0] );
    my @lparIds = $self->getHardwareLparIds;
    foreach my $id (@lparIds) {
        my $hardwareLpar = new BRAVO::OM::HardwareLpar();
        $hardwareLpar->id($id);
        $hardwareLpar->getById( $self->connection );
        dlog( $hardwareLpar->toString );

        dlog('Archiving hardware lpar');
        my $hardwareLparArchive
            = new BRAVO::Archive::HardwareLpar( $self->connection,
            $hardwareLpar );
        $hardwareLparArchive->archive;
        dlog('Hardware lpar archived');
        dlog($hardwareLparArchive->log);
    }

}

sub archiveHardware {
    my $self = shift;
    my @count = $self->exec_sql_rc( $self->connection, $self->queryHardwareCount );
    mlog('Archiving amount of hardwares  is ' . $count[1][0] );
    my @hardwareIds = $self->getHardwareIds;
    foreach my $id (@hardwareIds) {
        my $hardware = new BRAVO::OM::Hardware();
        $hardware->id($id);
        $hardware->getById( $self->connection );
        dlog( $hardware->toString );

        dlog('Archiving hardware');
        my $hardwareArchive
            = new BRAVO::Archive::Hardware( $self->connection, $hardware );
        $hardwareArchive->archive;
        dlog('Hardware archived');
        dlog($hardwareArchive->log);
    }
}

sub archiveInstalledSoftware {
    my $self = shift;
    my @count = $self->exec_sql_rc( $self->connection, $self->queryInstalledSwCount );
    mlog('Archiving amount of Installed Softwares  is ' . $count[1][0] );
    my @installedSoftwareIds = $self->getInstalledSoftwareIds;
    foreach my $id (@installedSoftwareIds) {
        my $installedSoftware = new BRAVO::OM::InstalledSoftware();
        $installedSoftware->id($id);
        $installedSoftware->getById( $self->connection );
        dlog( $installedSoftware->toString );

        dlog('Archiving installed software');
        my $installedSoftwareArchive
            = new BRAVO::Archive::InstalledSoftware( $self->connection,
            $installedSoftware );
        $installedSoftwareArchive->archive;
        dlog('Installed software archived');
        dlog($installedSoftwareArchive->log);
    }

}

sub archiveSoftwareLpar {
    my $self = shift;
    my @count = $self->exec_sql_rc( $self->connection, $self->querySoftwareLparCount );
    mlog('Archiving amount of Software Lpars  is ' . $count[1][0] );
    my @softwareLparIds = $self->getSoftwareLparIds;
    foreach my $id (@softwareLparIds) {
        my $softwareLpar = new BRAVO::OM::SoftwareLpar();
        $softwareLpar->id($id);
        $softwareLpar->getById( $self->connection );
        dlog( $softwareLpar->toString );

        dlog('Archiving software lpar');
        my $softwareLparArchive
            = new BRAVO::Archive::SoftwareLpar( $self->connection,
            $softwareLpar );
        $softwareLparArchive->archive;
        dlog('Software lpar archived');
        dlog($softwareLparArchive->log);
    }
}

sub getHardwareLparIds {
    my $self = shift;

    my @ids;

    $self->connection->prepareSqlQueryAndFields(
        $self->queryHardwareLparIds );
    my $sth = $self->connection->sql->{hardwareLparIds};

    dlog('Binding columns');
    my %rec;
    $sth->bind_columns( map { \$rec{$_} }
            @{ $self->connection->sql->{hardwareLparIdsFields} } );
    dlog('Columns binded');

    dlog('Executing query');
    $sth->execute( $self->customer->id, $self->age );
    dlog('Executed query');

    dlog('Looping through resultset');
    while ( $sth->fetchrow_arrayref ) {
        dlog( $rec{id} );
        push @ids, $rec{id};
    }
    dlog('Loop complete');

    dlog('Closing statement handle');
    $sth->finish;
    dlog('Closed statement handle');

    return @ids;
}

sub queryHardwareLparCount {
    my $self = shift;
    my $query = qq{
		select
            count(id)
		from
		    hardware_lpar
		where
			customer_id = ?
            and status = 'INACTIVE'
            and days(current timestamp) - days(record_time) > ?
        };

    dlog("queryHardwareLparCount=$query");
    return ( 'hardwareLparCount', $query );
}

sub queryHardwareLparIds {
    my $self = shift;

    my @fields = (qw(id));

    my $query = qq{
		select
            id
		from
		    hardware_lpar
		where
			customer_id = ?
            and status = 'INACTIVE'
            and days(current timestamp) - days(record_time) > ?
        };

    dlog("queryHardwareLparIds=$query");
    return ( 'hardwareLparIds', $query, \@fields );
}

sub getHardwareIds {
    my $self = shift;

    my @ids;

    dlog('Preparing hardware query');
    $self->connection->prepareSqlQueryAndFields( $self->queryHardwareIds );
    dlog('Hardware query prepared');

    dlog('Obtaining statement handle');
    my $sth = $self->connection->sql->{hardwareIds};
    dlog('Obtained statement handle');

    dlog('Binding columns');
    my %rec;
    $sth->bind_columns( map { \$rec{$_} }
            @{ $self->connection->sql->{hardwareIdsFields} } );
    dlog('Columns binded');

    dlog('Executing query');
    $sth->execute( $self->customer->id, $self->age );
    dlog('Executed query');

    dlog('Looping through resultset');
    while ( $sth->fetchrow_arrayref ) {
        dlog( $rec{id} );
        push @ids, $rec{id};
    }
    dlog('Loop complete');

    dlog('Closing statement handle');
    $sth->finish;
    dlog('Closed statement handle');

    return @ids;
}

sub queryHardwareCount {
    my $self = shift;

    my $query = qq{
		select
            count(h.id)
		from
		    hardware h
		where
			h.customer_id = ?
            and status = 'INACTIVE'
            and hardware_status = 'REMOVED'
            and days(current timestamp) - days(record_time) > ?
            and not exists(select 1 from hardware_lpar hl where
                h.id = hl.hardware_id and h.customer_id
                != hl.customer_id)
        };

    dlog("queryHardwareCount=$query");
    return ( 'hardwareCount', $query );
}

sub queryHardwareIds {
    my $self = shift;

    my @fields = (qw(id));

    my $query = qq{
		select
            h.id
		from
		    hardware h
		where
			h.customer_id = ?
            and status = 'INACTIVE'
            and hardware_status = 'REMOVED'
            and days(current timestamp) - days(record_time) > ?
            and not exists(select 1 from hardware_lpar hl where
                h.id = hl.hardware_id and h.customer_id
                != hl.customer_id)
        };

    dlog("queryHardwareIds=$query");
    return ( 'hardwareIds', $query, \@fields );
}

sub getInstalledSoftwareIds {
    my $self = shift;

    my @ids;

    dlog('Preparing installed software query');
    $self->connection->prepareSqlQueryAndFields(
        $self->queryInstalledSoftwareIds );
    dlog('Prepared installed software query');

    dlog('Obtaining statement handle');
    my $sth = $self->connection->sql->{installedSoftwareIds};
    dlog('Obtained statement handle');

    dlog('Binding columns');
    my %rec;
    $sth->bind_columns( map { \$rec{$_} }
            @{ $self->connection->sql->{installedSoftwareIdsFields} } );
    dlog('Columns binded');

    dlog('Executing query');
    $sth->execute( $self->customer->id, $self->age, $self->age );
    dlog('Executed query');

    dlog('Looping through resultset');
    while ( $sth->fetchrow_arrayref ) {
        dlog( $rec{id} );
        push @ids, $rec{id};
    }
    dlog('Loop complete');

    dlog('Closing statement handle');
    $sth->finish;
    dlog('Closed statement handle');

    return @ids;
}

sub queryInstalledSwCount {
    my $self = shift;
    my $query = qq{
		select
            count(is.id)
		from
		    software_lpar sl
            ,installed_software is
            ,software s
		where
			sl.customer_id = ?
			and sl.id = is.software_lpar_id
			and is.software_id = s.software_id
            and ( 
                    (is.status = 'INACTIVE' and days(current timestamp) - days(is.record_time) > ?) 
                    or 
                    (sl.status = 'INACTIVE' and days(current timestamp) - days(sl.record_time) > ?)
                    or
                    (s.status = 'INACTIVE')
                 )
        };

    dlog("queryInstalledSwCount=$query");
    return ( 'installedSwCount', $query );
}

sub queryInstalledSoftwareIds {
    my $self = shift;

    my @fields = (qw(id));

    my $query = qq{
		select
            is.id
		from
		    software_lpar sl
            ,installed_software is
            ,software s
		where
			sl.customer_id = ?
			and sl.id = is.software_lpar_id
			and is.software_id = s.software_id
            and ( 
                    (is.status = 'INACTIVE' and days(current timestamp) - days(is.record_time) > ?) 
                    or 
                    (sl.status = 'INACTIVE' and days(current timestamp) - days(sl.record_time) > ?)
                    or
                    (s.status = 'INACTIVE')
                 )
        };

    dlog("queryInstalledSoftwareIds=$query");
    return ( 'installedSoftwareIds', $query, \@fields );
}

sub getSoftwareLparIds {
    my $self = shift;

    my @ids;

    dlog('Preparing software lpar query');
    $self->connection->prepareSqlQueryAndFields(
        $self->querySoftwareLparIds );
    dlog('Prepared software lpar query');

    dlog('Obtaining statement handle');
    my $sth = $self->connection->sql->{softwareLparIds};
    dlog('Obtained statement handle');

    dlog('Binding columns');
    my %rec;
    $sth->bind_columns( map { \$rec{$_} }
            @{ $self->connection->sql->{softwareLparIdsFields} } );
    dlog('Columns binded');

    dlog('Executing query');
    $sth->execute( $self->customer->id, $self->age );
    dlog('Executed query');

    dlog('Looping through resultset');
    while ( $sth->fetchrow_arrayref ) {
        dlog( $rec{id} );
        push @ids, $rec{id};
    }
    dlog('Loop complete');

    dlog('Closing statement handle');
    $sth->finish;
    dlog('Closed statement handle');

    return @ids;
}

sub querySoftwareLparCount {
    my $self = shift;
    my $query = qq{
		select
            count(id)
		from
		    software_lpar a
		where
			a.customer_id = ?
            and a.status = 'INACTIVE'
            and not exists(select 1 from installed_software is where
                is.software_lpar_id=a.id)
            and days(current timestamp) - days(a.record_time) > ?
        };

    dlog("querySoftwareLparCount=$query");
    return ( 'softwareLparCount', $query);
}

sub querySoftwareLparIds {
    my $self = shift;

    my @fields = (qw(id));

    my $query = qq{
		select
            id
		from
		    software_lpar a
		where
			a.customer_id = ?
            and a.status = 'INACTIVE'
            and not exists(select 1 from installed_software is where
                is.software_lpar_id=a.id)
            and days(current timestamp) - days(a.record_time) > ?
        };

    dlog("querySoftwareLparIds=$query");
    return ( 'softwareLparIds', $query, \@fields );
}

sub connection {
    my ( $self, $value ) = @_;
    $self->{_connection} = $value if defined($value);
    return ( $self->{_connection} );
}

sub customer {
    my ( $self, $value ) = @_;
    $self->{_customer} = $value if defined($value);
    return ( $self->{_customer} );
}

sub age {
    my ( $self, $value ) = @_;
    $self->{_age} = $value if defined($value);
    return ( $self->{_age} );
}

sub testMode {
    my ( $self, $value ) = @_;
    $self->{_testMode} = $value if defined($value);
    return ( $self->{_testMode} );
}

1;
