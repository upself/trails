package Staging::SoftwareSignatureLoader;

use strict;
use Base::Utils;
use Staging::Loader;
use Staging::OM::SoftwareSignature;
use Scan::Delegate::ScanDelegate;
use Staging::Delegate::StagingDelegate;
use Scan::Delegate::SoftwareSignatureDelegate;
use Staging::Delegate::TempSignatureTable;

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
        if($self->SUPER::bankAccount->connectionType eq 'CONNECTED'){
            $self->doDelta($stagingConnection);
        }else{
            $self->doDeltaWithTempTable($stagingConnection);
        }
        ilog('Delta complete');

        ###Check if we have crossed the delete threshold
        if ( $self->SUPER::checkDeleteThreshold() ) {
            $dieMsg = '**** We are deleting more than 15% of total records - Aborting ****';
        }
        else {
            ilog('Applying deltas');
            if($self->SUPER::bankAccount->connectionType eq 'CONNECTED'){
               $self->applyDelta($stagingConnection);
            }else{
               $self->applyDeltaWithTempTable($stagingConnection);
            }
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
     my $list;
     my $combination;
     my $tempStagingTableConnection;
     ($list,$combination,$tempStagingTableConnection) = 
                     SoftwareSignatureDelegate->getSoftwareSignatureData($connection, $self->SUPER::bankAccount, $self->loadDeltaOnly);
      $self->list($list);
      $self->scanSwActionCombination($combination);
      $self->tempStagingTableConnection($tempStagingTableConnection);
    };
    
    if ($@) {
        wlog($@);
        die $@;
    }

    dlog('End prepareSourceData method');
}


sub doDeltaWithTempTable{
 
    my ( $self, $connection ) = @_;

    dlog('Start doDelta method');

    die('Cannot call method directly') if ( $self->SUPER::flag == 0 );

    my $check  = $self->checkTempTable($self->tempStagingTableConnection);
    if($check <=0){
        wlog('temp table content is zero');
        return;
    }
    dlog('temp table qty is '.$check);
    $self->removeActionDelete($connection);
    
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
     
        if($rec{action} eq 'DELETE' || $rec{scanRecordAction} eq 'DELETE' ) {
            next;
        }

        $self->SUPER::incrTotalCnt();

        

                ###check if scan record exists
                if (SoftwareSignatureDelegate->isSignatureExists($self->tempStagingTableConnection,$self->SUPER::bankAccount, 
                                              $rec{softwareId},$rec{softwareSignatureId},$rec{scanRecordId} ))
                {
                    dlog( $rec{scanRecordId} . " scanRecordId exists in source" );
                    
                    my $tempTableObj = new Staging::Delegate::TempSignatureTable;
                    $tempTableObj->softwareId($rec{softwareId});
                    $tempTableObj->softwareSignatureId($rec{softwareSignatureId});
                    $tempTableObj->scanRecordId($rec{scanRecordId} );
                    $tempTableObj->bankAccount($self->SUPER::bankAccount);
                    
                    dlog('bank account name is:'.$tempTableObj->bankAccount->name);
                    
                    $tempTableObj->getByBizKey($self->tempStagingTableConnection);
                    
                    $tempTableObj->id($rec{id});
                    $tempTableObj->update($self->tempStagingTableConnection);                    

                    #Get all the keys even though there should only be one
                    my $path =  $tempTableObj->path;
                    my $scanAction= $tempTableObj->action;
                    
                    my $bankAccountType = $self->SUPER::bankAccount->type;
                    if($bankAccountType eq 'TLM' || $bankAccountType eq 'TAD4D')
                    {
                      if( stringEqual( $rec{action}, $scanAction)||($rec{action} eq 'UPDATE' && $scanAction eq 'COMPLETE')){
                         $tempTableObj->delete($self->tempStagingTableConnection);
                      }
                    }else{
                       if($self->pathChanged($path, $rec{path})){
                          if( $rec{action} eq 'COMPLETE' && $self->SUPER::bankAccountName ne 'S03INV40'){
                              dlog("Setting record to update since path has changed");
                              $tempTableObj->action('UPDATE');
                              $tempTableObj->update($self->tempStagingTableConnection); 
                          }else{
                              $tempTableObj->delete($self->tempStagingTableConnection);
                          }
                       }else{
                              $tempTableObj->delete($self->tempStagingTableConnection);
                       }
                    }
                }
                else {
                    dlog( $rec{scanRecordId} . " scanRecordId does not exist in source" );

                    if ( $rec{action} eq 'COMPLETE' ) {
                        dlog("Setting record to delete");
                        
                        my $tempTableObj = new Staging::Delegate::TempSignatureTable;
                        $tempTableObj->bankAccount($self->SUPER::bankAccount);
                         
                        $tempTableObj->softwareId($rec{softwareId});
                        $tempTableObj->softwareSignatureId($rec{softwareSignatureId});
                        $tempTableObj->scanRecordId($rec{scanRecordId} );
                        
                        $tempTableObj->path($rec{path});
                        $tempTableObj->id($rec{id});
                        $tempTableObj->action('DELETE');
                         
                        $tempTableObj->save($self->tempStagingTableConnection);                       
                          
                        $self->SUPER::incrDeleteCnt();
                        ###randomly pick one signature under this scanRecordId and softwareId and set to UPDATE.
                        $self->setToUpdate($rec{scanRecordId},$rec{softwareId},$rec{softwareSignatureId});
                            
                    }
                }
    }  ###end of while.
            
}

sub insertNotInSourceToTempTable{
 
 my ($self,$connection,$bankAccount)=@_;
 
 my $query = '
insert into SESSION.TEMP_SIGNATURE_'.$bankAccount->name.'(SOFTWARE_ID,SOFTWARE_SIGNATURE_ID,SCAN_RECORD_ID,ACTION,PATH,ID)
  select 
  ss.software_id, 
  ss.software_signature_id, 
  sr.id,
  \'DELETE\',
  ss.path,
  ss.id 
from scan_record sr, software_signature ss 
where 
 sr.id  = ss.scan_record_id and 
 sr.bank_account_id = '.$bankAccount->id.' and 
 not exists(
  select 1 from SESSION.TEMP_SIGNATURE_'.$bankAccount->name.' temp 
  where temp.software_signature_id = ss.software_signature_id and 
  temp.software_id = ss.software_id and 
  temp.scan_record_id  = sr.id
 )';   


  dlog('query='.$query);
  $connection->prepareSqlQuery('insertNIS',$query);
  my $sth = $connection->sql->{insertNIS};
  $sth->execute(); 
  
}

sub checkTempTable{
 
 dlog('in isSignatureExists method');
 my ($self,$connection)=@_;
 
 my $query = 'select count(*) from SESSION.TEMP_SIGNATURE_'.$self->SUPER::bankAccount->name;

  dlog('query='.$query);
  $connection->prepareSqlQuery('tempCount',$query);
  my @fields = (qw(qty));
  my $sth = $connection->sql->{tempCount};
  my %rec;
     $sth->bind_columns( map { \$rec{$_} } @fields );
  $sth->execute(); 
  $sth->fetchrow_arrayref;
  
  dlog('end isSignatureExists method');
  
  return $rec{qty};  
}


sub removeActionDelete{
 dlog('start removeActionDelete');
 my ($self,$connection)=@_; 
 my $query = 'select
        software_signature_id, 
        scan_record_id, 
        software_id 
      from scan_record sr, software_signature ss
      where 
        sr.id  = ss.scan_record_id 
        and (ss.action  = \'DELETE\' or sr.action = \'DELETE\') 
        and sr.bank_account_id  = ?';
      
  dlog('query='.$query);
  $connection->prepareSqlQuery('queryDelete',$query);
  my @fields = (qw(softwareSignatureId scanRecordId softwareId));
  my $sth = $connection->sql->{queryDelete};
  my %rec;
  $sth->bind_columns( map { \$rec{$_} } @fields );
  $sth->execute($self->SUPER::bankAccount->id); 
  while ( $sth->fetchrow_arrayref ) {
      SoftwareSignatureDelegate->deleteSignatureTemp($self->tempStagingTableConnection, $self->SUPER::bankAccount, 
                                                       $rec{softwareId}, $rec{softwareSignatureId},$rec{scanRecordId});
      dlog("deleted from temp table softwareSignatureId=$rec{softwareSignatureId}, softwareId=$rec{softwareId}, scanRecordId=$rec{scanRecordId}");                                                       
  }
  
  dlog('end removeActionDelete');
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
                      if( stringEqual( $rec{action}, $scanAction)||($rec{action} eq 'UPDATE' && $scanAction eq 'COMPLETE')){
                         delete $signatureList->{ $rec{softwareId} }->{ $rec{softwareSignatureId} }->{ $rec{scanRecordId} };
                      }
                    }else{
                       if($self->pathChanged($path, $rec{path})){
                          if( $rec{action} eq 'COMPLETE' && $self->SUPER::bankAccountName ne 'S03INV40'){
                              dlog("Setting record to update since path has changed");
                              $self->list->{ $rec{softwareId} }->{$rec{softwareSignatureId}}->{ $rec{scanRecordId} }->{'action'} = 'UPDATE';
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
                        
                        ###randomly pick one signature under this scanRecordId and softwareId and set to UPDATE.
                        $self->setToUpdate($rec{scanRecordId},$rec{softwareId},$rec{softwareSignatureId});
                            
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
                    
                    $self->setToUpdate($rec{scanRecordId},$rec{softwareId},$rec{softwareSignatureId});
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
                
                $self->setToUpdate($rec{scanRecordId},$rec{softwareId},$rec{softwareSignatureId});
            }
        }
    }
    $sth->finish;

    $self->list($signatureList);
}


sub setToUpdate{
 my ($self,$srId,$swId,$swSignatureId) = @_;
 
 my $key = $srId.'|'.$swId;
 
 return  
   if(!defined $self->scanSwActionCombination);
 return 
     if($self->scanSwActionCombination->{$key.'|UPDATE'});
 return 
     if(!$self->scanSwActionCombination->{$key.'|COMPLETE'});
 
 my $sql = '
     select 
     ss.id,
     ss.software_signature_id,
     ss.path 
   from 
     software_signature ss 
   where 
     ss.scan_record_id  = ?
     and ss.software_id  = ?
     and ss.software_signature_id <> ?
   with ur';
   
   
 my $connection = Database::Connection->new('staging');    
 $connection->prepareSqlQuery('getSignatureId',$sql);

 ###Define our fields
 my @fields = (qw(id softwareSignatureId path));
 ###Get the statement handle
 my $sth = $connection->sql->{getSignatureId};

 ###Bind our columns
 my %rec;
 $sth->bind_columns( map { \$rec{$_} } @fields );

 ###Excute the query
 $sth->execute($srId,$swId,$swSignatureId);
 my $found = $sth->fetchrow_arrayref;
 if(defined $found){
  $self->list->{$swId}->{$rec{softwareSignatureId}}->{$srId}->{'action'}='UPDATE';
  $self->list->{$swId}->{$rec{softwareSignatureId}}->{$srId}->{'id'}=$rec{id};
  $self->list->{$swId}->{$rec{softwareSignatureId}}->{$srId}->{'path'}=$rec{path};
  $self->scanSwActionCombination->{$key.'|UPDATE'}=1;
 }
 $connection->disconnect
            if ( defined $connection );
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

sub applyDeltaWithTempTable {
    my ( $self, $connection ) = @_;

    dlog('Start applyDelta method');

    die('Cannot call method directly') if ( !$self->flag );

    ###TODO Need to discuss how to handle
    if ( $self->SUPER::applyChanges == 0 ) {
        dlog('Skipping apply per argument');
        return;
    }

    my $check  = $self->checkTempTable($self->tempStagingTableConnection);
    if($check <=0){
        wlog('temp table content is zero');
        return;
    }
    dlog('temp table qty is '.$check);
    
    ###Get a cndb connection
    my $tempTableConnection = $self->tempStagingTableConnection;

    my $query = 'select 
    software_id, 
    software_signature_id, 
    scan_record_id, 
    action, 
    id, 
    path
    from SESSION.TEMP_SIGNATURE_'.$self->SUPER::bankAccount->name;

    dlog('query='.$query);
    $tempTableConnection->prepareSqlQuery('loopTemp',$query);
    my @fields = (qw(softwareId softwareSignatureId scanRecordId action id path));
    my $sth = $tempTableConnection->sql->{loopTemp};
    my %rec;
    $sth->bind_columns( map { \$rec{$_} } @fields );
    $sth->execute();
    while( $sth->fetchrow_arrayref ) {
      
         dlog("Applying id=$rec{id}");
         my $ss = new Staging::OM::SoftwareSignature();
         $ss->id($rec{id});
         $ss->scanRecordId($rec{scanRecordId});
         $ss->softwareSignatureId($rec{softwareSignatureId});
         $ss->softwareId($rec{softwareId});
         $ss->path($rec{path});
         $ss->action($rec{action});
         
         
         $ss->id(undef) if $ss->id == 0;
         $ss->path(undef) if $ss->path eq 'null';

         dlog( $ss->toString );
         $ss->save($connection);
         $self->SUPER::incrUpdateCnt() if($ss->action eq 'UPDATE');
         $self->addToCount( 'STAGING', 'SIGNATURE', 'STATUS_' . $ss->action );
    }
    
    $sth->finish;
    $tempTableConnection->disconnect;

    dlog('End applyDelta method');
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
                $self->SUPER::incrUpdateCnt() 
                        if($ss->action eq 'UPDATE');
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

sub scanSwActionCombination {
    my ( $self, $value ) = @_;
    $self->{_scanSwActionCombination} = $value if defined($value);
    return ( $self->{_scanSwActionCombination} );
}

sub tempStagingTableConnection {
    my ( $self, $value ) = @_;
    $self->{_tempStagingTableConnection} = $value if defined($value);
    return ( $self->{_tempStagingTableConnection} );
}
1;

