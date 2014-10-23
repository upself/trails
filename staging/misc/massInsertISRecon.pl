#!/usr/bin/perl -w
#
# IBM Confidential -- INTERNAL USE ONLY
# programmer: zhysz@cn.ibm.com
# ========================================================



$| = 1;
#use strict;
###Modules
use strict;
use Getopt::Std;
use Base::Utils;
use File::Basename;
use Database::Connection;


my $logFile = "/var/staging/logs/massInsertion/massinsertion.log";
my $timeDate      = currentTimeStamp();
my $customerId = ''; 
my $objectId;
my $action;
my $insertion;
my $queryname;
my $insername;
my $querystatement;
my $inserstatement;
my $queryreconname;
my $queryrecons;
my $objectname;
my $prenter;
my $enter;

my %recontables = () ;

$recontables{'recon_installed_sw'} = 1;
$recontables{'recon_sw_lpar'} = 2;
$recontables{'recon_hw_lpar'} = 3;
$recontables{'recon_hardware'} = 4;
$recontables{'recon_software'} = 5;
$recontables{'recon_customer_sw'} = 6;
$recontables{'recon_license'} = 7;
$recontables{'exit'} = 8;

open LOG, ">>$logFile"; 

###Get bravo db connection
my $trailsconnection = Database::Connection->new('trails');
if ( !defined($trailsconnection) ) { die"Error with db connection!\n"; }
my $seINstSwbyId = "select b.customer_id,a.id from installed_software a,software_lpar b where a.software_lpar_id=b.id and a.id in( ? )with ur";
my $seSWLparbyId = "select a.customer_id,a.id from software_lpar a where a.id in ( ? ) with ur";
my $seHWLparbyId = "select a.customer_id,a.id from hardware_lpar a where a.id in ( ? ) with ur";
my $seHWbyId =  "select a.customer_id,a.id from hardware a where a.id in ( ? ) with ur";
my $seSWbyId =  "select a.id from SOFTWARE_ITEM a where a.id in ( ? ) with ur";
my $seCSSWbyId =  "select a.customer_id,a.software_id from schedule_f a where a.id in ( ? ) with ur";
my $seLicbyId =  "select a.customer_id,a.id from license a where a.id in ( ? ) with ur";
my $isINstSwbyId = "INSERT INTO EAADMIN.recon_installed_sw ( CUSTOMER_ID,INSTALLED_SOFTWARE_ID,ID,ACTION,REMOTE_USER,RECORD_TIME) values (?, ?, DEFAULT,?,'zhysz\@cn.ibm.com',CURRENT TIMESTAMP)";
my $isSWLparbyId = "INSERT INTO EAADMIN.recon_sw_lpar(CUSTOMER_ID,SOFTWARE_LPAR_ID,ID,ACTION,REMOTE_USER,RECORD_TIME) values (?, ?, DEFAULT,?,'zhysz\@cn.ibm.com',CURRENT TIMESTAMP)";
my $isHWLparbyId = "INSERT INTO EAADMIN.recon_hw_lpar(CUSTOMER_ID,HARDWARE_LPAR_ID,ID,ACTION,REMOTE_USER,RECORD_TIME) values (?, ?, DEFAULT,?,'zhysz\@cn.ibm.com',CURRENT TIMESTAMP)";
my $isHWbyId = "INSERT INTO EAADMIN.recon_hardware(CUSTOMER_ID,HARDWARE_ID,ID,ACTION,REMOTE_USER,RECORD_TIME) values (?, ?, DEFAULT,?,'zhysz\@cn.ibm.com',CURRENT TIMESTAMP)";
my $isSWbyId = "INSERT INTO EAADMIN.recon_software(SOFTWARE_ID,ID,ACTION,REMOTE_USER,RECORD_TIME) values ( ?, DEFAULT,?,'zhysz\@cn.ibm.com',CURRENT TIMESTAMP)";
my $isCSSWbyId = "INSERT INTO EAADMIN.recon_customer_sw(CUSTOMER_ID,SOFTWARE_ID,ID,ACTION,REMOTE_USER,RECORD_TIME) values (?, ?, DEFAULT,?,'zhysz\@cn.ibm.com',CURRENT TIMESTAMP)";
my $isLicbyId = "INSERT INTO EAADMIN.recon_license(CUSTOMER_ID,LICENSE_ID,ID,ACTION,REMOTE_USER,RECORD_TIME) values (?, ?, DEFAULT,?,'zhysz\@cn.ibm.com',CURRENT TIMESTAMP)";
my $queryReINstSw = "SELECT * FROM recon_installed_sw WHERE  installed_software_id = ?";
my $queryReSWLpar = "SELECT * FROM recon_sw_lpar WHERE software_lpar_id = ?";
my $queryReHWLpar = "SELECT * FROM recon_hw_lpar WHERE hardware_lpar_id = ?";
my $queryReHW = "SELECT * FROM recon_hardware WHERE hardware_id = ?";
my $queryReSW = "SELECT * FROM recon_software WHERE software_id = ?";
my $queryReCSSW = "SELECT * FROM recon_customer_sw WHERE customer_id = ? and software_id = ? ";
my $queryReLic = "SELECT * FROM recon_license WHERE license_id = ?";

sub exec_sql_rs {
    my $dbconnection = shift;
    my $sqlname = shift;
    my $sql = shift;
    my $id = shift;
    my $customerId = shift;
    my @rs = ();
    eval {
    	$dbconnection->prepareSqlQuery($sqlname,$sql);
        my $sth = $dbconnection->sql->{$sqlname};
        if ( defined $id && defined $customerId ) {
        	$sth->execute( $customerId , $id );
        }elsif( defined $id ) {
        	$sth->execute($id);
        }else {
        	$sth->execute();
        }
        push @rs, [ @{ $sth->{NAME} } ];
        while (my @row = $sth->fetchrow_array()) {
            push @rs, [ @row ];
        }
        $sth->finish();
    };
    if ($@) {
        die "Unable to execute sql command ($sql): $@\n";
    }
    return @rs;
}

sub exec_sql_rc {
    my $dbconnection = shift;
    my $sqlname = shift;
    my $sql = shift;
    my $objectId = shift;
    my $action =  shift;
    my $customerId = shift;    
    my $rc ;
    eval {
    	$dbconnection->prepareSqlQuery($sqlname,$sql);
        my $sth = $dbconnection->sql->{$sqlname};
        if ( defined $customerId ){
        	$rc = $sth->execute($customerId,$objectId,$action);
        } else {
        	$rc = $sth->execute($objectId,$action);
        }
        $sth->finish();
    };
    if ($@) {
        die "Unable to execute sql command ($sql): $@\n";
    }
    return $rc;
}

sub deleteComma($)
        {
        while($_[0] =~ m/\,/)
                {
                $_[0] =~ s/\,//;
                }
 }

	print LOG "*** $timeDate ***\n";
	print LOG "*** Starting Insertion *** \n";
	

eval {
print "This script is going to insert mass reocrds into recon queue table, which queue are you going to insert ?\n ";
$| = 1; 
my $queuename ;
while  ( !exists( $recontables{$queuename} )){
print "1)recon_installed_sw  2)recon_sw_lpar  3)recon_hw_lpar 4)recon_hardware 5)recon_software 6)recon_customer_sw 7)recon_license 8)exit \n";
print "Please enter a name : ";
$queuename = <STDIN>;
$queuename =~ s/(?!\cH)\X\cH//g;
chomp($queuename);
}

if ( defined $queuename && $queuename ne 'exit' ){
	 if($queuename eq 'recon_installed_sw'){ $objectname = 'installed_software';$queryname = 'seINstSwbyId'; $insername = 'isINstSwbyId' ; $queryreconname = 'queryReINstSw' ; $querystatement = $seINstSwbyId; $inserstatement = $isINstSwbyId ; $queryrecons = $queryReINstSw ;};
	 if($queuename eq 'recon_sw_lpar'){ $objectname = 'software_lpar';$queryname = 'seSWLparbyId'; $insername = 'isSWLparbyId' ; $queryreconname = 'queryReSWLpar' ; $querystatement = $seSWLparbyId; $inserstatement = $isSWLparbyId ;  $queryrecons = $queryReSWLpar ;};
	 if($queuename eq 'recon_hw_lpar'){ $objectname = 'hardware_lpar';$queryname = 'seHWLparbyId'; $insername = 'isHWLparbyId' ; $queryreconname = 'queryReHWLpar' ;$querystatement = $seHWLparbyId; $inserstatement = $isHWLparbyId ;  $queryrecons = $queryReHWLpar ;};
	 if($queuename eq 'recon_hardware'){ $objectname = 'hardware';$queryname = 'seHWbyId'; $insername = 'isHWbyId' ; $queryreconname = 'queryReHW' ; $querystatement = $seHWbyId; $inserstatement = $isHWbyId ;  $queryrecons = $queryReHW ;};
	 if($queuename eq 'recon_software'){ $objectname = 'software';$queryname = 'seSWbyId'; $insername = 'isSWbyId' ; $queryreconname = 'queryReSW' ; $querystatement = $seSWbyId; $inserstatement = $isSWbyId ;  $queryrecons = $queryReSW ;};
	 if($queuename eq 'recon_customer_sw'){ $objectname = 'schedule';$queryname = 'seCSSWbyId'; $insername = 'isCSSWbyId' ; $queryreconname = 'queryReCSSW' ; $querystatement = $seCSSWbyId; $inserstatement = $isCSSWbyId ;  $queryrecons = $queryReCSSW ;};
	 if($queuename eq 'recon_license'){ $objectname = 'license';$queryname = 'seLicbyId'; $insername = 'isLicbyId' ; $queryreconname = 'queryReLic' ; $querystatement = $seLicbyId; $inserstatement = $isLicbyId ;  $queryrecons = $queryReLic ;};
my $tname = substr $queuename, 6;
print "Please enter $tname Id or Sql script or a Sql file \n ";
$| = 1; 

while ( !defined $prenter || $prenter eq ''){
print "##:";
$prenter = <STDIN>;
$prenter =~ s/(?!\cH)\X\cH//g;
chomp($prenter);
}
$enter = $prenter ;
deleteComma($prenter);
if ( $prenter =~ m/\D/ )	{
   	if ($enter =~ m/^(select|SELECT)/ && $enter =~ m/from/i  && $enter =~ m/id/i && $enter =~ m/($objectname)/i && $enter =~ m/as\ action/i ){
   	    print "Quering data..... \n";
   	 my @rs = exec_sql_rs($trailsconnection,'entersql',$enter);
   	    print "$#rs records found,do you want to insert them into queue? ";	
 	    $insertion = <STDIN>;
 	    $insertion =~ s/(?!\cH)\X\cH//g;
 	    chomp($insertion);
	 if ( $insertion eq 'y' ) {
	 	print "Inserting data to $queuename queue..... \n";
	 	print LOG "Inserting data to $queuename queue.....\n";
	  for my $i (0 .. $#rs) {
	  	  next if $i == 0;
	  	  if ($queryreconname eq 'queryReSW'){ $objectId = $rs[$i][0]; $action = $rs[$i][1];}
	  	  else {$customerId = $rs[$i][0];$objectId = $rs[$i][1];$action = $rs[$i][2];}	     
	 	  my @rd;
	     if ($queryreconname eq 'queryReCSSW'){
	        @rd = exec_sql_rs($trailsconnection,$queryreconname,$queryrecons,$objectId,$customerId);
	     }else {
	        @rd = exec_sql_rs($trailsconnection,$queryreconname,$queryrecons,$objectId);	
	     }
	     if ( $#rd > 0 ){
	     	print LOG "$queuename (customerId $customerId ) and $tname\_Id $objectId already in queue \n";
	     } else {
	     	my $rc;
	     	if ($insername eq 'isSWbyId'){
	     		 $rc = exec_sql_rc($trailsconnection,$insername,$inserstatement,$objectId,$action);
	     	}else{
	     		 $rc = exec_sql_rc($trailsconnection,$insername,$inserstatement,$objectId,$action,$customerId);
	     	}
	    	if ( $rc == 1 ) {
					print LOG "Insert into $queuename (customerId $customerId) and $tname\_Id $objectId \n";								
				} else {
					print LOG "Fatal error attempted to $queuename failure.\n";
					die "Fatal error attempted to insert\n";									
				}
	         }
	          }
	          print LOG "All data insertion complete,Data processed!\n";
	          print "Data processed !\n";
	       }else {
	       	print "Exit.\n";
	       	exit ;
	      } 		
   	} elsif ($enter =~ m/\.sql$/i){  	
   		print "Opening sql file....\n"	;
   		my $filesql = '';
   		open( FILE, "<", $enter ) or die "Cannot open $enter";
   		while (my $line = <FILE>) {
   			chomp($line);
   			$filesql = $filesql .$line . ' ';
   		}
   		close FILE ;
   	if ($filesql =~ m/^(select|SELECT)/ && $filesql =~ m/from/i  && $filesql =~ m/id/i && $filesql =~ m/($objectname)/i && $filesql =~ m/as\ action/i ){
        print "Quering data..... \n";
         my @rs = exec_sql_rs($trailsconnection,'filesql',$filesql);
          	    print "$#rs records found,do you want to insert them into queue? ";	
 	    $insertion = <STDIN>;
 	    $insertion =~ s/(?!\cH)\X\cH//g;
 	    chomp($insertion);
	 if ( $insertion eq 'y' ) {
	 	print "Inserting data to $queuename queue..... \n";
	 	print LOG "Inserting data to $queuename queue.....\n";
	  for my $i (0 .. $#rs) {
	  	next if $i ==0 ;
	  	 if ($queryreconname eq 'queryReSW'){ $objectId = $rs[$i][0]; $action = $rs[$i][1];}
	  	  else {$customerId = $rs[$i][0];$objectId = $rs[$i][1];$action = $rs[$i][2];}	
	  	    my @rd;
	     if ($queryreconname eq 'queryReCSSW'){
	        @rd = exec_sql_rs($trailsconnection,$queryreconname,$queryrecons,$objectId,$customerId);
	     }else {
	        @rd = exec_sql_rs($trailsconnection,$queryreconname,$queryrecons,$objectId);	
	     }
	     if ( $#rd > 0 ){
	     	print LOG "$queuename (customerId $customerId) and $tname\_Id $objectId already in queue \n";
	     } else {
	     	my $rc;
	     	if ($insername eq 'isSWbyId'){
	     		 $rc = exec_sql_rc($trailsconnection,$insername,$inserstatement,$objectId,$action);
	     	}else{
	     		 $rc = exec_sql_rc($trailsconnection,$insername,$inserstatement,$objectId,$action,$customerId);
	     	}
	    	if ( $rc == 1 ) {
					print LOG "Insert into $queuename (customerId $customerId) and $tname\_Id $objectId \n";								
				} else {
					print LOG "Fatal error attempted to $queuename failure.\n";
					die "Fatal error attempted to insert\n";									
				}
	     }
	          }
	          print LOG "All data insertion complete,Data processed!\n";
	          print "Data processed !\n";
	       }else {
	       	print "Exit.\n";
	       	exit ;
	      } 
   		} else {
   		print "Not a legal sql statement or matched to the queue you are going to insert,invalid sql script($filesql) .\n";
   		print "Sql script statement should like \'SELECT [*.customer_id],*.id,\'[UPDATAE][DEEP]\' as action from ...\'\n";
   		exit;
   	}
   	}
   	else{
   		print "Not a recognized sql statement or file or id ,invalid Enter($enter) .\n";
   		print "Id should be a digital number,\nSql script like \'SELECT [*.customer_id],*.id,\'[UPDATAE][DEEP]\' as action from ...\',\nSql file should be a file path like \'\/home\/zhysz\/run.sql\'\n";
   		exit;
   	}
   		

} else {
	$action = 'UPDATE';
	$querystatement =~ s/\?/$enter/;
   	 my @rs = exec_sql_rs($trailsconnection,$queryname,$querystatement);
	if ( $#rs > 0 ) {
	for my $i (0 .. $#rs) {
	  	  next if $i == 0;
	  	  if ($queryreconname eq 'queryReSW'){ $objectId = $rs[$i][0]; }
	  	  else {$customerId = $rs[$i][0];$objectId = $rs[$i][1];}	
	    print "$#rs records found, the $i one is  (customerId $customerId) and $tname\_Id $objectId \n";
	    print "do you want to insert into queue? ";
	    $insertion = <STDIN>;
	    $insertion =~ s/(?!\cH)\X\cH//g;
	    chomp($insertion);
	    if ( $insertion eq 'y' ) 
	    {   
	     my @rd;
	     if ($queryreconname eq 'queryReCSSW'){
	        @rd = exec_sql_rs($trailsconnection,$queryreconname,$queryrecons,$objectId,$customerId);
	     }else {
	        @rd = exec_sql_rs($trailsconnection,$queryreconname,$queryrecons,$objectId);	
	     }
	     if ( $#rd > 0 ){
	     	print "$queuename (customerId $customerId) and $tname\_Id $objectId already in queue \n";
	     	print LOG "$queuename (customerId $customerId) and $tname\_Id $objectId already in queue \n";
	     } else {
	     	 	my $rc;
	     	if ($insername eq 'isSWbyId'){
	     		 $rc = exec_sql_rc($trailsconnection,$insername,$inserstatement,$objectId,$action);
	     	}else{
	     		 $rc = exec_sql_rc($trailsconnection,$insername,$inserstatement,$objectId,$action,$customerId);
	     	}
	    	if ( $rc == 1 ) {
					print LOG "Insert into $queuename (with customerId $customerId) and $tname\_Id $objectId \n";
					print "Data inserted \n";								
				} else {
					print LOG "Fatal error attempted to $queuename failure.\n";
					die "Fatal error attempted to insert\n";									
				}
	    }
	    }else {
	    	print "Exit.\n";
	    	exit ;
	    }
	}
	 print LOG "All data insertion complete,data inserted !\n";
	}else{
		print "There is no any record matched , break out! \n";
		exit;
	}
   }

   } else {
	print "End and exit process. \n";
	exit ;
  }
};
if ($@) {
	die "ERROR: $@";
}


#$trailsconnection->commit;
my $rc = $trailsconnection->disconnect or warn $trailsconnection->dbh->errstr;
print LOG "Disconnected from DB with $rc\n";
close LOG;
