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
    #set the limt.
    $self->limit(100000);
    my $qty = $self->getStagingSignatureQty($connection,  $self->SUPER::bankAccount->id );
    
    if($qty > $self->limit){
      my $idSegments = $self->getStagingSignatureIds($connection,  $self->SUPER::bankAccount->id );
      my @segments = @{$idSegments};
      
      for(my $i = 0;$i<scalar @segments;$i++){
          if($i <= 0){
              dlog('execute less than');
              dlog("segment, end=$segments[$i]");
              $self->compare($connection, undef,$segments[$i]);
          }else{
              dlog('execute between');
              dlog("segment,start=$segments[$i-1], end=$segments[$i]");
              $self->compare($connection, $segments[$i-1],$segments[$i]);
          }
      }
    }else{
      $self->compare($connection, undef,undef);
    }
}


sub compare{
     my ( $self, $connection, $start, $end ) = @_;
     
     my $signatureList = $self->list;

    ###Loop through the staging query
    ###Prepare the necessary sql
    
    $connection->prepareSqlQuery(Staging::Delegate::StagingDelegate->querySoftwareSignatureData() )
                                                                   if(!defined $start && !defined $end);
    $connection->prepareSqlQuery(Staging::Delegate::StagingDelegate->querySoftwareSignatureDataLessThan() )
                                                                   if(!defined $start && defined $end);
    $connection->prepareSqlQuery(Staging::Delegate::StagingDelegate->querySoftwareSignatureDataBetween() )
                                                                   if(defined $start && defined $end);
    ###Define our fields
    my @fields = (qw(id softwareSignatureId softwareId action path scanRecordId scanRecordAction));

    ###Get the statement handle
    my $sth = $connection->sql->{softwareSignatureData};

    ###Bind our columns
    my %rec;
    $sth->bind_columns( map { \$rec{$_} } @fields );

    ###Excute the query
    $sth->execute( $self->SUPER::bankAccount->id )
                        if(!defined $start && !defined $end);
                        
    $sth->execute( $self->SUPER::bankAccount->id,$end )
                        if(!defined $start && defined $end);
                        
    $sth->execute( $self->SUPER::bankAccount->id,$start, $end )
                        if(defined $start && defined $end);
    my @tempSigArray;
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
                         dlog('delete, action same');
                         delete $signatureList->{ $rec{softwareId} }->{ $rec{softwareSignatureId} }->{ $rec{scanRecordId} };
                      }
                    }else{
                       if($self->pathChanged($path, $rec{path})){
                          if( $rec{action} eq 'COMPLETE' && $self->SUPER::bankAccountName ne 'S03INV40'){
                              dlog("Setting record to update since path has changed");
                              $self->list->{ $rec{softwareId} }->{$rec{softwareSignatureId}}->{ $rec{scanRecordId} }->{'action'} = 'UPDATE';
                              $self->SUPER::incrUpdateCnt();
                          }else{
                            dlog('delete, action is complete or S03INV40');
                            delete $signatureList->{ $rec{softwareId} }->{ $rec{softwareSignatureId} }->{ $rec{scanRecordId} };
                          }
                       }else{
                         dlog('delete, path same');
                         delete $signatureList->{ $rec{softwareId} }->{ $rec{softwareSignatureId} }->{ $rec{scanRecordId} };
                       }
                    }
                }
                else {
                    dlog( $rec{scanRecordId} . " scanRecordId does not exist in source" );
                    $self->setStagingRecordToDelete($signatureList,\%rec);                    
                }
            }
            else {
                dlog( $rec{softwareSignatureId} . " softwareSignatureId does not exist in source" );
                $self->setStagingRecordToDelete($signatureList,\%rec);                
            }
        }
        else {
            dlog( $rec{softwareId} . " softwareId does not exist in source" );
            $self->setStagingRecordToDelete($signatureList,\%rec);

        }
        
        
        my $id= $signatureList->{ $rec{softwareId} }->{ $rec{softwareSignatureId} }->{ $rec{scanRecordId} }->{'id'};

        if(defined $id){
            dlog('cache into temp size '. scalar @tempSigArray);
            my $action=$signatureList->{ $rec{softwareId} }->{ $rec{softwareSignatureId} }->{ $rec{scanRecordId} }->{'action'};
            my $path=$signatureList->{ $rec{softwareId} }->{ $rec{softwareSignatureId} }->{ $rec{scanRecordId} }->{'path'};
            
            my $ss = new Staging::OM::SoftwareSignature();
            $ss->id($id);
            $ss->scanRecordId($rec{scanRecordId});
            $ss->softwareSignatureId($rec{softwareSignatureId});
            $ss->softwareId($rec{softwareId});
            $ss->path($path);
            $ss->action($action);
        
            push @tempSigArray, $ss;
        }
        
        if(scalar @tempSigArray >= 1000){
           $self->applyTemp($signatureList,\@tempSigArray, $connection);
        }
        
    }
    $sth->finish;
    
    $self->applyTemp($signatureList,\@tempSigArray, $connection)
          if(scalar @tempSigArray >0);
}

sub getStagingSignatureQty{
    my ( $self, $connection, $bankAccountId ) = @_;
    my $query = '
      select count(*) 
       from software_signature s, scan_record sr
      where
       sr.bank_account_id  = ?
       and s.scan_record_id  = sr.id
      with ur
    ';
    $connection->prepareSqlQuery('getStagingSignatureQty',$query);
    my $sth = $connection->sql->{getStagingSignatureQty};
    my $qty;
    $sth->bind_columns(\$qty);
    $sth->execute($bankAccountId);
    my $found = $sth->fetchrow_arrayref;
    $sth->finish;
    
    return $qty;
}


sub getStagingSignatureIds{
 
   dlog('start build the segment array');
   my ( $self, $connection, $bankAccountId ) = @_;
   my $query = '
      select s.id
       from software_signature s, scan_record sr
      where
       sr.bank_account_id  = ?
       and s.scan_record_id  = sr.id
	  order 
	   by s.id asc
      with ur
   ';
   
   dlog('query='.$query);
     
    my @idArray=();
   
    $connection->prepareSqlQuery('getStagingSignatureIds',$query);
    my $sth = $connection->sql->{getStagingSignatureIds};
    my $sigId;
    $sth->bind_columns(\$sigId);
    $sth->execute($bankAccountId);
    my $counter = 0;
    
    my $lastId;
    my $lastIdInArray;
    my $limit = $self->limit;
    
    while( $sth->fetchrow_arrayref )
    {
      $counter++;
      if($counter >= $limit){
         dlog("add signature into array, $sigId");
         push @idArray, $sigId;
         $counter = 0;
         $lastIdInArray = $sigId;
      }
      $lastId = $sigId;
      dlog("counter=$counter, limit=$limit, signatureId=$sigId");
    }
    $sth->finish;
    
    if($lastId ne $lastIdInArray){
      push @idArray, $lastId;
    }
    
    dlog('end build the segment array. '.scalar @idArray);
    return \@idArray;
}

sub applyTemp{
    my ($self,$signatureList, $signatures, $connection) = @_;
    
    dlog("start temp applying");    
    foreach my $item (@{$signatures}){
      $item->save($connection);
      delete $signatureList->{$item->softwareId}->{$item->softwareSignatureId}->{$item->scanRecordId};
      $self->addToCount( 'STAGING', 'SIGNATURE', 'TEMP_' . $item->action );
    }
    
    @{$signatures} = ();
    dlog("end temp applying");
    dlog('applied DELETE='.$self->count->{STAGING}->{SIGNATURE}->{TEMP_DELETE}.' ,UPDATE='.$self->count->{STAGING}->{SIGNATURE}->{TEMP_UPDATE});
}


sub setStagingRecordToDelete{
    my ($self, $signatureList, $rs) = @_;
    
    my %rec = %{$rs};
    
    if ( $rec{action} eq 'COMPLETE' ) {
      dlog("Setting record to delete");
      $signatureList->{ $rec{softwareId} }->{ $rec{softwareSignatureId} }->{ $rec{scanRecordId} }->{'action'} = 'DELETE';
      $signatureList->{ $rec{softwareId} }->{ $rec{softwareSignatureId} }->{ $rec{scanRecordId} }->{'id'} = $rec{id};
      $signatureList->{ $rec{softwareId} }->{ $rec{softwareSignatureId} }->{ $rec{scanRecordId} }->{'path'} = $rec{path};
      $self->SUPER::incrDeleteCnt();
    }
 
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
                
                 
                if (!defined $action){
                    elog("action is null softwareId=$key, softwareSigantureId=$sigId, scanRecordId=$srId");
                    next;
                }

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

sub limit {
    my ( $self, $value ) = @_;
    $self->{_limit} = $value if defined($value);
    return ( $self->{_limit} );
}


1;

