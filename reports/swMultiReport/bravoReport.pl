#!/usr/bin/perl -w                                                                       
                                                                                         
###############################################################################          
# Name          : bravoReport.pl                                                 
# Component     : bravo                                                                  
# Description   : Creates swMultiReport for given customer
###############################################################################
                                                                                         
###############################################################################          
### Use/Require Statements                                                               
###############################################################################          
         
# the script may be tested on tap2 and is setup to be loaded into 
# /opt/bravo/scripts/report

use lib '/opt/staging/v2';                                         
require "/opt/staging/v2/Database/Connection.pm";                                                                                         

use strict;                                                                              
                                                                                         
use DBI;                                                                                 
use Getopt::Long qw(GetOptions);
use Readonly;                                                                            
use Sort::Versions;                                                                      
use Spreadsheet::WriteExcel::Big;                                                        
                                                                                         
# for pushing the results                                                                
use File::Slurp qw{ slurp };                                                             
use HTTP::Request::Common;                                                               
use LWP::UserAgent;
use Net::FTP;
                                                                      
                                                                                         
# db access                                                                              
use Config::Properties::Simple;
               
                                                                                         
###############################################################################          
### Define Script Variables                                                              
###                                                                                      
###############################################################################          
                                                                                         
                                                                                         
my ( $sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst ) =                     
  localtime(time);                                                                       
my @days = (                                                                             
	"Sunday",   "Monday", "Tuesday", "Wednesday",                                          
	"Thursday", "Friday", "Saturday"                                                       
);                                                                                       
my @months = (                                                                           
	"January", "February", "March",     "April",   "May",      "June",                     
	"July",    "August",   "September", "October", "November", "December"                  
);                                                                                       
my $day  = $days[$wday];                                                                 
my $date = $mday;                                                                    
$year = 1900 + $year;                                                                    
my $month = $months[$mon];                                                               

my $emptyFlag = undef;
my $customer = undef;

GetOptions(
'c=i' => \$customer,
'empty' => \$emptyFlag,
) or die "Usage: $0 -c CUSTOMER_NUMBER (-e for empty bank account)\n";
die "Usage: $0 -c CUSTOMER_NUMBER (-e for empty bank account)\n"
  unless defined $customer;

                                                                                         
my $reportDir = '/opt/reports/swMulti/target/bin';
my $JAR       = '/opt/reports/swMulti/target';
my $logFilePath   = '/opt/reports/swMulti/logs/bravoReport.log.'."$customer";
my $connConfigFile = '/opt/staging/v2/config/connectionConfig.txt';                                
my $zipfile;
our $accountNumber;
my $productCount;
my $logFile;
open($logFile, '>>', $logFilePath);
                                                                                         

###############################################################################          
### MAIN
###                                                                                      
###############################################################################          
#-----------------------------------------------------------------------------
logit( "Acquiring bravo database handle", $logFile );                                    
my $dbh = Database::Connection->new('trailsst');
logit( "Bravo Database handle acquired", $logFile ); 
my $bravoSoftware;

if(defined $emptyFlag){
	logit( "generating empty swMultiReport (just headers)", $logFile ); 
	logit( "searching for account number", $logFile ); 
	getAccNumber();
	logit( "account number found", $logFile ); 
}else{
	logit( "Acquiring data from trails DB", $logFile );
	$bravoSoftware = getBravoSoftwareReport($dbh,$customer); 
	logit( "Data axquired", $logFile );
}

logit( "Started generating xls file", $logFile );
our $workbook = Spreadsheet::WriteExcel::Big->new("$reportDir/$accountNumber.xls");
logit( "Created xls file object", $logFile );

logit( "Creating HeartBeatSheet", $logFile );
createHeartbeatSheet();
logit( "Created HeartBeatSheet", $logFile );
logit( "Creating software sheet", $logFile );
createSoftwareSheet();
logit( "Created software sheet", $logFile );
logit( "Creating product count sheet", $logFile );
createProductCountSheet();
logit( "Created product count sheet", $logFile );
logit( "xls file generation finished", $logFile );
$workbook->close();
logit( "Zipping the report ", $logFile );
zipFile();
logit( "Report is zipped", $logFile );
logit( "Sending report to GSA", $logFile );
sendReportToGSA();
logit( "Report sent", $logFile );
close($logFile);


###############################################################################          
### Function definitions
###                                                                                      
###############################################################################          
sub getAccNumber{
	$dbh->prepareSqlQuery('simplereport',"SELECT account_number from eaadmin.customer where customer_id=$customer and status='ACTIVE' with ur");
    ###Get the statement handle
	my $sth = $dbh->sql->{simplereport};
	my $accNumber;
	$sth->bind_columns(\$accNumber);
	$sth->execute();
	while ( $sth->fetchrow_arrayref ) {
    	$accountNumber = $accNumber;
    }
}

sub getBravoSoftwareReport {
	my ( $dbh, $customerId ) = @_;

	my $name;
	my $model;
	my $biosSerial;
	my $processorCount;
	my $chipCount;
	my $scantime;
	my $softwareName;
	my $pid;
	my $softwareManufacturer;
	my $level;
	my $priority;
	my $softwareVersion;
	my $bankAccount;
	my $softwareCategory;
	my $osMinorVers;
	my $osSubVers;
	my $discrepancyType;
	my $scopeDescription;
	my $serverType;
	my $cpuMIPS;
	my $cpuGartnerMIPS;
	my $cpuMSU;
	my $partMIPS;
	my $partGartnerMIPS;
	my $partMSU;
	my $lparStatus;
	my $hardwareStatus;
	my %data;

	my $query = "
select
					   c.account_number
                      ,v_isw.nodename
                      ,v_isw.model
                      ,v_isw.bios_serial
                      ,v_isw.processor_count
                      ,COALESCE(hw.chips, 0)
                      ,v_isw.scantime
                      ,sw.software_name
                      ,sw.pid
                      ,man.name
                      ,sw.level
                      ,sw.priority
                      ,v_isw.version
                      ,ba.name
                      ,sw_sc.software_category_name
                      ,v_isw.os_minor_vers
                      ,v_isw.os_sub_vers
                      ,dt.name
                      , COALESCE ( CAST ( (select scop.description from eaadmin.scope scop join eaadmin.schedule_f sf on sf.scope_id = scop.id
							where sf.customer_id = $customerId
							and sf.status_id=2
							and sf.software_name = sw.software_name
							and ( ( sf.level = 'PRODUCT' )
							or (( sf.hostname = v_isw.nodename ) and ( level = 'HOSTNAME' ))
							or (( sf.serial = hw.serial ) and ( sf.machine_type = mt.name ) and ( sf.level = 'HWBOX' ))
							or (( sf.hw_owner = hw.owner ) and ( sf.level ='HWOWNER' )) )
							order by sf.LEVEL fetch first 1 rows only) as varchar(64) ), 'Not specified' ) as swOwner
                      ,hw.server_type
                      ,hw.cpu_mips
                      ,hw.cpu_gartner_mips
                      ,hw.cpu_msu
                      ,hl.part_mips
                      ,hl.part_gartner_mips
                      ,hl.part_msu
                      ,hl.lpar_status
                      ,hw.hardware_status
	from
		eaadmin.customer c
		join eaadmin.v_installed_software v_isw on ( c.customer_id = v_isw.customer_id and v_isw.discrepancy_type_id not in (3,5) and v_isw.inst_status = 'ACTIVE' and v_isw.software_lpar_status = 'ACTIVE' )
		join eaadmin.software sw on ( sw.software_id = v_isw.software_id )
		join eaadmin.manufacturer man on ( man.id = sw.manufacturer_id )
		join eaadmin.software_category sw_sc on ( sw_sc.software_category_id = sw.software_category_id and sw_sc.status = 'ACTIVE' )
		join eaadmin.discrepancy_type dt on ( dt.id = v_isw.discrepancy_type_id )
		join eaadmin.bank_account ba on ( ba.id =  v_isw.bank_account_id )
						
		left outer join eaadmin.hw_sw_composite hwsw on ( hwsw.software_lpar_id = v_isw.software_lpar_id )
		left outer join eaadmin.hardware_lpar hl on ( hl.id = hwsw.hardware_lpar_id )
		left outer join eaadmin.hardware hw on ( hw.id = hl.hardware_id )
						
		left outer join eaadmin.machine_type mt on ( mt.id = hw.machine_type_id )
	
	where c.customer_id = $customerId
 
	order by sw.priority ASC";

    $dbh->prepareSqlQuery( 'bravoreport', $query);
    $dbh->prepareSqlQuery('simplereport',"SELECT account_number from eaadmin.customer where customer_id=$customerId and status='ACTIVE' with ur");
    ###Get the statement handle
    my $sth = $dbh->sql->{bravoreport};
	my $accsth = $dbh->sql->{simplereport};
    my $accNumber;
	$accsth->bind_columns(\$accNumber);

	$sth->bind_columns(
		\$accountNumber,   	\$name,           	\$model,
		\$biosSerial,      	\$processorCount, 	\$chipCount,
		\$scantime,        	\$softwareName,		\$pid,	
		\$softwareManufacturer,					\$level,
		\$priority, 	   	\$softwareVersion, 	\$bankAccount,    
		\$softwareCategory,	\$osMinorVers,     	\$osSubVers, 
		\$discrepancyType,     
		\$scopeDescription, \$serverType,       \$cpuMIPS,
		\$cpuGartnerMIPS,
		\$cpuMSU,           \$partMIPS,        \$partGartnerMIPS, 
		\$partMSU,
		\$lparStatus,       \$hardwareStatus
	);

	my $rc = $sth->execute();
	
    if ($rc){
    
	while ( $sth->fetchrow_arrayref ) {

		$data{$accountNumber}{$name}{'model'}          = $model;
		$data{$accountNumber}{$name}{'biosSerial'}     = $biosSerial;
		$data{$accountNumber}{$name}{'processorCount'} = $processorCount;
		$data{$accountNumber}{$name}{'chipCount'} = $chipCount;
		$data{$accountNumber}{$name}{'scantime'}       = $scantime;
		$data{$accountNumber}{$name}{'bankAccount'}{$bankAccount} = 0;
		$data{$accountNumber}{$name}{'osMinorVers'} = $osMinorVers;
		$data{$accountNumber}{$name}{'osSubVers'}   = $osSubVers;
		$data{$accountNumber}{$name}{'serverType'}   = $serverType;
		$data{$accountNumber}{$name}{'cpuMIPS'}   = $cpuMIPS;
		$data{$accountNumber}{$name}{'cpuGartnerMIPS'}   = $cpuGartnerMIPS;
		$data{$accountNumber}{$name}{'cpuMSU'}   = $cpuMSU;
		$data{$accountNumber}{$name}{'partMIPS'}   = $partMIPS;
		$data{$accountNumber}{$name}{'partGartnerMIPS'}   = $partGartnerMIPS;
		$data{$accountNumber}{$name}{'partMSU'}   = $partMSU;
		$data{$accountNumber}{$name}{'lparStatus'}   = $lparStatus;
		$data{$accountNumber}{$name}{'hardwareStatus'}   = $hardwareStatus;
        
		if ( $softwareCategory =~ /Operating Systems/ ) {
			if (
				exists(
					$data{$accountNumber}{$name}{'osName'}
				)
			  )
			{
				if ( $data{$accountNumber}{$name}{'osName'} eq $softwareName )
				{
					$data{$accountNumber}{$name}{'osVersion'}{$softwareVersion} = 0;
				}
				
			}
			else {
				$data{$accountNumber}{$name}{'osName'}    = $softwareName;
				$data{$accountNumber}{$name}{'osVersion'}{$softwareVersion} = 0;
			}
		}
		elsif ( $softwareCategory eq 'UNKNOWN' ) {
			$data{$accountNumber}{$name}{'unknown'}{$softwareCategory}
			  {$softwareName}{'softwareVersion'}{$softwareVersion} = 0;
			$data{$accountNumber}{$name}{'unknown'}{$softwareCategory}
			  {$softwareName}{'softwareManufacturer'} = $softwareManufacturer;
			$data{$accountNumber}{$name}{'unknown'}{$softwareCategory}
			  {$softwareName}{'pid'} = $pid;
			$data{$accountNumber}{$name}{'unknown'}{$softwareCategory}
			  {$softwareName}{'level'} = $level;
			$data{$accountNumber}{$name}{'unknown'}{$softwareCategory}
			  {$softwareName}{'priority'} = $priority;
			$data{$accountNumber}{$name}{'unknown'}{$softwareCategory}
			  {$softwareName}{'bankAccount'} = $bankAccount;
			$data{$accountNumber}{$name}{'unknown'}{$softwareCategory}
			  {$softwareName}{'scopeDescription'} = $scopeDescription;
			$data{$accountNumber}{$name}{'unknown'}{$softwareCategory}
			  {$softwareName}{'discrepancyType'} = $discrepancyType;
		}
		else {
			if (
				exists(
					$data{$accountNumber}{$name}{'software'}{$softwareCategory}
				)
			  )
			{
				if ( $data{$accountNumber}{$name}{'software'}{$softwareCategory}
					{'softwareName'} eq $softwareName )
				{
					$data{$accountNumber}{$name}{'software'}{$softwareCategory}
					  {'softwareVersion'}{$softwareVersion} = 0;
					$data{$accountNumber}{$name}{'software'}{$softwareCategory}
					  {'bankAccount'}{$bankAccount} = 0;
				}
				next;
			}

			$data{$accountNumber}{$name}{'software'}{$softwareCategory}
			  {'softwareName'} = $softwareName;
			$data{$accountNumber}{$name}{'software'}{$softwareCategory}
			  {'pid'} = $pid;
			$data{$accountNumber}{$name}{'software'}{$softwareCategory}
			  {'softwareManufacturer'} = $softwareManufacturer;  
			$data{$accountNumber}{$name}{'software'}{$softwareCategory}
			  {'level'} = $level;
			$data{$accountNumber}{$name}{'software'}{$softwareCategory}
			  {'priority'} = $priority;
			$data{$accountNumber}{$name}{'software'}{$softwareCategory}
			  {'softwareVersion'}{$softwareVersion} = 0;
			$data{$accountNumber}{$name}{'software'}{$softwareCategory}
			  {'bankAccount'}{$bankAccount} = 0;
			$data{$accountNumber}{$name}{'software'}{$softwareCategory}
			  {'scopeDescription'} = $scopeDescription;
			$data{$accountNumber}{$name}{'software'}{$softwareCategory}
			  {'discrepancyType'} = $discrepancyType;
		}
	 } 
    } else {
    	
     	$accsth->execute();
       while ( $accsth->fetchrow_arrayref ) {
    	$accountNumber = $accNumber;
       }
       
       	$data{$accountNumber}{$name}{'model'}          = $model;
		$data{$accountNumber}{$name}{'biosSerial'}     = $biosSerial;
		$data{$accountNumber}{$name}{'processorCount'} = $processorCount;
		$data{$accountNumber}{$name}{'chipCount'} = $chipCount;
		$data{$accountNumber}{$name}{'scantime'}       = $scantime;
		$data{$accountNumber}{$name}{'bankAccount'}{$bankAccount} = 0;
		$data{$accountNumber}{$name}{'osMinorVers'} = $osMinorVers;
		$data{$accountNumber}{$name}{'osSubVers'}   = $osSubVers;
		$data{$accountNumber}{$name}{'serverType'}   = $serverType;
		$data{$accountNumber}{$name}{'cpuMIPS'}   = $cpuMIPS;
		$data{$accountNumber}{$name}{'cpuGartnerMIPS'}   = $cpuGartnerMIPS;
		$data{$accountNumber}{$name}{'cpuMSU'}   = $cpuMSU;
		$data{$accountNumber}{$name}{'partMIPS'}   = $partMIPS;
		$data{$accountNumber}{$name}{'partGartnerMIPS'}   = $partGartnerMIPS;
		$data{$accountNumber}{$name}{'partMSU'}   = $partMSU;
		$data{$accountNumber}{$name}{'lparStatus'}   = $lparStatus;
		$data{$accountNumber}{$name}{'hardwareStatus'}   = $hardwareStatus;
		
		$data{$accountNumber}{$name}{'software'}{$softwareCategory}
			  {'softwareName'} = $softwareName;
		$data{$accountNumber}{$name}{'software'}{$softwareCategory}
			  {'pid'} = $pid;
			$data{$accountNumber}{$name}{'software'}{$softwareCategory}
			  {'softwareManufacturer'} = $softwareManufacturer;
			$data{$accountNumber}{$name}{'software'}{$softwareCategory}
			  {'level'} = $level;
			$data{$accountNumber}{$name}{'software'}{$softwareCategory}
			  {'priority'} = $priority;
			$data{$accountNumber}{$name}{'software'}{$softwareCategory}
			  {'softwareVersion'}{$softwareVersion} = 0;
			$data{$accountNumber}{$name}{'software'}{$softwareCategory}
			  {'bankAccount'}{$bankAccount} = 0;
			$data{$accountNumber}{$name}{'software'}{$softwareCategory}
			  {'scopeDescription'} = $scopeDescription;
			$data{$accountNumber}{$name}{'software'}{$softwareCategory}
			  {'discrepancyType'} = $discrepancyType;
    }

	$sth->finish();

	return \%data;
	
}

sub createHeartbeatSheet{

	my $heartbeat = $workbook->add_worksheet("Heartbeat");
my $lineCount = 2;

  $heartbeat->write( 0, 0,"IBM Confidential" );
	$heartbeat->write( 1, 0,
		"REPORT DATE: $month $date, $year $hour:$min:$sec" );
	$heartbeat->write( $lineCount, 0, "HOSTNAME" );
	$heartbeat->write( $lineCount, 1, "MODEL" );
	$heartbeat->write( $lineCount, 2, "SERIAL NUMBER" );
	$heartbeat->write( $lineCount, 3, "PROCESSOR COUNT" );
	$heartbeat->write( $lineCount, 4, "CHIP COUNT" );	
	$heartbeat->write( $lineCount, 5, "OS" );
	$heartbeat->write( $lineCount, 6, "OS VERSION" );
	$heartbeat->write( $lineCount, 7, "OS MINOR VERSION" );
	$heartbeat->write( $lineCount, 8, "OS SUB VERSION" );
	$heartbeat->write( $lineCount, 9, "SCANTIME" );
	$heartbeat->write( $lineCount, 10, "BANK ACCOUNT" );
	$heartbeat->write( $lineCount, 11, "SERVER TYPE" );
	$heartbeat->write( $lineCount, 12, "CPU IBM LSPR MIPS" );
	$heartbeat->write( $lineCount, 13, "CPU Gartner MIPS" );
	$heartbeat->write( $lineCount, 14, "CPU MSU" );
	$heartbeat->write( $lineCount, 15, "PART IBM LSPR MIPS" );
	$heartbeat->write( $lineCount, 16, "PART Gartner MIPS" );
	$heartbeat->write( $lineCount, 17, "PART MSU" );
	$heartbeat->write( $lineCount, 18, "LPAR STATUS" );
	$heartbeat->write( $lineCount, 19, "HARDWARE STATUS" );

	if(defined $emptyFlag){
		return;
	}

	$lineCount++;

	foreach my $hostname ( sort keys %{ $bravoSoftware->{$accountNumber} } ) {
		my $hBankAccounts;

		foreach my $bankAccount (
			sort keys
			%{ $bravoSoftware->{$accountNumber}->{$hostname}->{'bankAccount'} }
		  )
		{
			$hBankAccounts .= $bankAccount . ",";
		}
		
		my $osVersion = max_sw_version(
					keys %{
						$bravoSoftware->{$accountNumber}->{$hostname}->{'osVersion'}
					  }
				);

		chop $hBankAccounts;

		$heartbeat->write_string( $lineCount, 0, $hostname );
		$heartbeat->write( $lineCount, 1,
			$bravoSoftware->{$accountNumber}->{$hostname}->{'model'} );
		$heartbeat->write( $lineCount, 2,
			    "\""
			  . $bravoSoftware->{$accountNumber}->{$hostname}->{'biosSerial'}
			  . "\"" );
		$heartbeat->write( $lineCount, 3,
			$bravoSoftware->{$accountNumber}->{$hostname}->{'processorCount'} );
		$heartbeat->write( $lineCount, 4,
			$bravoSoftware->{$accountNumber}->{$hostname}->{'chipCount'} );
		$heartbeat->write( $lineCount, 5,
			$bravoSoftware->{$accountNumber}->{$hostname}->{'osName'} );
		$heartbeat->write_string( $lineCount, 6, $osVersion );
		$heartbeat->write( $lineCount, 7,
			$bravoSoftware->{$accountNumber}->{$hostname}->{'osMinorVers'} );
		$heartbeat->write( $lineCount, 8,
			$bravoSoftware->{$accountNumber}->{$hostname}->{'osSubVers'} );
		$heartbeat->write( $lineCount, 9,
			$bravoSoftware->{$accountNumber}->{$hostname}->{'scantime'} );
		$heartbeat->write( $lineCount, 10, $hBankAccounts );
		$heartbeat->write( $lineCount, 11,
			$bravoSoftware->{$accountNumber}->{$hostname}->{'serverType'} );
        $heartbeat->write( $lineCount, 12,
            $bravoSoftware->{$accountNumber}->{$hostname}->{'cpuMIPS'} );
        $heartbeat->write( $lineCount, 13,
            $bravoSoftware->{$accountNumber}->{$hostname}->{'cpuGartnerMIPS'} );
        $heartbeat->write( $lineCount, 14,
            $bravoSoftware->{$accountNumber}->{$hostname}->{'cpuMSU'} );
        $heartbeat->write( $lineCount, 15,
            $bravoSoftware->{$accountNumber}->{$hostname}->{'partMIPS'} );
        $heartbeat->write( $lineCount, 16,
            $bravoSoftware->{$accountNumber}->{$hostname}->{'partGartnerMIPS'} );
        $heartbeat->write( $lineCount, 17,
            $bravoSoftware->{$accountNumber}->{$hostname}->{'partMSU'} );
        $heartbeat->write( $lineCount, 18,
            $bravoSoftware->{$accountNumber}->{$hostname}->{'lparStatus'} );
        $heartbeat->write( $lineCount, 19,
            $bravoSoftware->{$accountNumber}->{$hostname}->{'hardwareStatus'} );
		$lineCount++;
	}                                                                                         
}

sub createSoftwareSheet {

	my $lineCount  = 2;
	my $page       = ( int( $lineCount / 60000 ) ) + 1;
	my $software   = $workbook->add_worksheet("Software $page");
	my $workbookCount = 0;

    $software->write( 0, 0,"IBM Confidential" );
	$software->write( 1, 0,
		"REPORT DATE: $month $date, $year $hour:$min:$sec" );
	$software->write( $lineCount, 0,  "HOSTNAME" );
	$software->write( $lineCount, 1,  "MODEL" );
	$software->write( $lineCount, 2,  "SERIAL NUMBER" );
	$software->write( $lineCount, 3,  "SCANTIME" );
	$software->write( $lineCount, 4,  "OS" );
	$software->write( $lineCount, 5,  "OS VERSION" );
	$software->write( $lineCount, 6,  "PROCESSOR COUNT" );
	$software->write( $lineCount, 7,  "CHIP COUNT" );
	$software->write( $lineCount, 8,  "MANUFACTURER" );	
	$software->write( $lineCount, 9,  "SOFTWARE NAME" );
	$software->write( $lineCount, 10,  "PID" );
	$software->write( $lineCount, 11,  "SOFTWARE VERSION" );
	$software->write( $lineCount, 12, "DISCREPANCY TYPE");
	$software->write( $lineCount, 13, "LICENSE" );
	$software->write( $lineCount, 14, "BANK ACCOUNT" );
	$software->write( $lineCount, 15, "SCOPE" );
	
	if(defined $emptyFlag){
		return;
	}

	$lineCount++;
	  foreach my $hostname ( sort keys %{ $bravoSoftware->{$accountNumber} } ) {
		
		my $osVersion = max_sw_version(
					keys %{
						$bravoSoftware->{$accountNumber}->{$hostname}->{'osVersion'}
					  }
				);

		foreach my $softwareCategory (
			sort keys
			%{ $bravoSoftware->{$accountNumber}->{$hostname}->{'software'} } )
		{
			my $softwareVersions;
			my $bankAccounts;

			$softwareVersions = max_sw_version(
				keys %{
					$bravoSoftware->{$accountNumber}->{$hostname}->{'software'}
					  ->{$softwareCategory}->{'softwareVersion'}
				  }
			);

			foreach my $bankAccount (
				sort keys %{
					$bravoSoftware->{$accountNumber}->{$hostname}->{'software'}
					  ->{$softwareCategory}->{'bankAccount'}
				}
			  )
			{
				$bankAccounts .= $bankAccount . ",";
			}

			chop $bankAccounts;

			$software->write_string( $lineCount, 0, $hostname );
			$software->write( $lineCount, 1,
				$bravoSoftware->{$accountNumber}->{$hostname}->{'model'} );
			$software->write( $lineCount, 2,
				"\""
				  . $bravoSoftware->{$accountNumber}->{$hostname}
				  ->{'biosSerial'} . "\"" );
			$software->write( $lineCount, 3,
				$bravoSoftware->{$accountNumber}->{$hostname}->{'scantime'} );
			$software->write( $lineCount, 4,
				$bravoSoftware->{$accountNumber}->{$hostname}->{'osName'} );
			$software->write_string( $lineCount, 5,$osVersion);
			$software->write( $lineCount, 6,
				$bravoSoftware->{$accountNumber}->{$hostname}
				  ->{'processorCount'} );
			$software->write( $lineCount, 7,
				$bravoSoftware->{$accountNumber}->{$hostname}
				  ->{'chipCount'} );
			$software->write( $lineCount, 8,
				$bravoSoftware->{$accountNumber}->{$hostname}->{'software'}
				  ->{$softwareCategory}->{'softwareManufacturer'} );
			$software->write( $lineCount, 9,
				$bravoSoftware->{$accountNumber}->{$hostname}->{'software'}
				  ->{$softwareCategory}->{'softwareName'} );
			$software->write( $lineCount, 10,
				$bravoSoftware->{$accountNumber}->{$hostname}->{'software'}
				  ->{$softwareCategory}->{'pid'} );
			$software->write( $lineCount, 11, $softwareVersions );
			$software->write( $lineCount, 12,
					$bravoSoftware->{$accountNumber}->{$hostname}->{'software'}
				  ->{$softwareCategory}->{'discrepancyType'} );
			$software->write( $lineCount, 13,
				$bravoSoftware->{$accountNumber}->{$hostname}->{'software'}
				  ->{$softwareCategory}->{'level'} );
			$software->write( $lineCount, 14, $bankAccounts );
			$software->write( $lineCount, 15,
                $bravoSoftware->{$accountNumber}->{$hostname}->{'software'}
                  ->{$softwareCategory}->{'scopeDescription'} );

			$lineCount++;

			my $endPage = ( int( $lineCount / 60000 ) ) + 1;

			if ( $endPage > 1 ) {

				if ( $page > 1 ) {
					$workbookCount++;
					$page = 0;
					$workbook->close();
					$workbook =
					  Spreadsheet::WriteExcel::Big->new(
						    "$reportDir/$accountNumber" . '_'
						  . "$workbookCount.xls" );
				}

				$page++;
				$lineCount = 0;
				$software  = $workbook->add_worksheet("Software $page");

				$software->write( $lineCount, 0,  "HOSTNAME" );
				$software->write( $lineCount, 1,  "MODEL" );
				$software->write( $lineCount, 2,  "SERIAL NUMBER" );
				$software->write( $lineCount, 3,  "SCANTIME" );
				$software->write( $lineCount, 4,  "OS" );
				$software->write( $lineCount, 5,  "OS VERSION" );
				$software->write( $lineCount, 6,  "PROCESSOR COUNT" );
				$software->write( $lineCount, 7,  "CHIP COUNT" );
				$software->write( $lineCount, 8,  "MANUFACTURER" );	
				$software->write( $lineCount, 9,  "SOFTWARE NAME" );
				$software->write( $lineCount, 10,  "PID" );
				$software->write( $lineCount, 11,  "SOFTWARE VERSION" );
				$software->write( $lineCount, 12, "DISCREPANCY TYPE");
				$software->write( $lineCount, 13, "LICENSE" );
				$software->write( $lineCount, 14, "BANK ACCOUNT" );
				$software->write( $lineCount, 15, "SCOPE" );
			$lineCount++;
			}

			$productCount->{ $bravoSoftware->{$accountNumber}->{$hostname}
				  ->{'osName'} }
			  ->{ $bravoSoftware->{$accountNumber}->{$hostname}->{'software'}
				  ->{$softwareCategory}->{'softwareName'} }->{'productCount'}++;
			$productCount->{ $bravoSoftware->{$accountNumber}->{$hostname}
				  ->{'osName'} }
			  ->{ $bravoSoftware->{$accountNumber}->{$hostname}->{'software'}
				  ->{$softwareCategory}->{'softwareName'} }->{'license'} =
			  $bravoSoftware->{$accountNumber}->{$hostname}->{'software'}
			  ->{$softwareCategory}->{'level'};
			$productCount->{ $bravoSoftware->{$accountNumber}->{$hostname}
				  ->{'osName'} }
			  ->{ $bravoSoftware->{$accountNumber}->{$hostname}->{'software'}
				  ->{$softwareCategory}->{'softwareName'} }->{'softwareManufacturer'} =
			  $bravoSoftware->{$accountNumber}->{$hostname}->{'software'}
			  ->{$softwareCategory}->{'softwareManufacturer'};
			$productCount->{ $bravoSoftware->{$accountNumber}->{$hostname}
				  ->{'osName'} }
			  ->{ $bravoSoftware->{$accountNumber}->{$hostname}->{'software'}
				  ->{$softwareCategory}->{'softwareName'} }
			  ->{'processorCount'} +=
			  $bravoSoftware->{$accountNumber}->{$hostname}->{'processorCount'};
			$productCount->{ $bravoSoftware->{$accountNumber}->{$hostname}
				  ->{'osName'} }
			  ->{ $bravoSoftware->{$accountNumber}->{$hostname}->{'software'}
				  ->{$softwareCategory}->{'softwareName'} }
			  ->{'chipCount'} +=
			  $bravoSoftware->{$accountNumber}->{$hostname}->{'chipCount'};
		}

		foreach my $softwareCategory (
			sort
			keys %{ $bravoSoftware->{$accountNumber}->{$hostname}->{'unknown'} }
		  )
		{
			foreach my $softwareName (
				sort keys %{
					$bravoSoftware->{$accountNumber}->{$hostname}->{'unknown'}
					  ->{$softwareCategory}
				}
			  )
			{
				my $softwareVersions;

				$softwareVersions = max_sw_version(
					keys %{
						$bravoSoftware->{$accountNumber}->{$hostname}
						  ->{'unknown'}->{$softwareCategory}->{$softwareName}
						  ->{'softwareVersion'}
					  }
				);

				$software->write_string( $lineCount, 0, $hostname );
				$software->write( $lineCount, 1,
					$bravoSoftware->{$accountNumber}->{$hostname}->{'model'} );
				$software->write( $lineCount, 2,
					"\""
					  . $bravoSoftware->{$accountNumber}->{$hostname}
					  ->{'biosSerial'} . "\"" );
				$software->write( $lineCount, 3,
					$bravoSoftware->{$accountNumber}->{$hostname}
					  ->{'scantime'} );
				$software->write( $lineCount, 4,
					$bravoSoftware->{$accountNumber}->{$hostname}->{'osName'} );
				$software->write_string( $lineCount, 5,$osVersion);
				$software->write( $lineCount, 6,
					$bravoSoftware->{$accountNumber}->{$hostname}
					  ->{'processorCount'} );
			    $software->write( $lineCount, 7,
					$bravoSoftware->{$accountNumber}->{$hostname}
					  ->{'chipCount'} );
				$software->write( $lineCount, 8, $bravoSoftware->{$accountNumber}->{$hostname}->{'unknown'}
					  ->{$softwareCategory}->{$softwareName}->{'softwareManufacturer'} );					  
				$software->write( $lineCount, 9, $softwareName );
				$software->write( $lineCount, 10, 
			  		$bravoSoftware->{$accountNumber}->{$hostname}->{'unknown'}
					->{$softwareCategory}->{$softwareName}->{'pid'} );
				$software->write( $lineCount, 11, $softwareVersions );
				$software->write( $lineCount, 12,
					$bravoSoftware->{$accountNumber}->{$hostname}->{'unknown'}
					->{$softwareCategory}->{$softwareName}->{'discrepancyType'} );
				$software->write( $lineCount, 13,
					$bravoSoftware->{$accountNumber}->{$hostname}->{'unknown'}
					  ->{$softwareCategory}->{$softwareName}->{'level'} );
				$software->write( $lineCount, 14,
					$bravoSoftware->{$accountNumber}->{$hostname}->{'unknown'}
					  ->{$softwareCategory}->{$softwareName}->{'bankAccount'} );
			   $software->write( $lineCount, 15,
                    $bravoSoftware->{$accountNumber}->{$hostname}->{'unknown'}
                      ->{$softwareCategory}->{$softwareName}->{'scopeDescription'} );

				$lineCount++;

				my $endPage = ( int( $lineCount / 60000 ) ) + 1;

				if ( $endPage > 1 ) {

					if ( $page > 1 ) {
						$workbookCount++;
						$page = 0;
						$workbook->close();
						$workbook =
						  Spreadsheet::WriteExcel::Big->new(
							    "$reportDir/$accountNumber" . '_'
							  . "$workbookCount.xls" );
					}

					$page++;
					$lineCount = 0;
					$software  = $workbook->add_worksheet("Software $page");

					$software->activate();
					$software->write( $lineCount, 0,  "HOSTNAME" );
					$software->write( $lineCount, 1,  "MODEL" );
					$software->write( $lineCount, 2,  "SERIAL NUMBER" );
					$software->write( $lineCount, 3,  "SCANTIME" );
					$software->write( $lineCount, 4,  "OS" );
					$software->write( $lineCount, 5,  "OS VERSION" );
					$software->write( $lineCount, 6,  "PROCESSOR COUNT" );
					$software->write( $lineCount, 7,  "CHIP COUNT" );
					$software->write( $lineCount, 8,  "MANUFACTURER" );					
					$software->write( $lineCount, 9,  "SOFTWARE NAME" );
					$software->write( $lineCount, 10,  "PID" );
					$software->write( $lineCount, 11,  "SOFTWARE VERSION" );
					$software->write( $lineCount, 12, "DISCREPANCY TYPE");
					$software->write( $lineCount, 13, "LICENSE" );
					$software->write( $lineCount, 14, "BANK ACCOUNT" );
					$software->write( $lineCount, 15, "SCOPE" );
					$lineCount++;
				}

				my $osNameKey =
				  $bravoSoftware->{$accountNumber}->{$hostname}->{'osName'};
				$productCount->{$osNameKey}->{$softwareName}->{'productCount'}
				  ++;
				$productCount->{$osNameKey}->{$softwareName}->{'license'} =
				  $bravoSoftware->{$accountNumber}->{$hostname}->{'unknown'}
				  ->{$softwareCategory}->{$softwareName}->{'level'};
				$productCount->{$osNameKey}->{$softwareName}->{'softwareManufacturer'} =
				  $bravoSoftware->{$accountNumber}->{$hostname}->{'unknown'}
				  ->{$softwareCategory}->{$softwareName}->{'softwareManufacturer'};
				$productCount->{$osNameKey}->{$softwareName}
				  ->{'processorCount'} +=
				  $bravoSoftware->{$accountNumber}->{$hostname}
				  ->{'processorCount'};
				$productCount->{$osNameKey}->{$softwareName}
				  ->{'chipCount'} +=
				  $bravoSoftware->{$accountNumber}->{$hostname}
				  ->{'chipCount'};
			}
		}
		}
	}

sub createProductCountSheet {

	my $prodCount = $workbook->add_worksheet("Product Count");
	my $pLineCount = 2;
    $prodCount->write( 0, 0,"IBM Confidential" );
	$prodCount->write( 1, 0,
		"REPORT DATE: $month $date, $year $hour:$min:$sec" );
	$prodCount->write( $pLineCount, 0, "CUSTOMER" );
	$prodCount->write( $pLineCount, 1, "OS" );
	$prodCount->write( $pLineCount, 2, "MANUFACTURER" );	
	$prodCount->write( $pLineCount, 3, "SOFTWARE NAME" );
	$prodCount->write( $pLineCount, 4, "LICENSE TYPE" );
	$prodCount->write( $pLineCount, 5, "PRODUCT COUNT" );
	$prodCount->write( $pLineCount, 6, "PROCESSOR COUNT" );
    $prodCount->write( $pLineCount, 7, "CHIP COUNT" );
    
    if(defined $emptyFlag){
    	return;
    }

	$pLineCount++;

	foreach my $osName ( sort keys %{$productCount} ) {
		foreach my $softwareName ( sort keys %{ $productCount->{$osName} } ) {
			$prodCount->write( $pLineCount, 0, $accountNumber );
			$prodCount->write( $pLineCount, 1, $osName );
			$prodCount->write( $pLineCount, 2, $productCount->{$osName}->{$softwareName}->{'softwareManufacturer'} );
			$prodCount->write( $pLineCount, 3, $softwareName );
			$prodCount->write( $pLineCount, 4,
				$productCount->{$osName}->{$softwareName}->{'license'} );
			$prodCount->write( $pLineCount, 5,
				$productCount->{$osName}->{$softwareName}->{'productCount'} );
			$prodCount->write( $pLineCount, 6,
				$productCount->{$osName}->{$softwareName}->{'processorCount'} );
			$prodCount->write( $pLineCount, 7,
				$productCount->{$osName}->{$softwareName}->{'chipCount'} );
			$pLineCount++;
		}
	}
}

sub logit { 
	my ($string, $logfile) = @_ ;
	print $logfile "$string". " ( customer = '$customer')"."\n";
}                                                                            



sub zipFile{
	if ( -e "$reportDir/$accountNumber.xls" ) {
		$zipfile = "$JAR/MULTI.$accountNumber.zip";
		unlink("$zipfile") if ( -e $zipfile );
		my $cmd = "zip -j $zipfile $reportDir/$accountNumber*.xls";
		logit( $cmd, $logFile );
		`$cmd`;
		chmod 0664, $zipfile;
	    unlink <$reportDir/$accountNumber*.xls>;
}}
	
sub sendReportToGSA {

       my $cfg=Config::Properties::Simple->new(file=>$connConfigFile);
       my $server=$cfg->getProperty('gsa.swmulti.report.server');
       my $user=$cfg->getProperty('gsa.swmulti.report.user');
       my $pw=$cfg->getProperty('gsa.swmulti.report.password');
       my $targetFolder = $cfg->getProperty('gsa.swmulti.report.target.folder');
       
       my $ftp = Net::FTP->new($server, Debug => 0, Timeout => 600) or die "Cannot connect.\n";
       $ftp->login($user, $pw) or die "Could not login.\n";
      
       $ftp->cwd($targetFolder) or die "Cannot change working directory.\n";
       my $bin=$ftp->binary or die "Can not change the Type to Binary\n"; 
            
       $ftp->put($zipfile, "MULTI.$accountNumber.zip") or die "Could not upload.\n";
       $ftp->quit;       
    unlink("$zipfile");
}

sub max_sw_version (@) {
    my @aStrings = @_;
    return "" unless ( scalar @aStrings );
    my %hString = ();
    foreach my $String (@aStrings) {
        my ( $Version, $Release ) = split( /\./, $String . "." );
        $hString{$Version}->{$Release}->{$String} = 1;
    }
    my @aResult = ();
    foreach my $Version ( keys %hString ) {
        my @aRelease = keys %{ $hString{$Version} };
        my  $myrelease = scalar @aRelease;
        next unless ( scalar @aRelease == 1 );
        my $Release = $aRelease[0];
        if ( scalar keys %{ $hString{$Version}->{$Release} } == 1 ) {   
            push( @aResult, keys %{ $hString{$Version}->{$Release} } );
            delete( $hString{$Version} );
        }
    }

    foreach my $Version ( sort { $a <=> $b } keys %hString ) {          
        my @aRelease = keys %{ $hString{$Version} };
         my  $myrelease = scalar @aRelease;
        push( @aResult,
            ( scalar @aRelease > 1 )
            ? "$Version.*"
            : "$Version.$aRelease[0].*" );
    }

    return join( ",", sort @aResult );
}

