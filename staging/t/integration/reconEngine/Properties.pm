#!/usr/bin/perl

package integration::reconEngine::Properties;

use strict;

sub new {
 my ( $class, $properties ) = @_;

 my $self = {
  _installedSoftwareId => $properties->installedSoftwareId,
  _connection          => $properties->connection,
  _customerId          => $properties->customerId,
  _date                => $properties->date,
  _isPool              => $properties->isPool,
  _logFile             => $properties->logFile,
  _reconConfigFile     => $properties->reconConfigFile,
  _connCfgFile         => $properties->connCfgFile            
 };

 bless $self, $class;
 return $self;
}

sub installedSoftwareId {
 my $self = shift;
 $self->{_installedSoftwareId} = shift
   if scalar @_ == 1;
 return $self->{_installedSoftwareId};
}

sub connection {
 my $self = shift;
 $self->{_connection} = shift
   if scalar @_ == 1;
 return $self->{_connection};
}

sub customerId {
 my $self = shift;
 $self->{_customerId} = shift
   if scalar @_ == 1;
 return $self->{_customerId};
}

sub date {
 my $self = shift;
 $self->{_date} = shift
   if scalar @_ == 1;
 return $self->{_date};
}

sub isPool {
 my $self = shift;
 $self->{_isPool} = shift
   if scalar @_ == 1;
 return $self->{_isPool};
}

sub logFile {
 my $self = shift;
 $self->{_logFile} = shift
   if scalar @_ == 1;
 return $self->{_logFile};
}

sub reconConfigFile {
 my $self = shift;
 $self->{_reconConfigFile} = shift
   if scalar @_ == 1;
 return $self->{_reconConfigFile};
}

sub connCfgFile {
 my $self = shift;
 $self->{_connCfgFile} = shift
   if scalar @_ == 1;
 return $self->{_connCfgFile};
}

1;

