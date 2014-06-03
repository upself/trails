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
    eval{
     $self->dropTempTable($tempStagingTableConnection, $bankAccount);
    };
    if($@){ 
      #skip the warning if the temp table not exists.     
      die $@ if(!$@=~m/SQLSTATE=42704/);
    }
    
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
          
        my @rows;
        my $csv = Text::CSV_XS->new( { binary => 1, auto_diag => 1 } );
        $csv->eol("\r\n");
        my $tempFileName = '/tmp/tempSignature_'.$bankAccount->name.'.csv';
        open my $fh, ">:encoding(utf8)", $tempFileName or die "$tempFileName: $!";    
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
            
            undef @rows;
            push @rows,$softwareId,;
            push @rows,$softwareSignatureId;
            push @rows,$scanMap->{ $rec{computerId} };
            push @rows,'UPDATE';
            push @rows,$rec{path};
            push @rows, 0;
            
            $csv->print( $fh, \@rows );
            
        }
        close $fh or die "$tempFileName: $!";
        my $logFile= logfile;
        my $bankAccountName = $bankAccount->name;
        `/opt/staging/v2/loadTemp.sh $bankAccountName >>$logFile 2>&1`;
        
        die "Error reading from $fileToProcess: $gzerrno"
            . ( $gzerrno + 0 ) . "\n"
            if $gzerrno != Z_STREAM_END;
        $gz->gzclose();
        
        dlog('remove duplicate');
        my $queryDeleteDuplicated =  'delete from (select t.*, rownumber() over(partition by software_id, software_signature_id, scan_record_id) as rowid from TEMP_SIGNATURE_'.$bankAccount->name.' t) as t2 where t2.rowid>1';
        dlog('query='.$queryDeleteDuplicated);
        $tempStagingTableConnection->prepareSqlQuery('deleteDuplicate',$queryDeleteDuplicated);
        my $sth = $tempStagingTableConnection->sql->{deleteDuplicate};
        $sth->execute();
        dlog('end remove duplicate');        
        
        if( $bankAccount->type eq 'TAD4D' || $bankAccount->type eq 'TLM' ){
             #copy action from software_signature into temp table by mapping scan_record_id/software_id/software_signature_id. 
             #non-mapped items(new items in scan file) in temp table action will set to null. 
             my $queryCopyFromSignature = 'update TEMP_SIGNATURE_'.$bankAccount->name.'  t
                 set action =
                (select 
                   ss.action
                 from 
                   scan_record sr, 
                   software_signature ss
                 where 
                   sr.id = ss.scan_record_id 
                   and sr.id=t.scan_record_id
                   and ss.software_id=t.software_id
                   and ss.software_signature_id = t.software_signature_id)';
         
             dlog('query='.$queryCopyFromSignature);
             $tempStagingTableConnection->prepareSqlQuery('copyFromSig',$queryCopyFromSignature);
             my $sth = $tempStagingTableConnection->sql->{copyFromSig};
             eval {
                   $sth->execute(); 
             };
             if ($@) {
               #skip the warning
               #DBD::DB2::st execute failed: [IBM][CLI Driver][DB2/LINUX] SQL0513W  The SQL statement will modify an entire table or view.  SQLSTATE=01504
               die $@ if(!$@=~m/SQLSTATE=01504/);
             }
                       
             #set the first scan_record_id + software_id combination item to update, only for new items. 
             my $querySetUpdate='
              update 
               (select t.*, rownumber() over(partition by t.SCAN_RECORD_ID,t.SOFTWARE_ID order by t.software_signature_id asc) as rowid 
                from TEMP_SIGNATURE_'.$bankAccount->name.' t 
                  where 
                  t.action is null 
                  and not exists (
                         select 1 from TEMP_SIGNATURE_'.$bankAccount->name.' t2  
                         where t2.action is not null 
                           and t2.scan_record_id  = t.scan_record_id 
                           and t2.software_id = t.software_id)
               ) as trid                
               set trid.action=\'UPDATE\' 
               where trid.rowid =1';
               
             dlog('query='.$querySetUpdate);
             $tempStagingTableConnection->prepareSqlQuery('setToUpdate',$querySetUpdate);
             $sth = $tempStagingTableConnection->sql->{setToUpdate};
             $sth->execute(); 
             
             
             my $querySetToComplete='update TEMP_SIGNATURE_'.$bankAccount->name.' set action=\'COMPLETE\' where action is null';
             dlog('query='.$querySetToComplete);
             $tempStagingTableConnection->prepareSqlQuery('setToComplete',$querySetToComplete);
             $sth = $tempStagingTableConnection->sql->{setToComplete};
             $sth->execute();
               
        }
    }
    else {
        dlog("no $filePart to process");
    }    

    return (\%signatureList, $scanSoftwareActionCombination,$tempStagingTableConnection);
}

sub createTempTable{
 
 my ($self,$connection,$bankAccount)=@_;
 
 
 my $query = '
  CREATE TABLE TEMP_SIGNATURE_'.$bankAccount->name.'
  (SOFTWARE_ID BIGINT  NOT NULL,
   SOFTWARE_SIGNATURE_ID BIGINT NOT NULL,
   SCAN_RECORD_ID BIGINT NOT NULL,
   ACTION VARCHAR(32),
   PATH VARCHAR(255),
   ID BIGINT) NOT LOGGED INITIALLY';

  dlog('query='.$query);
  $connection->prepareSqlQuery('createTempTable',$query);
  my $sth = $connection->sql->{createTempTable};
  $sth->execute(); 
  
}


sub dropTempTable{
 
 my ($self,$connection,$bankAccount)=@_;
 
 
 my $query = 'drop table TEMP_SIGNATURE_'.$bankAccount->name;

  dlog('query='.$query);
  $connection->prepareSqlQuery('dropTempTable',$query);
  my $sth = $connection->sql->{dropTempTable};
  $sth->execute(); 
  
}


sub isSignatureExists{
 dlog('in isSignatureExists method');
 my ($self,$connection, $bankAccount, $softwareId,$softwareSignatureId,$scanRecordId)=@_;
 
 my $query = '
 select count(*) from TEMP_SIGNATURE_'.$bankAccount->name.'
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
 insert into TEMP_SIGNATURE_'.$bankAccount->name.' (software_id, software_signature_id, scan_record_id, action, path, id)
 values(?,?,?,?,?,?)';

  dlog('query='.$query);
  $connection->prepareSqlQuery('insertSigTemp',$query);
  my $sth = $connection->sql->{insertSigTemp};
  $sth->execute($softwareId,$softwareSignatureId,$scanRecordId, $action, $path, $id); 
  
}

sub deleteSignatureTemp{
 
 my ($self,$connection,$bankAccount, $softwareId,$softwareSignatureId,$scanRecordId)=@_;
 
 my $query = '
 delete from TEMP_SIGNATURE_'.$bankAccount->name.' where software_id=? and software_signature_id=? and scan_record_id=?';

  dlog('query='.$query);
  $connection->prepareSqlQuery('deleteTemp',$query);
  my $sth = $connection->sql->{deleteTemp};
  $sth->execute($softwareId,$softwareSignatureId,$scanRecordId); 
  
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
