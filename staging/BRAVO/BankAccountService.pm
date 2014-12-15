package BRAVO::BankAccountService;

use strict;
use Base::Utils;
use BRAVO::OM::BankAccountJob;
use Database::Connection;

sub startJob {
	my ( $self, $bankAccountId, $name ) = @_;

	dlog("In start method of BankAccountService");

	dlog("Connecting to trails");
	my $connection = Database::Connection->new('trails');
	dlog("Connected to trails");

	###Set our fields
	my $bnkAccntJob = new BRAVO::OM::BankAccountJob();
	$bnkAccntJob->bankAccountId($bankAccountId);
	$bnkAccntJob->name($name);

	dlog("Acquiring $name from database");
	$bnkAccntJob->getByBizKey($connection);
	dlog("$name acquired");
	$bnkAccntJob->startTime( dbstamp() );
	$bnkAccntJob->endTime(undef);
	$bnkAccntJob->comments( "Starting " . $bnkAccntJob->name );
	$bnkAccntJob->status('PENDING');
	dlog( $bnkAccntJob->toString );
	dlog("Saving to database");
	$bnkAccntJob->save($connection);
	dlog("Saved to database");

	dlog("Closing connection");
	$connection->disconnect;
	dlog("Connection closed");

	logMsg( "started: " . $bnkAccntJob->name );

	###Return the object
	return $bnkAccntJob;
}

sub stopJob {
	my ( $self, $bnkAccntJob ) = @_;

	dlog("In stop method of BankAccountService");

	dlog("Connecting to trails");
	my $connection = Database::Connection->new('trails');
	dlog("Connected to trails");

	###Set our fields
	$bnkAccntJob->endTime( dbstamp() );
	$bnkAccntJob->comments( "Finished " . $bnkAccntJob->name );
	$bnkAccntJob->status('COMPLETE');
	$bnkAccntJob->firstErrorTime(undef);
	dlog( $bnkAccntJob->toString );

	dlog("Saving to database");
	$bnkAccntJob->save($connection);
	dlog("Saved to database");

	dlog("Closing connection");
	$connection->disconnect;
	dlog("Connection closed");

	logMsg( "stopped: " . $bnkAccntJob->name );
}

sub error {
	my ( $self, $bnkAccntJob, $error ) = @_;

	dlog("In error method of BankAccountService");

	dlog("Connecting to trails");
	my $connection = Database::Connection->new('trails');
	dlog("Connected to trails");

	$error = substr( $error, 0, 254 );

	###Set our fields
	$bnkAccntJob->endTime( dbstamp() );
	$bnkAccntJob->comments($error);
	$bnkAccntJob->status('ERROR');
	my $firstErr = $bnkAccntJob->firstErrorTime;
	if(!defined $firstErr || $firstErr eq ''){ 
		$bnkAccntJob->firstErrorTime( dbstamp() );
	}	
	dlog( $bnkAccntJob->toString );

	dlog("Saving to database");
	$bnkAccntJob->save($connection);
	dlog("Saved to database");

	dlog("Closing connection");
	$connection->disconnect;
	dlog("Connection closed");

	logMsg( "errored: " . $bnkAccntJob->name );
}

sub isFullLoad {
	my ( $self, $job, $hours ) = @_;

	dlog("In isFullLoad method of BankAccountService");

	dlog("Connecting to trails");
	my $connection = Database::Connection->new('trails');
	dlog("Connected to trails");

	dlog('Preparing  query');
	$connection->prepareSqlQueryAndFields( $self->queryFullLoadDiff() );
	dlog('query prepared');

	my $sth = $connection->sql->{fullLoadDiff};
	my %rec;
	$sth->bind_columns( map { \$rec{$_} }
		  @{ $connection->sql->{fullLoadDiffFields} } );
	$sth->execute($job);
	$sth->fetchrow_arrayref();
	$sth->finish();
	dlog("Closing connection");
	$connection->disconnect;
	dlog("Connection closed");

	if ( defined $rec{value} && $rec{value} != 0 ) {
		if ( $rec{value} < $hours ) {
			dlog('Not time for a full load');
			return 0;
		}

		dlog('Time for a full load');
	}

	return 1;
}

sub queryFullLoadDiff {
	my ($self) = @_;
	my @fields = (
		qw(
		  value
		  )
	);
	my $query = '
        select
            ( (DAYS(CURRENT TIMESTAMP)*24 )
               +(MIDNIGHT_SECONDS(CURRENT TIMESTAMP)/3600 )
            ) 
              - 
            ( (DAYS(start_time)*24)
               +(MIDNIGHT_SECONDS(start_time)/3600)
            )
        from
            bank_account_job
        where
            name = ?
    ';

	dlog("queryFullLoadDiff=$query");
	return ( 'fullLoadDiff', $query, \@fields );
}

1;
