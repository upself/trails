package Staging::SoftwareSignatureLoader;

use strict;
use Base::Utils;
use Staging::Loader;
use Staging::OM::SoftwareSignature;
use Scan::Delegate::ScanDelegate;
use Staging::Delegate::StagingDelegate;
use Scan::Delegate::SoftwareSignatureDelegate;

our @ISA = qw(Loader);

sub new {
    my ( $class, $bankAccountName ) = @_;

    dlog('Building new SosftwareSignatureLoader object');

    my $self = $class->SUPER::new($bankAccountName);

    $self->{_list} = undef;

    bless $self, $class;

    dlog( 'SoftwareSignatureLoader instantiated for ' . $bankAccountName );

    return $self;
}

sub load {
    my ( $self, %args ) = @_;

    dlog('Start load method');

    my $job = $self->SUPER::bankAccountName . " SOFTWARE SIGNATURE PULL";

    $self->SUPER::load( \%args, $job );

    ilog('Get the staging connection');
    my $stagingConnection = Database::Connection->new('staging');
    ilog('Got Staging connection');

    my $connection;
    eval {
        if ( $self->SUPER::bankAccount->connectionType eq 'CONNECTED' )
        {
            $connection = Database::Connection->new( $self->SUPER::bankAccount );
        }
    };
    if ($@) {
        wlog($@);
        $self->SUPER::endLoad($@);
        return;
    }

    my $dieMsg = undef;
    eval {
        ilog('Preparing the source data');
        $self->prepareSourceData($connection);
        ilog('Source data prepared');

        ilog('Performing the delta');
        $self->doDelta($stagingConnection);
        ilog('Delta complete');

        ###Check if we have crossed the delete threshold
        if ( $self->SUPER::checkDeleteThreshold() ) {
            $dieMsg = '**** We are deleting more than 15% of total records - Aborting ****';
        }
        else {
            ilog('Applying deltas');
            $self->applyDelta($stagingConnection);
            ilog('Deltas applied');
        }
    };
    if ($@) {
        $dieMsg = $@;
        elog($dieMsg);
    }

    Staging::Delegate::StagingDelegate->insertCount( $stagingConnection, $self->count );

    $self->SUPER::endLoad($dieMsg);

    if ( $self->SUPER::bankAccount->connectionType eq 'CONNECTED' ) {
        ilog('Disconnecting from bank account');
        $connection->disconnect
            if ( defined $connection );
        ilog('Disconnected from bank account');
    }

    ilog('Disconnecting from staging');
    $stagingConnection->disconnect;
    ilog('Staging disconnected');

    die $dieMsg if defined $dieMsg;

    dlog('Load method complete');
}

sub prepareSourceData {
    my ( $self, $connection ) = @_;

    dlog('Start prepareSourceData method');

    die('Cannot call method directly') if ( $self->SUPER::flag == 0 );

    eval {
        $self->list(
                     SoftwareSignatureDelegate->getSoftwareSignatureData(
                                                       $connection, $self->SUPER::bankAccount, $self->loadDeltaOnly
                     )
        );
    };
    if ($@) {
        wlog($@);
        die $@;
    }

    dlog('End prepareSourceData method');
}

sub doDelta {
    my ( $self, $connection ) = @_;

    dlog('Start doDelta method');

    die('Cannot call method directly') if ( $self->SUPER::flag == 0 );

    if ( !defined $self->list ) {
        wlog('scanlist is not defined');
        return;
    }

    if ( scalar keys %{ $self->list } == 0 ) {
        wlog('scanlist is zero');
        return;
    }

    my $signatureList = $self->list;

    ###Loop through the staging query
    ###Prepare the necessary sql

    $connection->prepareSqlQuery( Staging::Delegate::StagingDelegate->querySoftwareSignatureData() );

    ###Define our fields
    my @fields = (qw(id softwareSignatureId softwareId action path scanRecordId scanRecordAction));

    ###Get the statement handle
    my $sth = $connection->sql->{softwareSignatureData};

    ###Bind our columns
    my %rec;
    $sth->bind_columns( map { \$rec{$_} } @fields );

    ###Excute the query
    $sth->execute( $self->SUPER::bankAccount->id );
    while ( $sth->fetchrow_arrayref ) {

        if ( $rec{action} eq 'DELETE' ) {
            delete $signatureList->{ $rec{softwareId} }->{ $rec{softwareSignatureId} }->{ $rec{scanRecordId} };
            next;
        }

        if ( $rec{scanRecordAction} eq 'DELETE' ) {
            delete $signatureList->{ $rec{softwareId} }->{ $rec{softwareSignatureId} }->{ $rec{scanRecordId} };
            next;
        }

        $self->SUPER::incrTotalCnt();

        ###check if software exists
        if ( exists $signatureList->{ $rec{softwareId} } ) {
            dlog( $rec{softwareId} . " softwareId exists in source" );

            ###check if software signature exists
            if ( exists $signatureList->{ $rec{softwareId} }->{ $rec{softwareSignatureId} } ) {
                dlog( $rec{softwareSignatureId} . " softwareSignatureId exists in source" );

                ###check if scan record exists
                if (
                     exists $signatureList->{ $rec{softwareId} }->{ $rec{softwareSignatureId} }
                     ->{ $rec{scanRecordId} } )
                {
                    dlog( $rec{scanRecordId} . " scanRecordId exists in source" );

                    $signatureList->{ $rec{softwareId} }->{ $rec{softwareSignatureId} }->{ $rec{scanRecordId} }
                        ->{'id'} = $rec{id};

                    #Get all the keys even though there should only be one
                    my $path =  $signatureList->{ $rec{softwareId} }->{ $rec{softwareSignatureId} }->{ $rec{scanRecordId} }->{'path'};
                    my $scanAction= $signatureList->{ $rec{softwareId} }->{ $rec{softwareSignatureId} }->{ $rec{scanRecordId} }->{'action'};
                    
                    my $bankAccountType = $self->SUPER::bankAccount->type;
                    if($bankAccountType eq 'TLM' || $bankAccountType eq 'TAD4D')
                    {
                      if( stringEqual( $rec{action}, $scanAction)){
                         delete $signatureList->{ $rec{softwareId} }->{ $rec{softwareSignatureId} }->{ $rec{scanRecordId} };
                      }
                    }else{
                       if($self->pathChanged($path, $rec{path})){
                          if( $rec{action} eq 'COMPLETE' && $self->SUPER::bankAccountName ne 'S03INV40'){
                              dlog("Setting record to update since path has changed");
                              $self->list->{ $rec{softwareId} }->{$rec{softwareSignatureId}}->{ $rec{scanRecordId} }->{'action'} = 'UPDATE';
                              $self->SUPER::incrUpdateCnt();
                          }else{
                            delete $signatureList->{ $rec{softwareId} }->{ $rec{softwareSignatureId} }->{ $rec{scanRecordId} };
                          }
                       }else{
                         delete $signatureList->{ $rec{softwareId} }->{ $rec{softwareSignatureId} }->{ $rec{scanRecordId} };
                       }
                    }
                }
                else {
                    dlog( $rec{scanRecordId} . " scanRecordId does not exist in source" );

                    if ( $rec{action} eq 'COMPLETE' ) {
                        dlog("Setting record to delete");
                        $signatureList->{ $rec{softwareId} }->{ $rec{softwareSignatureId} }->{ $rec{scanRecordId} }
                            ->{'action'} = 'DELETE';
                        $signatureList->{ $rec{softwareId} }->{ $rec{softwareSignatureId} }->{ $rec{scanRecordId} }
                            ->{'id'} = $rec{id};
                        $signatureList->{ $rec{softwareId} }->{ $rec{softwareSignatureId} }->{ $rec{scanRecordId} }
                            ->{'path'} = $rec{path};
                        $self->SUPER::incrDeleteCnt();
                    }
                }
            }
            else {
                dlog( $rec{softwareSignatureId} . " softwareSignatureId does not exist in source" );

                if ( $rec{action} eq 'COMPLETE' ) {
                    dlog("Setting record to delete");
                    $signatureList->{ $rec{softwareId} }->{ $rec{softwareSignatureId} }->{ $rec{scanRecordId} }
                        ->{'action'} = 'DELETE';
                    $signatureList->{ $rec{softwareId} }->{ $rec{softwareSignatureId} }->{ $rec{scanRecordId} }
                        ->{'id'} = $rec{id};
                    $signatureList->{ $rec{softwareId} }->{ $rec{softwareSignatureId} }->{ $rec{scanRecordId} }
                        ->{'path'} = $rec{path};
                    $self->SUPER::incrDeleteCnt();
                }
            }
        }
        else {
            dlog( $rec{softwareId} . " softwareId does not exist in source" );

            if ( $rec{action} eq 'COMPLETE' ) {
                dlog("Setting record to delete");
                $signatureList->{ $rec{softwareId} }->{ $rec{softwareSignatureId} }->{ $rec{scanRecordId} }
                    ->{'action'} = 'DELETE';
                $signatureList->{ $rec{softwareId} }->{ $rec{softwareSignatureId} }->{ $rec{scanRecordId} }
                    ->{'id'} = $rec{id};
                $signatureList->{ $rec{softwareId} }->{ $rec{softwareSignatureId} }->{ $rec{scanRecordId} }
                    ->{'path'} = $rec{path};
                $self->SUPER::incrDeleteCnt();
            }
        }
    }
    $sth->finish;

    $self->list($signatureList);
}

sub pathChanged{
   my ($self,$scanPath, $stagingPath ) = @_;
   
   $scanPath=undef 
      if $scanPath eq "null";
      
   if(defined $scanPath){
      if(defined $stagingPath){
         if(stringEqual( $scanPath, $stagingPath) ){
            return 0;
         }else{
            return 1;
         }
      }else{
        return 1;
      }
   }else{
      if(defined $stagingPath){
         return 1;
      }else{
         return 0;
      }
   }
}

sub applyDelta {
    my ( $self, $connection ) = @_;

    dlog('Start applyDelta method');

    die('Cannot call method directly') if ( !$self->flag );

    ###TODO Need to discuss how to handle
    if ( $self->SUPER::applyChanges == 0 ) {
        dlog('Skipping apply per argument');
        return;
    }

    if ( !defined $self->list ) {
        wlog('scanlist is not defined');
        return;
    }

    if ( scalar keys %{ $self->list } == 0 ) {
        wlog('scanlist is zero');
        return;
    }

    foreach my $key ( keys %{ $self->list } ) {
        dlog("Applying softwareId=$key");

        foreach my $sigId ( keys %{ $self->list->{$key} } ) {
            dlog("Applying sig=$sigId");

            foreach my $srId ( keys %{ $self->list->{$key}->{$sigId} } ) {
                dlog("Applying sr=$srId");

                my $action = $self->list->{$key}->{$sigId}->{$srId}->{'action'};
                my $id     = $self->list->{$key}->{$sigId}->{$srId}->{'id'};
                my $path   = $self->list->{$key}->{$sigId}->{$srId}->{'path'};

                dlog("Applying id=$id");
                my $ss = new Staging::OM::SoftwareSignature();
                $ss->id($id);
                $ss->scanRecordId($srId);
                $ss->softwareSignatureId($sigId);
                $ss->softwareId($key);
                $ss->path($path);
                $ss->action($action);

                $ss->id(undef)
                    if $ss->id == 0;

                $ss->path(undef)
                    if $ss->path eq 'null';

                dlog( $ss->toString );

                $ss->save($connection);
                $self->addToCount( 'STAGING', 'SIGNATURE', 'STATUS_' . $ss->action );
            }
        }
    }

    dlog('End applyDelta method');
}

sub addToCount {
    my ( $self, $db, $object, $action ) = @_;
    my $hash;
    if ( defined $self->count ) {
        $hash = $self->count;
        $hash->{$db}->{$object}->{$action}++;
    }
    else {
      $hash->{$db}->{$object}->{$action} = 1;
    }
    $self->count($hash);
}

sub count {
    my ( $self, $value ) = @_;
    $self->{_count} = $value if defined($value);
    return ( $self->{_count} );
}

sub applyFile {
    my ($self) = @_;

    dlog('Start applyDelta method');

    die('Cannot call method directly') if ( !$self->flag );

    ###TODO Need to discuss how to handle
    if ( $self->SUPER::applyChanges == 0 ) {
        dlog('Skipping apply per argument');
        return;
    }

    my $file = $self->SUPER::bankAccountName . '_signature.tsv';

    open( FILE, "> /db2/staging/temporaryExport/$file" )
        or die "Can't open $file: $!";

    foreach my $key ( keys %{ $self->list } ) {
        dlog("Applying key=$key");

        $self->list->{$key}->action('UPDATE')
            if ( !defined $self->list->{$key}->action );

        if ( $self->list->{$key}->action eq 'COMPLETE' ) {
            dlog("Skipping this as is complete");
            next;
        }

        if ( $self->list->{$key}->action eq 'DELETE' ) {
            dlog("Skipping this as is complete");
            next;
        }

        print FILE "\t"
            . $self->list->{$key}->scanRecordId . "\t"
            . $self->list->{$key}->softwareSignatureId . "\t"
            . $self->list->{$key}->softwareId . "\t"
            . $self->list->{$key}->action . "\n";

    }

    close FILE;

    dlog('End applyDelta method');
}

sub list {
    my ( $self, $value ) = @_;
    $self->{_list} = $value if defined($value);
    return ( $self->{_list} );
}
1;

