#!/usr/bin/perl -w

###Globals

###Modules
use strict;
use Getopt::Std;
use IO::Handle;
use Text::CSV_XS;
use Base::Utils;
use Database::Connection;
use CNDB::Delegate::CNDBDelegate;
use BRAVO::Delegate::BRAVODelegate;
use BRAVO::OM::SoftwareLpar;
use Staging::Delegate::StagingDelegate;
use Staging::OM::SoftwareLpar;

###Usage
use vars qw( $opt_a $opt_n $opt_f $opt_v );
getopts("a:n:f:v");

###Set logging level
logging_level("info");

###Get bravo db connection
dlog("getting bravo connection");
my $bravoConnection = Database::Connection->new('trails');

###Get staging db connection
dlog("getting staging connection");
my $stagingConnection = Database::Connection->new('staging');

eval {
	if ( defined $opt_f )
	{
		die "File $opt_f not found!!\n" unless -e "$opt_f";
		my $csv = Text::CSV_XS->new( { binary => 1, eol => $/ } );
		open my $io, "<", $opt_f or die "Unable to read file $opt_f: $!";
		my $lineNum = 0;
		while ( my $row = $csv->getline($io) ) {
			$lineNum++;
			if ( defined @$row && scalar(@$row) == 2 ) {
				my @fields = qw(
				  accountNumber
				  lparName
				);
				my $index = 0;
				my %rec = map { $fields[ $index++ ] => $_ } @$row;
				logRec( 'dlog', \%rec );
				executeHchk(
					$bravoConnection,    $stagingConnection,
					$rec{accountNumber}, $rec{lparName}
				);
			}
			else {
				elog("csv parsing error on line $lineNum of file $opt_f");
				close($io);
			}
			last if eof($io);
		}
		close($io);
	}
	else {
		if ( defined $opt_a && defined $opt_n ) {
			executeHchk( $bravoConnection, $stagingConnection, $opt_a, $opt_n );
		}
		else {
			die
			  "Usage: $0 -a <account-number> -n <lpar-name> | -f <file> [-v]\n";
		}
	}
};
if ($@) {
	elog($@);
}

###Close bravo db connection
dlog("closing bravo connection");
$bravoConnection->disconnect;

###Close staging db connection
dlog("closing staging connection");
$stagingConnection->disconnect;

exit 0;

sub executeHchk {
	my ( $bravoConnection, $stagingConnection, $accountNumber, $lparName ) = @_;

	###Get customer id
	my $customerId =
	  CNDBDelegate->getCustomerIdByAccountNumber( $bravoConnection,
		$accountNumber );
	die "Unable to get customer id for account number $accountNumber!!\n"
	  unless defined $customerId;
	dlog("customerId=$customerId");

	###Get bravo data for this lpar
	my ( $bravoSoftwareLpar, $bravoInstalledSoftware ) =
	  getBravoData( $bravoConnection, $customerId, $lparName );

	die "Unable to find bravo software lpar:"
	  . " accountNumber = $accountNumber, name = $lparName !!\n "
	  unless defined $bravoSoftwareLpar;

	if ( $bravoSoftwareLpar->status ne 'ACTIVE' ) {
		ilog("BRAVO software lpar is inactive, skipping");
		return;
	}

	###Get staging data for this lpar
	my ( $stagingSoftwareLpar, $stagingScanTimes, $stagingInstalledSoftware ) =
	  getStagingData( $stagingConnection, $customerId, $lparName );

	###Hchk bravo data
	bravoHchk( $accountNumber, $lparName, $bravoSoftwareLpar,
		$bravoInstalledSoftware, $stagingSoftwareLpar, $stagingScanTimes,
		$stagingInstalledSoftware );

	###Hchk staging data
	stagingHchk( $accountNumber, $lparName, $bravoSoftwareLpar,
		$bravoInstalledSoftware, $stagingSoftwareLpar,
		$stagingInstalledSoftware );
}

sub getBravoData {
	my ( $bravoConnection, $customerId, $lparName ) = @_;

	my $bravoSoftwareLpar = new BRAVO::OM::SoftwareLpar();
	$bravoSoftwareLpar->customerId($customerId);
	$bravoSoftwareLpar->name($lparName);
	$bravoSoftwareLpar->getByBizKey($bravoConnection);
	dlog( " bravoSoftwareLpar = " . $bravoSoftwareLpar->toString() );
	return ( undef, undef ) unless defined $bravoSoftwareLpar->id;

	my %bravoInstalledSoftware = ();
	$bravoConnection->prepareSqlQueryAndFields(
		BRAVO::Delegate::BRAVODelegate->queryInstalledSoftwaresBySoftwareLparId() );
	my $sth = $bravoConnection->sql->{installedSoftwaresBySoftwareLparId};
	my %rec;
	$sth->bind_columns( map { \$rec{$_} }
		  @{ $bravoConnection->sql->{installedSoftwaresBySoftwareLparIdFields} }
	);
	$sth->execute(
		$bravoSoftwareLpar->id, $bravoSoftwareLpar->id,
		$bravoSoftwareLpar->id, $bravoSoftwareLpar->id,
		$bravoSoftwareLpar->id
	);

	while ( $sth->fetchrow_arrayref ) {
		logRec( 'dlog', \%rec );
		my $key = $rec{swId} . '.' . $rec{itType} . '.' . $rec{itTypeId};
		foreach my $elem ( keys %rec ) {
			$bravoInstalledSoftware{$key}->{$elem} = $rec{$elem};
		}
	}
	$sth->finish;

	foreach my $key ( keys %bravoInstalledSoftware ) {
		logRec( 'dlog', \%{ $bravoInstalledSoftware{$key} } );
	}

	return ( $bravoSoftwareLpar, \%bravoInstalledSoftware );
}

sub getStagingData {
	my ( $stagingConnection, $customerId, $lparName ) = @_;

	my $stagingSoftwareLpar = new Staging::OM::SoftwareLpar();
	$stagingSoftwareLpar->customerId($customerId);
	$stagingSoftwareLpar->name($lparName);
	$stagingSoftwareLpar->getByBizKey($stagingConnection);
	dlog( " stagingSoftwareLpar = " . $stagingSoftwareLpar->toString() );
	return ( undef, undef ) unless defined $stagingSoftwareLpar->id;

	my %stagingScanTimes         = ();
	my %stagingInstalledSoftware = ();
	$stagingConnection->prepareSqlQueryAndFields(
		Staging::Delegate::StagingDelegate->querySoftwareLparDataByMinMaxIds( 0, 0 ) );
	my $sth = $stagingConnection->sql->{softwareLparDataByMinMaxIds};
	my %rec;
	$sth->bind_columns( map { \$rec{$_} }
		  @{ $stagingConnection->sql->{softwareLparDataByMinMaxIdsFields} } );
	$sth->execute(
		$stagingSoftwareLpar->id, $stagingSoftwareLpar->id,
		$stagingSoftwareLpar->id, $stagingSoftwareLpar->id,
		$stagingSoftwareLpar->id, $stagingSoftwareLpar->id,
		$stagingSoftwareLpar->id, $stagingSoftwareLpar->id,
		$stagingSoftwareLpar->id, $stagingSoftwareLpar->id
	);

	while ( $sth->fetchrow_arrayref ) {
		logRec( 'dlog', \%rec );
		next unless defined $rec{softwareId};
		$stagingScanTimes{ $rec{bankAccountId} } = $rec{scanRecordScanTime};
		my $key =
		    $rec{softwareId} . '.'
		  . $rec{installedSoftwareType} . '.'
		  . $rec{installedSoftwareTypeId};
		foreach my $elem ( keys %rec ) {
			$stagingInstalledSoftware{$key}->{$elem} = $rec{$elem};
		}
	}
	$sth->finish;

	foreach my $key ( keys %stagingInstalledSoftware ) {
		logRec( 'dlog', \%{ $stagingInstalledSoftware{$key} } );
	}

	return ( $stagingSoftwareLpar, \%stagingScanTimes,
		\%stagingInstalledSoftware );
}

sub bravoHchk {
	my ( $accountNumber, $lparName, $bravoSoftwareLpar, $bravoInstalledSoftware,
		$stagingSoftwareLpar, $stagingScanTimes, $stagingInstalledSoftware )
	  = @_;
	foreach my $bKey ( keys %{$bravoInstalledSoftware} ) {
		my ( $lpar, $swId, $baId, $type, $typeId ) = 0;
		my $bravo = $bravoInstalledSoftware->{$bKey};
		if ( defined $stagingSoftwareLpar ) {
			$lpar = 1;
			foreach my $sKey ( keys %{$stagingInstalledSoftware} ) {
				my $staging = $stagingInstalledSoftware->{$sKey};
				if ( $bravo->{swId} == $staging->{softwareId} ) {
					$swId = 1;
					if ( $bravo->{bankAccountId} == $staging->{bankAccountId} )
					{
						$baId = 1;
						if ( $bravo->{itType} eq
							$staging->{installedSoftwareType} )
						{
							$type = 1;
							if ( $bravo->{itTypeId} ==
								$staging->{installedSoftwareTypeId} )
							{
								$typeId = 1;
							}
						}
					}
				}
			}
		}
		my $status;
		if ($lpar) {
			if ($swId) {
				if ($baId) {
					if ($type) {
						if ($typeId) {
							$status = 'MATCH';
						}
						else {
							$status = 'NO_TYPE_ID';
						}
					}
					else {
						$status = 'NO_TYPE';
					}
				}
				else {
					$status = 'NO_BANK_ACCT';
				}
			}
			else {
				$status = 'NO_SW_ID';
			}
		}

		###Assume all manual software is ok
		$status = 'MANUAL' if $bravo->{itType} eq 'MANUAL';

        if ( $stagingScanTimes->{ $bravo->{bankAccountId} } eq
            $bravoSoftwareLpar->scanTime )
        {
            print "*** scan time matches ***\n";
        }

		my $print = 0;
		$print = 1 if defined $opt_v;
		$print = 1 if ( $status ne 'MATCH' && $status ne 'MANUAL' );

		print "BRAVO,$accountNumber,$lparName,$status,"
		  . $bravo->{swId} . ","
		  . $bravo->{bankAccountId} . ","
		  . $bravo->{itType} . ","
		  . $bravo->{itTypeId} . ","
		  . $bravo->{dtId} . ","
		  . $bravo->{isRecordTime} . "\n"
		  if $print == 1;
	}
}

sub stagingHchk {
	my ( $accountNumber, $lparName, $bravoSoftwareLpar, $bravoInstalledSoftware,
		$stagingSoftwareLpar, $stagingInstalledSoftware )
	  = @_;
	foreach my $sKey ( keys %{$stagingInstalledSoftware} ) {
		my ( $lpar, $swId, $baId, $type, $typeId ) = 0;
		my $staging = $stagingInstalledSoftware->{$sKey};
		$lpar = 1;
		foreach my $bKey ( keys %{$bravoInstalledSoftware} ) {
			my $bravo = $bravoInstalledSoftware->{$bKey};
			if ( $bravo->{swId} == $staging->{softwareId} ) {
				$swId = 1;
				if ( $bravo->{bankAccountId} == $staging->{bankAccountId} ) {
					$baId = 1;
					if ( $bravo->{itType} eq $staging->{installedSoftwareType} )
					{
						$type = 1;
						if ( $bravo->{itTypeId} ==
							$staging->{installedSoftwareTypeId} )
						{
							$typeId = 1;
						}
					}
				}
			}
		}
		my $status;
		if ($lpar) {
			if ($swId) {
				if ($baId) {
					if ($type) {
						if ($typeId) {
							$status = 'MATCH';
						}
						else {
							$status = 'NO_TYPE_ID';
						}
					}
					else {
						$status = 'NO_TYPE';
					}
				}
				else {
					$status = 'NO_BANK_ACCT';
				}
			}
			else {
				$status = 'NO_SW_ID';
			}
		}

		###Ignore bank account id mismatch on manual software
		$status = 'MANUAL'
		  if ( $status eq 'NO_BANK_ACCT'
			&& $staging->{installedSoftwareType} eq 'MANUAL' );

		###Assume all software in update is ok
		$status = 'PENDING'
		  if $staging->{installedSoftwareTypeAction} ne 'COMPLETE';

		my $print = 0;
		$print = 1 if defined $opt_v;
		$print = 1
		  if ( $status ne 'MATCH'
			&& $status ne 'MANUAL'
			&& $status ne 'PENDING' );

		print "STAGING,$accountNumber,$lparName,$status,"
		  . $staging->{softwareId} . ","
		  . $staging->{bankAccountId} . ","
		  . $staging->{installedSoftwareType} . ","
		  . $staging->{installedSoftwareTypeId} . ","
		  . $staging->{installedSoftwareTypeAction} . ",," . "\n"
		  if $print == 1;
	}
}
