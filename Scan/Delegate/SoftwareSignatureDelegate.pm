package SoftwareSignatureDelegate;

use strict;
use Base::Utils;
use Compress::Zlib;
use Database::Connection;
use Sigbank::Delegate::SoftwareSignatureDelegate;
use Staging::Delegate::ScanRecordDelegate;
use Text::CSV_XS;

sub getSoftwareSignatureData {
    my ( $self, $connection, $bankAccount, $delta ) = @_;

    dlog('In the getSoftwareSignatureData method');

    return if $bankAccount->type eq 'TLCMZ';
    return if $bankAccount->type eq 'SW_DISCREPANCY';

    if ( $bankAccount->connectionType eq 'CONNECTED' ) {
        dlog( $bankAccount->name );
        ###Get computer id map
        my $scanMap = ScanRecordDelegate->getScanRecordMap($bankAccount);

        ###Get the filter map
        my $softwareSignatureMap
            = SoftwareSignatureDelegate->getSoftwareSignatureMap;
        return $self->getConnectedSoftwareSignatureData( $connection,
            $bankAccount, $delta, $scanMap, $softwareSignatureMap );
    }
    elsif ( $bankAccount->connectionType eq 'DISCONNECTED' ) {
        ###Get computer id map
        my $scanMap = ScanRecordDelegate->getScanRecordMap($bankAccount);

        ###Get the filter map
        my $softwareSignatureMap
            = SoftwareSignatureDelegate->getSoftwareSignatureMap;
        return $self->getDisconnectedSoftwareSignatureData( $bankAccount,
            $delta, $scanMap, $softwareSignatureMap );
    }

    die('This is neither a connected or disconnected bank account');
}

sub getDisconnectedSoftwareSignatureData {
    my ( $self, $bankAccount, $delta, $scanMap, $softwareSignatureMap ) = @_;

    dlog('in the getDisconnectedSoftwareSignatureData method');

    my $filePart = 'software_signature';
    dlog($filePart);

    dlog('Determining the file to process');
    my $fileToProcess
        = ScanDelegate->getDisconnectedFile( $bankAccount, $delta,
        $filePart );

    my %signatureList;
    my $scanSoftwareActionCombination = undef;
    
    my $tempStagingTableConnection = Database::Connection->new('staging');  
    $self->createTempTable($tempStagingTableConnection, $bankAccount);

    if ($fileToProcess) {

        dlog("processing $fileToProcess");

        dlog('Creating tsv object');
        my $tsv = Text::CSV_XS->new(
            { sep_char => "\t", binary => 1, eol => $/ } );
        dlog('tsv object created');

        dlog('opening gzipped file');
        my $gz = gzopen( "$fileToProcess", "rb" )
            or die "Cannot open $fileToProcess: $gzerrno\n";
        dlog('gzipped file open');

        my $line;
        dlog('looping through gzip lines');
        my @fields
            = (qw (computerId swareSigId fileName fileSize acqTime path));
            
        $scanSoftwareActionCombination = $self->initScanSoftwareActionCombination($bankAccount)
          if( $bankAccount->type eq 'TAD4D' || $bankAccount->type eq 'TLM' );
          
            
        while ( $gz->gzreadline($line) > 0 ) {
            my $status = $tsv->parse($line);

            my $index = 0;
            my %rec   = map { $fields[ $index++ ] => $_ } $tsv->fields();
            
            cleanValues( \%rec );
            upperValues( \%rec );

            ###We don't care about records that are not in our scan records
            next if ( !exists $scanMap->{ $rec{computerId} } );

            ###We don't care if the software name does not exist
            #### We really need to check the logic here as to whether or not it is really
            ###  acceptable to not uppercase or lower case these things
            next if ( !exists $softwareSignatureMap->{ $rec{fileName} } );
            next
                if ( !exists $softwareSignatureMap->{ $rec{fileName} }
                ->{ $rec{fileSize} } );

            my $softwareSignatureId
                = $softwareSignatureMap->{ $rec{fileName} }
                ->{ $rec{fileSize} }->{'softwareSignatureId'};
            my $softwareId = $softwareSignatureMap->{ $rec{fileName} }
                ->{ $rec{fileSize} }->{'softwareId'};

            ###Add the software signature to the list
            if ( !defined $rec{path} || $rec{path} eq '' ) {
                $rec{path} = "null";
            }
            
            if(!$self->isSignatureExists($tempStagingTableConnection,$bankAccount, $softwareId,$softwareSignatureId,$scanMap->{ $rec{computerId} })){
               my $action = 'UPDATE';
                if( $bankAccount->type eq 'TAD4D' || $bankAccount->type eq 'TLM' ){
                   my $key =  $scanMap->{ $rec{computerId} } .'|'.$softwareId;
                   if($scanSoftwareActionCombination->{$key.'|UPDATE'}||
                          (!$scanSoftwareActionCombination->{$key.'|UPDATE'} && $scanSoftwareActionCombination->{$key.'|COMPLETE'})
                   ){
                      $action= 'COMPLETE';
                      dlog('processed srId='.$scanMap->{ $rec{computerId} }.'swId='.$softwareId);
                   }else{
                      $scanSoftwareActionCombination->{$key.'|UPDATE'} = 1;
                      dlog('new srId='.$scanMap->{ $rec{computerId} }.'swId='.$softwareId);
                  }
                }
                
                dlog('before insert into temp table');                
                $self->insertIntoSignatureTemp($tempStagingTableConnection, $bankAccount,
                                               $softwareId, 
                                               $softwareSignatureId,
                                               $scanMap->{ $rec{computerId} }, 
                                               $action,
                                               $rec{path},
                                               0);
               dlog('after insert into temp table');
            }
            

            
        }
        die "Error reading from $fileToProcess: $gzerrno"
            . ( $gzerrno + 0 ) . "\n"
            if $gzerrno != Z_STREAM_END;
        $gz->gzclose();
    }
    else {
        dlog("no $filePart to process");
    }

    return (\%signatureList, $scanSoftwareActionCombination,$tempStagingTableConnection);
}

sub createTempTable{
 
 my ($self,$connection,$bankAccount)=@_;
 
 
 my $query = '
  DECLARE GLOBAL TEMPORARY TABLE SESSION.TEMP_SIGNATURE_'.$bankAccount->name.'
  (SOFTWARE_ID BIGINT  NOT NULL,
   SOFTWARE_SIGNATURE_ID BIGINT NOT NULL,
   SCAN_RECORD_ID BIGINT NOT NULL,
   ACTION VARCHAR(32),
   PATH VARCHAR(255),
   ID BIGINT)
   ON COMMIT PRESERVE ROWS
   NOT LOGGED ON ROLLBACK DELETE ROWS';

  dlog('query='.$query);
  $connection->prepareSqlQuery('createTempTable',$query);
  my $sth = $connection->sql->{createTempTable};
  $sth->execute(); 
  
}


sub isSignatureExists{
 dlog('in isSignatureExists method');
 my ($self,$connection, $bankAccount, $softwareId,$softwareSignatureId,$scanRecordId)=@_;
 
 my $query = '
 select count(*) from SESSION.TEMP_SIGNATURE_'.$bankAccount->name.'
 where software_id = ?
 and software_signature_id =?
 and scan_record_id = ? ';

  dlog('query='.$query);
  $connection->prepareSqlQuery('isSigExists',$query);
  my @fields = (qw(qty));
  my $sth = $connection->sql->{isSigExists};
  my %rec;
     $sth->bind_columns( map { \$rec{$_} } @fields );
  $sth->execute($softwareId,$softwareSignatureId,$scanRecordId); 
  $sth->fetchrow_arrayref;
  
  dlog('end isSignatureExists method');
  
  if($rec{qty}>0){
   return 1;
  }
  
  return 0;
}


sub insertIntoSignatureTemp{
 
 my ($self,$connection,$bankAccount, $softwareId,$softwareSignatureId,$scanRecordId, $action, $path, $id)=@_;
 
 my $query = '
 insert into SESSION.TEMP_SIGNATURE_'.$bankAccount->name.' (software_id, software_signature_id, scan_record_id, action, path, id)
 values(?,?,?,?,?,?)';

  dlog('query='.$query);
  $connection->prepareSqlQuery('insertSigTemp',$query);
  my $sth = $connection->sql->{insertSigTemp};
  $sth->execute($softwareId,$softwareSignatureId,$scanRecordId, $action, $path, $id); 
  
}

sub deleteSignatureTemp{
 
 my ($self,$connection,$bankAccount, $softwareId,$softwareSignatureId,$scanRecordId)=@_;
 
 my $query = '
 delete from SESSION.TEMP_SIGNATURE_'.$bankAccount->name.' where software_id=? and software_signature_id=? and scan_record_id=?';

  dlog('query='.$query);
  $connection->prepareSqlQuery('deleteTemp',$query);
  my $sth = $connection->sql->{deleteTemp};
  $sth->execute($softwareId,$softwareSignatureId,$scanRecordId); 
  
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


sub initScanSoftwareActionCombination{
    my ( $self, $bankAccount) = @_;
    my $connection = Database::Connection->new('staging');
    my  %existsSignatures = ();
    
    my $query = '
select 
  sr.id, 
  ss.software_id,
  ss.action
from 
   scan_record sr, 
   software_signature ss 
where 
   sr.id = ss.scan_record_id 
   and sr.bank_account_id = ?
group by 
    sr.id,
	ss.software_id,
	ss.action
order by 
    sr.id,
	ss.software_id,
	ss.action
with ur';

     dlog('query='.$query);
    
    
     $connection->prepareSqlQuery('queryUpdateScanRecordSoftwareIds',$query);
     my @fields = (qw(scanRecordId softwareId action));
     my $sth = $connection->sql->{queryUpdateScanRecordSoftwareIds};
     my %rec;
     $sth->bind_columns( map { \$rec{$_} } @fields );
     $sth->execute($bankAccount->id);
     while ( $sth->fetchrow_arrayref ) {
         my $key =   $rec{scanRecordId}.'|'.$rec{softwareId}.'|'.$rec{action};
         $existsSignatures{$key}=1;
     }
     
     return \%existsSignatures;
}

sub getConnectedSoftwareSignatureData {
    my ( $self, $connection, $bankAccount, $delta, $scanMap,
        $softwareSignatureMap )
        = @_;

    ###No delta processing

    my %signatureList = ();
    my $sth;

    ###Prepare the query
    ###The query here depends on the tcm environment 4.2.3.2
    if ( $bankAccount->version eq '4.2.3.2' ) {
        eval {
            if ( $bankAccount->name ne 'S03INV40' )
            {
                $connection->prepareSqlQuery(
                    $self->querySoftwareSignature4232DataWithPath );
                $sth = $connection->sql->{softwareSignatureData};
            }
            else {
                $connection->prepareSqlQuery(
                    $self->querySoftwareSignature4232Data );
                $sth
                    = $connection->sql->{softwareSignatureData};
            }
        };
        if ($@) {
            $connection->prepareSqlQuery(
                $self->querySoftwareSignature4232Data );
            $sth = $connection->sql->{softwareSignatureData};
        }
    }
    else {
        $connection->prepareSqlQuery( $self->querySoftwareSignatureData );
        $sth = $connection->sql->{softwareSignatureData};
    }

    ###Define the fields
    my @fields = (qw(computerId fileName fileSize path));

    ###Bind the columns
    my %rec;
    $sth->bind_columns( map { \$rec{$_} } @fields );

    ###Execute the query
    $sth->execute();
    
    
    my %existsSignatures=();

    while ( $sth->fetchrow_arrayref ) {

        cleanValues( \%rec );
        upperValues( \%rec );

        ###We don't care about records that are not in our scan records
        next if ( !exists $scanMap->{ $rec{computerId} } );

        ###We don't care if the software name does not exist
        #### We really need to check the logic here as to whether or not it is really
        ###  acceptable to not uppercase or lower case these things
        next if ( !exists $softwareSignatureMap->{ $rec{fileName} } );
        next
            if ( !exists $softwareSignatureMap->{ $rec{fileName} }
            ->{ $rec{fileSize} } );

        my $softwareSignatureId
            = $softwareSignatureMap->{ $rec{fileName} }->{ $rec{fileSize} }
            ->{'softwareSignatureId'};
        my $softwareId
            = $softwareSignatureMap->{ $rec{fileName} }->{ $rec{fileSize} }
            ->{'softwareId'};

        if ( !defined $rec{path} || $rec{path} eq '' ) {
            $rec{path} = "null";
        }

        ###Add the hardware to the list

       if ( !exists $signatureList{$softwareId}{$softwareSignatureId}
            { $scanMap->{ $rec{computerId} } } )
        {
            my $action = 'UPDATE';
            if( $bankAccount->type eq 'TAD4D' || $bankAccount->type eq 'TLM' ){
             
               my $key =  $scanMap->{ $rec{computerId} } .'|'.$softwareId;
               if($existsSignatures{$key}){
                  $action= 'COMPLETE';                  
                  dlog('processed srId='.$scanMap->{ $rec{computerId} }.'swId='.$softwareId);
                  
               }else{
                 $existsSignatures{$key} = 1;
                 dlog('new srId='.$scanMap->{ $rec{computerId} }.'swId='.$softwareId);
               }
            }
            
            $signatureList{$softwareId}{$softwareSignatureId}
                  { $scanMap->{ $rec{computerId} } }{'action'} = $action;
            
            $signatureList{$softwareId}{$softwareSignatureId}
                { $scanMap->{ $rec{computerId} } }{'id'} = 0;
            $signatureList{$softwareId}{$softwareSignatureId}
                { $scanMap->{ $rec{computerId} } }{'path'} = $rec{path};
        }
    }

    ###Close the statement handle
    $sth->finish;

    ###Return the lists
    return ( \%signatureList,undef, undef);
}

sub buildSoftwareSignature {
    my ( $self, $rec, $scanMap, $softwareSignatureMap ) = @_;

    cleanValues($rec);
    upperValues($rec);

    ###We don't care about records that are not in our scan records
    return undef if ( !exists $scanMap->{ $rec->{computerId} } );

    ###We don't care if the software name does not exist
    #### We really need to check the logic here as to whether or not it is really
    ###  acceptable to not uppercase or lower case these things
    return undef if ( !exists $softwareSignatureMap->{ $rec->{fileName} } );

    return undef
        if ( !exists $softwareSignatureMap->{ $rec->{fileName} }
        ->{ $rec->{fileSize} } );

    my $softwareSignatureId
        = $softwareSignatureMap->{ $rec->{fileName} }->{ $rec->{fileSize} }
        ->{'softwareSignatureId'};
    my $softwareId
        = $softwareSignatureMap->{ $rec->{fileName} }->{ $rec->{fileSize} }
        ->{'softwareId'};

    my $ss = new Staging::OM::SoftwareSignature();
    $ss->softwareSignatureId($softwareSignatureId);
    $ss->softwareId($softwareId);
    $ss->scanRecordId( $scanMap->{ $rec->{computerId} } );

    return $ss;
}

sub querySoftwareSignatureData {
    my $query = '
        select
            a.computer_sys_id
            ,b.sware_name
            ,b.sware_size
            ,\'\'
        from
            matched_sware a
            ,sware_sig b
        where
            a.sware_sig_id = b.sware_sig_id
            and b.sig_status = \'1\'
        with ur
    ';

    return ( 'softwareSignatureData', $query );
}

sub querySoftwareSignature4232Data {
    my $query = '
        select
            a.computer_sys_id
            ,b.name
            ,b.file_size
            ,\'\'
        from
            matched_sware a
            ,signature b
        where
            a.sware_sig_id = b.id
        with ur
    ';

    return ( 'softwareSignatureData', $query );
}

sub querySoftwareSignature4232DataWithPath {
    my $query = 'select
      ms.computer_sys_id,
      sig.name,
      sig.file_size,
      md.sware_sig_path
    from
      matched_sware ms 
      left outer join msware_desc md on
        ms.computer_sys_id = md.computer_sys_id 
        and md.sware_sig_id = ms.sware_sig_id
        and ms.MD5_ID = md.MD5_ID
      ,signature sig
    where
      ms.sware_sig_id=sig.ID
      and sig.enabled = 1
	';

    return ( 'softwareSignatureData', $query );
}
1;
