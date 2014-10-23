package BRAVO::Archive::ArchiveBySoftware;

use strict;
use Base::Utils;
use Carp qw( croak );
use IO::File;
use Archive::Zip;
use Net::FTP;
use BRAVO::OM::InstalledSoftware;
use BRAVO::Archive::InstalledSoftware;
use BRAVO::OM::LicenseSoftwareMap;
use BRAVO::Archive::LicenseSoftwareMap;

sub new {
    my ($class,       $connection, $testMode, $customer, $software,
        $archiveFile, $host,       $dir,      $user,     $password
        )
        = @_;
    my $self = {
        _connection  => $connection,
        _testMode    => $testMode,
        _customer    => $customer,
        _software    => $software,
        _archiveFile => $archiveFile,
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

    croak 'Software is undefined'
        unless defined $self->software;
}

sub archive {
    my $self = shift;

    ilog('Creating file handle');
    $self->createFileHandle;
    ilog('File handle created');

    ilog('Archiving software objects');
    $self->archiveInstalledSoftware;
    ilog('Archived software objects');

    ilog('Archiving license sw map');
    $self->archiveLicenseSoftwareMap;
    ilog('Archived license sw map');

    ilog('Archiving schedule f');
    $self->archiveScheduleF;
    ilog('Archived schedule f');

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

sub archiveLicenseSoftwareMap {
    my $self = shift;

    my $fh = $self->fileHandle;

    my @ids = $self->getLicenseSoftwareMapIds;
    foreach my $id (@ids) {
        my $licenseSwMap = new BRAVO::OM::LicenseSoftwareMap();
        $licenseSwMap->id($id);
        $licenseSwMap->getById( $self->connection );
        ilog( $licenseSwMap->toString );

        dlog('Archiving Sa product');
        my $licenseSwMapArchive
            = new BRAVO::Archive::LicenseSoftwareMap( $self->connection,
            $licenseSwMap );
        $licenseSwMapArchive->archive;
        dlog('Sa product archived');
        $self->isArchive(1);
        print $fh $licenseSwMapArchive->log . "\n";
    }
}

sub archiveScheduleF {
    my $self = shift;

    my $fh = $self->fileHandle;
    
    my @ids = $self->getScheduleFHistoryIds;
    foreach my $id (@ids) {
        my $scheduleFHistory = new BRAVO::OM::ScheduleFHistory();
        $scheduleFHistory->id($id);
        $scheduleFHistory->getById( $self->connection );
        ilog( $scheduleFHistory->toString );

        dlog('Archiving Sa product');
        my $scheduleFHistoryArchive
            = new BRAVO::Archive::ScheduleFHistory( $self->connection,
            $scheduleFHistory );
        $scheduleFHistoryArchive->archive;
        dlog('Sa product archived');
        $self->isArchive(1);
        print $fh $scheduleFHistoryArchive->log . "\n";
    }

    @ids = $self->getScheduleFIds;
    foreach my $id (@ids) {
        my $scheduleF = new BRAVO::OM::ScheduleF();
        $scheduleF->id($id);
        $scheduleF->getById( $self->connection );
        ilog( $scheduleF->toString );

        dlog('Archiving Sa product');
        my $scheduleFArchive
            = new BRAVO::Archive::ScheduleF( $self->connection, $scheduleF );
        $scheduleFArchive->archive;
        dlog('Sa product archived');
        $self->isArchive(1);
        print $fh $scheduleFArchive->log . "\n";
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
    $sth->execute( $self->customer->id, $self->software->id );
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
			and s.software_id = ?
			and sl.id = is.software_lpar_id
            and is.software_id = s.software_id
        };

    dlog("queryInstalledSoftwareIds=$query");
    return ( 'installedSoftwareIds', $query, \@fields );
}

sub getLicenseSoftwareMapIds {
    my $self = shift;

    my @ids;

    dlog('Preparing license software map query');
    $self->connection->prepareSqlQueryAndFields(
        $self->queryLicenseSoftwareMapIds );
    dlog('Prepared license software map query');

    dlog('Obtaining statement handle');
    my $sth = $self->connection->sql->{licenseSoftwareMapIds};
    dlog('Obtained statement handle');

    dlog('Binding columns');
    my %rec;
    $sth->bind_columns( map { \$rec{$_} }
            @{ $self->connection->sql->{licenseSoftwareMapIdsFields} } );
    dlog('Columns binded');

    dlog('Executing query');
    $sth->execute( $self->customer->id, $self->software->id );
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

sub queryLicenseSoftwareMapIds {
    my $self = shift;

    my @fields = (qw(id));

    my $query = qq{
		select
            lsm.id
		from
		    license l
		    ,license_sw_map lsm
		where
			l.customer_id = ?
			and lsm.software_id = ?
			and l.id = lsm.license_id
        };

    dlog("queryLicenseSoftwareMapIds=$query");
    return ( 'licenseSoftwareMapIds', $query, \@fields );
}

sub getScheduleFHistoryIds {
    my $self = shift;

    my @ids;

    dlog('Preparing schedule f history query');
    $self->connection->prepareSqlQueryAndFields(
        $self->queryScheduleFHistoryIds );
    dlog('Prepared schedule f history query');

    dlog('Obtaining statement handle');
    my $sth = $self->connection->sql->{scheduleFHistoryIds};
    dlog('Obtained statement handle');

    dlog('Binding columns');
    my %rec;
    $sth->bind_columns( map { \$rec{$_} }
            @{ $self->connection->sql->{scheduleFHistoryIdsFields} } );
    dlog('Columns binded');

    dlog('Executing query');
    $sth->execute( $self->customer->id, $self->software->id,
        $self->software->id );
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

sub queryScheduleFHistoryIds {
    my $self = shift;

    my @fields = (qw(id));

    my $query = qq{
		select
            sfh.id
		from
		    schedule_f_h sfh
		    ,schedule_f sf
		where
            sfh.schedule_f_id = sf.id
            and sfh.customer_id = ?
            and (sfh.software_id = ? or sf.software_id = ?)
        };

    dlog("queryLicenseSoftwareMapIds=$query");
    return ( 'licenseSoftwareMapIds', $query, \@fields );
}

sub getScheduleFIds {
    my $self = shift;

    my @ids;

    dlog('Preparing schedule f query');
    $self->connection->prepareSqlQueryAndFields( $self->queryScheduleFIds );
    dlog('Prepared schedule f query');

    dlog('Obtaining statement handle');
    my $sth = $self->connection->sql->{scheduleFIds};
    dlog('Obtained statement handle');

    dlog('Binding columns');
    my %rec;
    $sth->bind_columns( map { \$rec{$_} }
            @{ $self->connection->sql->{scheduleFIdsFields} } );
    dlog('Columns binded');

    dlog('Executing query');
    $sth->execute( $self->customer->id, $self->software->id );
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

sub queryScheduleFIds {
    my $self = shift;

    my @fields = (qw(id));

    my $query = qq{
		select
            sf.id
		from
		    schedule_f sf
		where
            sf.customer_id = ?
            and sf.software_id = ?
        };

    dlog("queryScheduleFIds=$query");
    return ( 'scheduleFIds', $query, \@fields );
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

sub software {
    my ( $self, $value ) = @_;
    $self->{_software} = $value if defined($value);
    return ( $self->{_software} );
}

sub archiveFile {
    my ( $self, $value ) = @_;
    $self->{_archiveFile} = $value if defined($value);
    return ( $self->{_archiveFile} );
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
