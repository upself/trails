# This script is used to do O/R mapping for Event DB table
# --------------------------------------------------------------
# The following is the DDL for Event DB Table
# ================================================
# CREATE TABLE EAADMIN.EVENT
# (
#    EVENT_ID INT NOT NULL,
#    VALUE VARCHAR(256) NOT NULL,
#    RECORD_TIME TIMESTAMP NOT NULL
# );
# --------------------------------------------------------------
# Author: liuhaidl@cn.ibm.com 
# Date        Who            Version         Description
# ----------  ------------   -----------     ----------------------------------------------------------------------------
# 2013-05-06  Liu Hai(Larry) 1.0.0           This is the initial version for Event object script


package HealthCheck::OM::Event;

use strict;
use Base::Utils;

sub new {
    my ($class) = @_;
    my $self = {
        _eventId => undef
        ,_eventValue => undef
        ,_eventRecordTime => undef
    };
    bless $self, $class;
    return $self;
}

sub equals {
    my ($self, $object) = @_;
    my $equal;

    $equal = 0;
    if (defined $self->eventId && defined $object->eventId) {
        $equal = 1 if $self->eventId eq $object->eventId;
    }
    $equal = 1 if (!defined $self->eventId && !defined $object->eventId);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->eventValue && defined $object->eventValue) {
        $equal = 1 if $self->eventValue eq $object->eventValue;
    }
    $equal = 1 if (!defined $self->eventValue && !defined $object->eventValue);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->eventRecordTime && defined $object->eventRecordTime) {
        $equal = 1 if $self->eventRecordTime eq $object->eventRecordTime;
    }
    $equal = 1 if (!defined $self->eventRecordTime && !defined $object->eventRecordTime);
    return 0 if $equal == 0;

	return 1;
}

sub eventId {
    my $self = shift;
    $self->{_eventId} = shift if scalar @_ == 1;
    return $self->{_eventId};
}

sub eventValue {
    my $self = shift;
    $self->{_eventValue} = shift if scalar @_ == 1;
    return $self->{_eventValue};
}

sub eventRecordTime {
    my $self = shift;
    $self->{_eventRecordTime} = shift if scalar @_ == 1;
    return $self->{_eventRecordTime};
}

sub toString {
    my ($self) = @_;
    my $s = "[Event] ";
    $s .= "eventId=";
    if (defined $self->{_eventId}) {
        $s .= $self->{_eventId};
    }
    $s .= ",";
    $s .= "eventValue=";
    if (defined $self->{_eventValue}) {
        $s .= $self->{_eventValue};
    }
    $s .= ",";
    $s .= "eventRecordTime=";
    if (defined $self->{_eventRecordTime}) {
        $s .= $self->{_eventRecordTime};
    }
    chop $s;
    return $s;
}

sub insert {
   my($self, $connection) = @_;
   #ilog("insert: ".$self->toString());
   $connection->prepareSqlQuery($self->queryInsert);
   my $sth = $connection->sql->{insertEvent};

   my $eventId = $self->eventId;
   my $eventValue = $self->eventValue;
   my $eventRecordTime = $self->eventRecordTime;
   
   $sth->execute(
        $self->eventId
       ,$self->eventValue
       ,$self->eventRecordTime
      );
    
   $sth->finish;
}

sub queryInsert {
    my $query = '
        INSERT INTO EVENT (
            EVENT_ID
            ,VALUE
            ,RECORD_TIME
        ) VALUES (
            ?
            ,?
            ,?
        )
    ';
    return ('insertEvent', $query);
}

sub delete {
    my($self, $connection) = @_;
    #ilog("deleting: ".$self->toString());
    if( defined $self->eventId ) {
        $connection->prepareSqlQuery($self->queryDelete());
        my $sth = $connection->sql->{deleteEvent};
        $sth->execute(
            $self->eventId
        );
        $sth->finish;
    }
}

sub queryDelete {
    my $query = '
        DELETE FROM EVENT
        WHERE
            EVENT_ID = ?
    ';
    return ('deleteEvent', $query);
}

1;