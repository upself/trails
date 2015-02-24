# This script is used to do loader operations for Event DB table
# Author: liuhaidl@cn.ibm.com 
# Date        Who            Version         Description
# ----------  ------------   -----------     ----------------------------------------------------------------------------
# 2013-05-08  Liu Hai(Larry) 1.0.0           This is the initial version for EventLoaderDelegate object script

package EventLoaderDelegate;
require "/opt/staging/v2/Database/Connection.pm";
use strict;
use Base::Utils;
#use Database::Connection;
use HealthCheck::OM::Event;

#TIMESTAMP STYLE
my $STYLE1 = 1;#YYYY-MM-DD-HH.MM.SS For Example: 2013-04-18-10.30.33
my $STYLE2 = 2;#YYYYMMDDHHMMSS For Example: 20130418103033

sub start {
    my ( $self, $eventTypeName ) = @_;

    #dlog("In start method of EventLoaderDelegate");
    #print "In start method of EventLoaderDelegate\n";

    #dlog("Connecting to STAGING DB");
	#print "Connecting to STAGING DB\n";
    my $connection = Database::Connection->new('staging');
    #dlog("Connected to STAGING DB");
    #print "Connected to STAGING DB\n"; 

    my $event = new HealthCheck::OM::Event(); 
    ###Set our fields
    my $eventId = $self->getEventIDByEventTypeName($connection,$eventTypeName);#get eventId value based on eventTypeName

    $event->eventId($eventId);
    $event->eventValue('STARTED');
	my $eventFiredTime = getCurrentTimeStamp($STYLE1);#Get the current full time using format YYYY-MM-DD-HH.MM.SS
    $eventFiredTime.=".000000"; 
    $event->eventRecordTime($eventFiredTime);

  	#dlog( $event->toString );
	#my $eventRecordInfo = $event->toString;
    #print "$eventRecordInfo\n";

    #dlog("Inserting to database");
    #print "Inserting to database\n";
    $event->insert($connection);
    #dlog("Inserted to database");
	#print "Inserted to database\n";    

    #dlog("Closing connection");
	#print "Closing connection\n";
    $connection->disconnect;
    #dlog("Connection closed");
	#print "Connection closed\n";

    #logMsg( "started: $eventTypeName");
    #print "started: $eventTypeName\n";
    
    ###Return the object
    return $event;
}

sub error {
    my ( $self,$event,$eventTypeName ) = @_;

    #dlog("In error method of EventLoaderDelegate");
	#print "In error method of EventLoaderDelegate\n";

    #dlog("Connecting to STAGING DB");
    #print "Connecting to STAGING DB\n";
    my $connection = Database::Connection->new('staging');
    #dlog("Connected to STAGING DB");
    #print "Connected to STAGING DB\n"; 

    ###Set our fields
	$event->eventValue('ERRORED');
	my $eventFiredTime = getCurrentTimeStamp($STYLE1);#Get the current full time using format YYYY-MM-DD-HH.MM.SS
    $eventFiredTime.=".000000"; 
    $event->eventRecordTime($eventFiredTime);

    #dlog( $event->toString );
	#my $eventRecordInfo = $event->toString;
    #print "$eventRecordInfo\n";

    #dlog("Inserting to database");
	#print "Inserting to database\n";
    $event->insert($connection);
    #dlog("Inserted to database");
	#print "Inserted to database\n";

    #dlog("Closing connection");
	#print "Closing connection\n";
    $connection->disconnect;
    #dlog("Connection closed");
	#print "Connection closed\n";

    #logMsg( "errored: $eventTypeName");
    #print "errored: $eventTypeName\n";
}

sub stop {
    my ( $self,$event,$eventTypeName ) = @_;
   
    #dlog("In stop method of EventLoaderDelegate");
	#print "In stop method of EventLoaderDelegate\n";

    #dlog("Connecting to STAGING DB");
	#print "Connecting to STAGING DB\n";
    my $connection = Database::Connection->new('staging');
	#dlog("Connected to STAGING DB");
    #print "Connected to STAGING DB\n";
    
    ###Set our fields
    $event->eventValue('STOPPED');
    my $eventFiredTime = getCurrentTimeStamp($STYLE1);#Get the current full time using format YYYY-MM-DD-HH.MM.SS
    $eventFiredTime.=".000000"; 
    $event->eventRecordTime($eventFiredTime);

	#dlog( $event->toString );
    #my $eventRecordInfo = $event->toString;
    #print "$eventRecordInfo\n";

    #dlog("Inserting to database");
	#print "Inserting to database\n";
    $event->insert($connection);
	#dlog("Inserted to database");
    #print "Inserted to database\n";

    #dlog("Closing connection");
	#print "Closing connection\n";
    $connection->disconnect;
    #dlog("Connection closed");
    #print "Connection closed\n";

    #logMsg( "stopped: $eventTypeName");
	#print "stopped: $eventTypeName\n";
}

#This method is used to generate the certain format time value
sub getTime
{
    #The function time() returns the amount of accumulate second from 1/1/1970
    my $time = shift || time();
    
    my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime($time);
    
    $mon ++;
    $sec  = ($sec<10)?"0$sec":$sec;#Second[0,59]
    $min  = ($min<10)?"0$min":$min;#minitue[0,59]
    $hour = ($hour<10)?"0$hour":$hour;#Hour[0,23]
    $mday = ($mday<10)?"0$mday":$mday;#Day[1,31]
    $mon  = ($mon<9)?"0$mon":$mon;#Month[0,11]
    $year+=1900;#From 1900 year
    
    #$wday is accumulated from Saturday, stands for which day of one week[0-6]
    #$yday is accumulated from 1/1£¬stands for which day of one year[0,364]
    #$isdst is a flag
    my $weekday = ('Sun','Mon','Tue','Wed','Thu','Fri','Sat')[$wday];
    return { 'second' => $sec,
             'minute' => $min,
             'hour'   => $hour,
             'day'    => $mday,
             'month'  => $mon,
             'year'   => $year,
             'weekNo' => $wday,
             'wday'   => $weekday,
             'yday'   => $yday,
             'date'   => "$year$mon$mday",
		     'fullTime1' => "$year-$mon-$mday-$hour.$min.$sec",
             'fullTime2' => "$year$mon$mday$hour$min$sec"
          };
}

#This method is used to get current timestamp value
sub getCurrentTimeStamp{
   my $timeStampStyle = shift;
   my $dateObject = &getTime();#Get the hash address of current system time object
   my $currentTimeStamp;
   if($timeStampStyle == $STYLE1){#YYYY-MM-DD-HH.MM.SS For Example: 2013-04-18-10.30.33
      $currentTimeStamp = $dateObject->{fullTime1};
   }
   elsif($timeStampStyle == $STYLE2){#YYYYMMDDHHMMSS For Example: 20130418103033
      $currentTimeStamp = $dateObject->{fullTime2};
   }
   
   return $currentTimeStamp;
}


sub getEventIDByEventTypeName {
    my($self, $connection, $eventTypeName) = @_;
    $connection->prepareSqlQuery($self->queryGetByEventTypeName());
    my $sth = $connection->sql->{getByEventTypeName};
    my $eventId;
    $sth->bind_columns(
        \$eventId
    );
    $sth->execute(
      $eventTypeName
    );

	$sth->fetchrow_arrayref;
    $sth->finish;
	#print "eventID: $eventId has been query out based on eventTypeName: $eventTypeName\n";
    return $eventId;
}

sub queryGetByEventTypeName {
    my $query = '
        SELECT
            EVENT_ID
        FROM
            EVENT_TYPE
        WHERE
            NAME = ?
    ';
    return ('getByEventTypeName', $query);
}

1;