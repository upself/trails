package SystemScheduleStatusDelegate;

use strict;
use Base::Utils;
use Sigbank::OM::SystemScheduleStatus;
use Database::Connection;

sub start {
    my ( $self, $name, $retry, $sleepTime ) = @_;

    dlog("In start method of SystemScheduleStatusDelegate");

    dlog("Connecting to trails");
    my $connection = undef; 
    if(defined $retry && defined $sleepTime ){
      $connection = Database::Connection->new('trails',$retry,$sleepTime);
    }else{
      $connection = Database::Connection->new('trails');
    }
    dlog("Connected to trails");

    ###Set our fields
    my $sss = new Sigbank::OM::SystemScheduleStatus();
    $sss->name($name);

    dlog("Acquiring $name from database");
    $sss->getByBizKey($connection);
    dlog("$name acquired");

    $sss->startTime( dbstamp() );
    $sss->endTime(undef);
    $sss->remoteUser('LOADER');
    $sss->comments( "Starting " . $sss->name );
    $sss->status('PENDING');
    dlog( $sss->toString );

    dlog("Saving to database");
    $sss->save($connection);
    dlog("Saved to database");    

    dlog("Closing connection");
    $connection->disconnect;
    dlog("Connection closed");

    logMsg( "started: " . $sss->name );

    ###Return the object
    return $sss;
}

sub error {
    my ( $self, $sss, $error ) = @_;

    dlog("In error method of SystemScheduleStatusDelegate");

    dlog("Connecting to trails");
    my $connection = Database::Connection->new('trails');
    dlog("Connected to trails");

    $error = substr( $error, 0, 254 );

    ###Set our fields
    $sss->endTime( dbstamp() );
    $sss->comments($error);
    $sss->status('ERROR');
    dlog( $sss->toString );

    dlog("Saving to database");
    $sss->save($connection);
    dlog("Saved to database");

    dlog("Closing connection");
    $connection->disconnect;
    dlog("Connection closed");

    logMsg( "errored: " . $sss->name );
}

sub stop {
    my ( $self, $sss ) = @_;

    dlog("In stop method of SystemScheduleStatusDelegate");

    dlog("Connecting to trails");
    my $connection = Database::Connection->new('trails');
    dlog("Connected to trails");

    ###Set our fields
    $sss->endTime( dbstamp() );
    $sss->comments( "Finished " . $sss->name );
    $sss->status('COMPLETE');
    dlog( $sss->toString );

    dlog("Saving to database");
    $sss->save($connection);
    dlog("Saved to database");

    dlog("Closing connection");
    $connection->disconnect;
    dlog("Connection closed");

    logMsg( "stopped: " . $sss->name );
}

sub isFullLoad {
    my ( $self, $job, $hours ) = @_;

    dlog("In isFullLoad method of SystemScheduleStatusDelegate");

    dlog("Connecting to trails");
    my $connection = Database::Connection->new('trails');
    dlog("Connected to trails");

    dlog('Preparing  query');
    $connection->prepareSqlQueryAndFields( $self->queryFullLoadDiff() );
    dlog('query prepared');

    my $sth = $connection->sql->{fullLoadDiff};
    my %rec;
    $sth->bind_columns( map { \$rec{$_} } @{ $connection->sql->{fullLoadDiffFields} } );
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
            system_schedule_status
        where
            name = ?
    ';

    dlog("queryFullLoadDiff=$query");
    return ( 'fullLoadDiff', $query, \@fields );
}
1;
