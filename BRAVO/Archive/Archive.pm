package BRAVO::Archive::Archive;

use strict;
use Base::Utils;
use Carp qw( croak );
use IO::File;
use Archive::Zip;
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
    my ($class, $connection, $testMode, $customer, $archiveFile,
        $age,   $host,       $dir,      $user,     $password
    ) = @_;
    my $self = {
        _connection  => $connection,
        _testMode    => $testMode,
        _customer    => $customer,
        _archiveFile => $archiveFile,
        _age         => $age,
        _host        => $host,
        _dir         => $dir,
        _user        => $user,
        _password    => $password,
        _fileHandle  => undef,
        _isArchive   => 0
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

    ilog('Creating file handle');
    $self->createFileHandle;
    ilog('File handle created');
    
    ilog('Archiving hardware lpar objects');
    $self->archiveHardwareLpar;
    ilog('Archived hardware lpar objects');

    ilog('Archiving hardware objects');
    $self->archiveHardware;
    ilog('Archived hardware objects');

    ilog('Archiving software objects');
    $self->archiveInstalledSoftware;
    ilog('Archived software objects');
    
    ilog('Archiving software objects');
    $self->archiveSoftwareLpar;
    ilog('Archived software objects');

    ilog('Closing file handle');
    $self->closeFileHandle;
    ilog('File handle closed');

    ilog('Checking for a non-zero size archive file');
    if ( $self->isArchive == 1 ) {
        ilog('Archive file has records');

        ilog('Creating zip file');
        $self->zipFile;
        ilog('Zip file created');

        ilog('Transferring file');
        $self->ftpFile if $self->testMode == 0;
        ilog('File transferred');
    }
    else {
        ilog('Archive file is less than 0 bytes');
        unlink $self->archiveFile;
    }
}

sub createFileHandle {
    my $self = shift;

    my $fh = new IO::File "> " . $self->archiveFile;

    $self->fileHandle($fh);
}

sub archiveHardwareLpar {
    my $self = shift;

    my $fh = $self->fileHandle;

    print $fh $self->customer->toString . "\n";

    my @lparIds = $self->getHardwareLparIds;
    foreach my $id (@lparIds) {
        my $hardwareLpar = new BRAVO::OM::HardwareLpar();
        $hardwareLpar->id($id);
        $hardwareLpar->getById( $self->connection );
        ilog( $hardwareLpar->toString );

        dlog('Archiving hardware lpar');
        my $hardwareLparArchive
            = new BRAVO::Archive::HardwareLpar( $self->connection,
            $hardwareLpar );
        $hardwareLparArchive->archive;
        dlog('Hardware lpar archived');
        $self->isArchive(1);
        print $fh $hardwareLparArchive->log . "\n";
    }

}

sub archiveHardware {
    my $self = shift;

    my $fh = $self->fileHandle;

    print $fh $self->customer->toString . "\n";

    my @hardwareIds = $self->getHardwareIds;
    foreach my $id (@hardwareIds) {
        my $hardware = new BRAVO::OM::Hardware();
        $hardware->id($id);
        $hardware->getById( $self->connection );
        ilog( $hardware->toString );

        dlog('Archiving hardware');
        my $hardwareArchive
            = new BRAVO::Archive::Hardware( $self->connection, $hardware );
        $hardwareArchive->archive;
        dlog('Hardware archived');
        $self->isArchive(1);
        print $fh $hardwareArchive->log . "\n";
    }
}

sub archiveInstalledSoftware {
    my $self = shift;

    my $fh = $self->fileHandle;

    my @installedSoftwareIds = $self->getInstalledSoftwareIds;
    foreach my $id (@installedSoftwareIds) {
        my $installedSoftware = new BRAVO::OM::InstalledSoftware();
        $installedSoftware->id($id);
        $installedSoftware->getById( $self->connection );
        ilog( $installedSoftware->toString );

        dlog('Archiving installed software');
        my $installedSoftwareArchive
            = new BRAVO::Archive::InstalledSoftware( $self->connection,
            $installedSoftware );
        $installedSoftwareArchive->archive;
        dlog('Installed software archived');
        $self->isArchive(1);
        print $fh $installedSoftwareArchive->log . "\n";
    }

}

sub archiveSoftwareLpar {
    my $self = shift;

    my $fh = $self->fileHandle;

    my @softwareLparIds = $self->getSoftwareLparIds;
    foreach my $id (@softwareLparIds) {
        my $softwareLpar = new BRAVO::OM::SoftwareLpar();
        $softwareLpar->id($id);
        $softwareLpar->getById( $self->connection );
        ilog( $softwareLpar->toString );

        ilog('Archiving software lpar');
        my $softwareLparArchive
            = new BRAVO::Archive::SoftwareLpar( $self->connection,
            $softwareLpar );
        $softwareLparArchive->archive;
        dlog('Software lpar archived');
        $self->isArchive(1);
        print $fh $softwareLparArchive->log . "\n";
    }
}

sub closeFileHandle {
    my $self = shift;

    $self->fileHandle->close;
}

sub zipFile {
    my $self = shift;

    my $zip  = Archive::Zip->new();
    my $file = $zip->addFile( $self->archiveFile );

    if ( $zip->writeToFileNamed( $self->archiveFile . '.zip' )
        != Archive::Zip::AZ_OK() )
    {
        elog( 'Could not write to zip file ' . $self->archiveFile . '.zip' );
        die "Error in archive creation!";
    }

    unlink $self->archiveFile;
}

sub ftpFile {
    my $self = shift;

    my $ftp = Net::FTP->new( $self->host, Debug => 0 )
        or die "Unable to connect to " . $self->host . ": $@";
    $ftp->login( $self->user, $self->password )
        or die "Unable to login ", $ftp->message;
    $ftp->cwd( $self->dir )
        or die "Unable to change working directory ", $ftp->message;
    $ftp->put( $self->archiveFile . '.zip' )
        or die "Put file " . $self->archiveFile . ".zip failed ",
        $ftp->message;
    $ftp->quit;

    unlink $self->archiveFile . ".zip";
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

sub querySoftwareLparIds {
    my $self = shift;

    my @fields = (qw(id));

    my $query = qq{
		select
            id
		from
		    software_lpar
		where
			customer_id = ?
            and status = 'INACTIVE'
            and days(current timestamp) - days(record_time) > ?
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

sub archiveFile {
    my ( $self, $value ) = @_;
    $self->{_archiveFile} = $value if defined($value);
    return ( $self->{_archiveFile} );
}

sub age {
    my ( $self, $value ) = @_;
    $self->{_age} = $value if defined($value);
    return ( $self->{_age} );
}

sub host {
    my ( $self, $value ) = @_;
    $self->{_host} = $value if defined($value);
    return ( $self->{_host} );
}

sub dir {
    my ( $self, $value ) = @_;
    $self->{_dir} = $value if defined($value);
    return ( $self->{_dir} );
}

sub user {
    my ( $self, $value ) = @_;
    $self->{_user} = $value if defined($value);
    return ( $self->{_user} );
}

sub password {
    my ( $self, $value ) = @_;
    $self->{_password} = $value if defined($value);
    return ( $self->{_password} );
}

sub fileHandle {
    my ( $self, $value ) = @_;
    $self->{_fileHandle} = $value if defined($value);
    return ( $self->{_fileHandle} );
}

sub testMode {
    my ( $self, $value ) = @_;
    $self->{_testMode} = $value if defined($value);
    return ( $self->{_testMode} );
}

sub isArchive {
    my ( $self, $value ) = @_;
    $self->{_isArchive} = $value if defined($value);
    return ( $self->{_isArchive} );
}

1;
