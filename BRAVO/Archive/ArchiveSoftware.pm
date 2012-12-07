package BRAVO::Archive::ArchiveSoftware;

use strict;
use Base::Utils;
use Carp qw( croak );
use IO::File;
use Archive::Zip;
use Net::FTP;

sub new {
    my ($class, $connection, $testMode, $software, $archiveFile,
        $host,  $dir,        $user,     $password
        )
        = @_;
    my $self = {
        _connection  => $connection,
        _testMode    => $testMode,
        _customer    => $software,
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

    croak 'Software is undefined'
        unless defined $self->software;
}

sub archive {
    my $self = shift;

    ilog('Creating file handle');
    $self->createFileHandle;
    ilog('File handle created');

    ilog('Archiving software signature history objects');
    $self->archiveSoftwareSignatureHistory;
    ilog('Archived software signature history objects');

    ilog('Archiving signatures');
    $self->archiveSoftwareSignatures;
    ilog('Archived signatures');

    ilog('Archiving filter history');
    $self->archiveSoftwareFilterHistory;
    ilog('Archived filter history');

    ilog('Archiving filters');
    $self->archiveSoftwareFilters;
    ilog('Archived filters');

    ilog('Archiving bundle software');
    $self->archiveBundleSoftware;
    ilog('Archived bundle software');

    ilog('Archiving bundles');
    $self->archiveBundles;
    ilog('Archived bundles');

    ilog('Archiving vm product');
    $self->archiveVmProduct;
    ilog('Archived vm product');

    ilog('Archiving sa product');
    $self->archiveSaProduct;
    ilog('Archived sa product');

    ilog('Archiving dorana product');
    $self->archiveDoranaProduct;
    ilog('Archived dorana product');

    ilog('Archiving software objects');
    $self->archiveSoftware;
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

sub archiveSoftwareSignatureHistory {
    my $self = shift;

    my $fh = $self->fileHandle;

    my @ids = $self->getSoftwareSignatureHistoryIds;
    foreach my $id (@ids) {
        my $softwareSignatureHistory
            = new BRAVO::OM::SoftwareSignatureHistory();
        $softwareSignatureHistory->id($id);
        $softwareSignatureHistory->getById( $self->connection );
        ilog( $softwareSignatureHistory->toString );

        dlog('Archiving software signature history');
        my $softwareSignatureHistoryArchive
            = new BRAVO::Archive::SoftwareSignatureHistory( $self->connection,
            $softwareSignatureHistory );
        $softwareSignatureHistoryArchive->archive;
        dlog('Software signature history archived');
        $self->isArchive(1);
        print $fh $softwareSignatureHistoryArchive->log . "\n";
    }
}

sub archiveSoftwareSignatures {
    my $self = shift;

    my $fh = $self->fileHandle;

    my @ids = $self->getSoftwareSignatureIds;
    foreach my $id (@ids) {
        my $softwareSignature = new BRAVO::OM::SoftwareSignature();
        $softwareSignature->id($id);
        $softwareSignature->getById( $self->connection );
        ilog( $softwareSignature->toString );

        dlog('Archiving software signature');
        my $softwareSignatureArchive
            = new BRAVO::Archive::SoftwareSignature( $self->connection,
            $softwareSignature );
        $softwareSignatureArchive->archive;
        dlog('Software signature archived');
        $self->isArchive(1);
        print $fh $softwareSignatureArchive->log . "\n";
    }
}

sub archiveSoftwareFilterHistory {
    my $self = shift;

    my $fh = $self->fileHandle;

    my @ids = $self->getSoftwareFilterHistoryIds;
    foreach my $id (@ids) {
        my $softwareFilterHistory = new BRAVO::OM::SoftwareFilterHistory();
        $softwareFilterHistory->id($id);
        $softwareFilterHistory->getById( $self->connection );
        ilog( $softwareFilterHistory->toString );

        dlog('Archiving software filter history');
        my $softwareFilterHistoryArchive
            = new BRAVO::Archive::SoftwareSignatureHistory(
            $self->connection,
            $softwareFilterHistory
            );
        $softwareFilterHistoryArchive->archive;
        dlog('Software Filter history archived');
        $self->isArchive(1);
        print $fh $softwareFilterHistoryArchive->log . "\n";
    }
}

sub archiveSoftwareFilters {
    my $self = shift;

    my $fh = $self->fileHandle;

    my @ids = $self->getSoftwareFilterIds;
    foreach my $id (@ids) {
        my $softwareFilter = new BRAVO::OM::SoftwareFilter();
        $softwareFilter->id($id);
        $softwareFilter->getById( $self->connection );
        ilog( $softwareFilter->toString );

        dlog('Archiving software Filter');
        my $softwareFilterArchive
            = new BRAVO::Archive::SoftwareFilter( $self->connection,
            $softwareFilter );
        $softwareFilterArchive->archive;
        dlog('Software Filter archived');
        $self->isArchive(1);
        print $fh $softwareFilterArchive->log . "\n";
    }
}

sub archiveBundleSoftware {
    my $self = shift;

    my $fh = $self->fileHandle;

    my @ids = $self->getBundleSoftwareIds;
    foreach my $id (@ids) {
        my $bundleSoftware = new BRAVO::OM::BundleSoftware();
        $bundleSoftware->id($id);
        $bundleSoftware->getById( $self->connection );
        ilog( $bundleSoftware->toString );

        dlog('Archiving bundle software');
        my $bundleSoftwareArchive
            = new BRAVO::Archive::BundleSoftware( $self->connection,
            $bundleSoftware );
        $bundleSoftwareArchive->archive;
        dlog('Bundle software archived');
        $self->isArchive(1);
        print $fh $bundleSoftwareArchive->log . "\n";
    }
}

sub archiveBundles {
    my $self = shift;

    my $fh = $self->fileHandle;

    my @ids = $self->getBundleIds;
    foreach my $id (@ids) {
        my $bundle = new BRAVO::OM::Bundle();
        $bundle->id($id);
        $bundle->getById( $self->connection );
        ilog( $bundle->toString );

        dlog('Archiving bundle');
        my $bundleArchive
            = new BRAVO::Archive::Bundle( $self->connection,
            $bundle );
        $bundleArchive->archive;
        dlog('Bundle archived');
        $self->isArchive(1);
        print $fh $bundleArchive->log . "\n";
    }
}

sub archiveVmProducts {
    my $self = shift;

    my $fh = $self->fileHandle;

    my @ids = $self->getVmProductIds;
    foreach my $id (@ids) {
        my $vmProduct = new BRAVO::OM::VmProduct();
        $vmProduct->id($id);
        $vmProduct->getById( $self->connection );
        ilog( $vmProduct->toString );

        dlog('Archiving vm product');
        my $vmProductArchive
            = new BRAVO::Archive::VmProduct( $self->connection,
            $vmProduct );
        $$vmProductArchive->archive;
        dlog('vm product archived');
        $self->isArchive(1);
        print $fh $$vmProductArchive->log . "\n";
    }
}

sub archiveSaProducts {
    my $self = shift;

    my $fh = $self->fileHandle;

    my @ids = $self->getSaProductIds;
    foreach my $id (@ids) {
        my $saProduct = new BRAVO::OM::SaProduct();
        $saProduct->id($id);
        $saProduct->getById( $self->connection );
        ilog( $saProduct->toString );

        dlog('Archiving Sa product');
        my $saProductArchive
            = new BRAVO::Archive::SaProduct( $self->connection,
            $saProduct );
        $saProductArchive->archive;
        dlog('Sa product archived');
        $self->isArchive(1);
        print $fh $saProductArchive->log . "\n";
    }
}

sub archiveDoranaProducts {
    my $self = shift;

    my $fh = $self->fileHandle;

    my @ids = $self->getDoranaProductIds;
    foreach my $id (@ids) {
        my $doranaProduct = new BRAVO::OM::DoranaProduct();
        $doranaProduct->id($id);
        $doranaProduct->getById( $self->connection );
        ilog( $doranaProduct->toString );

        dlog('Archiving Sa product');
        my $doranaProductArchive
            = new BRAVO::Archive::DoranaProduct( $self->connection,
            $doranaProduct );
        $doranaProductArchive->archive;
        dlog('Sa product archived');
        $self->isArchive(1);
        print $fh $doranaProductArchive->log . "\n";
    }
}

sub archiveSoftware {
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
            id
		from
		    hardware
		where
			customer_id = ?
            and status = 'INACTIVE'
            and hardware_status = 'REMOVED'
            and days(current timestamp) - days(record_time) > ?
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

sub queryInstalledSoftwareIds {
    my $self = shift;

    my @fields = (qw(id));

    my $query = qq{
		select
            is.id
		from
		    software_lpar sl
            ,installed_software is
		where
			sl.customer_id = ?
			and sl.id = is.software_lpar_id
            and is.status = 'INACTIVE'
            and days(current timestamp) - days(is.record_time) > ?
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
