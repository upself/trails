#!/usr/bin/perl -w                                                                       
                                                                                         
###############################################################################          
# (C) COPYRIGHT IBM Corp. 2004                                                           
# All Rights Reserved                                                                    
# Licensed Material - Property of IBM                                                    
# US Government Users Restricted Rights - Use, duplication or                            
# disclosure restricted by GSA ADP Schedule Contract with IBM Corp.                      
###############################################################################          
                                                                                         
###############################################################################          
# Name          : bravoDownloadReport.pl                                                 
# Component     : bravo                                                                  
# Description   : Creates download reports                                               
# Author        : Alex Moise                                                             
# Date          : January 25, 2006                                                       
#                                                                                        
#                      ATTENTION: I live in CVS now!                                     
#       $Source: /cvs/AdHocReports/sw_multi_report/bravoReport.pl,v $                    
#                                                                                        
# $Id: bravoReport.pl,v 1.20 2010/11/19 08:06:54 szshiw Exp $                            
#                                                                                        
# $Log: bravoReport.pl,v $
# Revision 1.20  2010/11/19 08:06:54  szshiw
# add mips, msu to bravo report
#
# Revision 1.19  2010/08/03 08:48:16  szshiw
# convert 0/1 to unlicensable/licensable
#
# Revision 1.18  2010/07/02 20:16:42  dbryson
# SWKBT update
#
# Revision 1.17  2010/06/14 21:27:29  dbryson
# *** empty log message ***
#
# Revision 1.16  2010/01/26 18:52:17  dbryson
# Added serverType
#
# Revision 1.15  2010/01/05 20:31:53  zyizhang
# add 'ibm confidential' at the head of the report.
#
# Revision 1.14  2009/12/10 13:50:41  szshiw
# add hardware chips to the sw multi report
#                                                               
# Revision 1.14  2009/12/09 21:39:22  szshiw                                             
# add hardware chips to the sw multi report                                              
#                                                                                        
# Revision 1.13  2009/12/07 18:24:26  zyizhang                                           
# add scope filed in the spread sheet.                                                   
#                                                                                        
# Revision 1.12  2009/03/10 19:22:17  alexmois                                           
# took out software_lpar_os_info as it has been deprecated                               
#                                                                                        
# Revision 1.11  2008/10/28 22:24:22  cweyl                                              
# - also PUT the resulting zipfile out on am.boulder.ibm.com                             
#                                                                                        
# Revision 1.10  2008/10/24 15:41:34  alexmois                                           
# Change to software_lpar_eff of the bravo multi report query..only want active effective
#                                                                                        
# Revision 1.9  2008/10/16 16:02:49  cweyl                                               
# - includes Toralf Foerster's max_sw_version() for AMT-TI80422-76416.                   
#                                                                                        
# Revision 1.8  2008/10/15 00:23:15  cweyl                                               
# - remove some commented-out cruft                                                      
# - correct how we recurse                                                               
#                                                                                        
# Revision 1.7  2008/10/08 04:38:34  cweyl                                               
# - Now it's really 0664 :-)                                                             
#                                                                                        
# Revision 1.6  2008/10/08 04:36:13  cweyl                                               
# - chmod 0664 the .zip's, not 0775                                                      
#                                                                                        
# Revision 1.5  2008/10/08 04:33:05  cweyl                                               
# - make output destination a test location if the environment variable                  
#   SWMULTI_TEST is set                                                                  
# - strip whitespace from the beginning and end of individual versions *sigh*            
#                                                                                        
# Revision 1.4  2008/10/08 03:53:20  cweyl                                               
# - rework to fit AMT-TI80422-76416 (again)                                              
# - drop all that $bravoConnection stuff.  We didn't need it, and we can now run         
#   from other boxes than tap.raleigh.ibm.com now                                        
# - misc other cleanups (not too many)                                                   
#                                                                                        
# Revision 1.3  2008/10/07 21:44:17  cweyl                                               
# - perltidy to the rescue!  No other changes since the last revision.                   
#                                                                                        
# Revision 1.2  2008/09/29 18:17:38  cweyl                                               
# - alter version field according to AMT-TI80422-76416                                   
# - drop 2 external program calls for compressing/chmod'ing the perms of the             
#   output .zip file                                                                     
# - $VERSION, $REVISION cleanups                                                         
# - add cvs Log and Id tags where they'd be useful                                       
# - update #! line to use /usr/bin/perl, not /usr/local/bin/perl                         
# - add a 'use Tap::NewPerl', so we behave appropriately on tap and other boxes          
#   (not strictly needed right now, but will be useful if we're going to do any          
#   large-scale work redoing this, e.g. with DBIC and Template::Toolkit)                 
#                                                                                        
#                                                                                        
###############################################################################          
our $VERSION  = ( split( / /, q$Revision: 1.20 $ ) )[1];                                 
our $REVISION = '$Id: bravoReport.pl,v 1.20 2010/11/19 08:06:54 szshiw Exp $';           
###############################################################################          
                                                                                         
###############################################################################          
### Use/Require Statements                                                               
###                                                                                      
###############################################################################          
         
# the script may be tested on tap2 and is setup to be loaded into 
# /opt/bravo/scripts/report                                                                                
use Tap::NewPerl;                                                                        
                                                                                         
use strict;                                                                              
                                                                                         
use DBI;                                                                                 
use Getopt::Std;                                                                         
use Readonly;                                                                            
use Sort::Versions;                                                                      
use Spreadsheet::WriteExcel::Big;                                                        
                                                                                         
# for pushing the results                                                                
use File::Slurp qw{ slurp };                                                             
use HTTP::Request::Common;                                                               
use LWP::UserAgent;                                                                      
                                                                                         
# db access                                                                              
use IBM::Schema::BRAVO;                                                                  
                                                                                         
###############################################################################          
### Define Script Variables                                                              
###                                                                                      
###############################################################################          
                                                                                         
use vars qw (                                                                            
  $opt_c                                                                                 
  $logFile                                                                               
  $bravoSoftware                                                                         
  $reportDir                                                                             
  $JAR                                                                                   
);                                                                                       
                                                                                         
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
my $date = $mday + 0;                                                                    
$year = 1900 + $year;                                                                    
my $month = $months[$mon];                                                               
                                                                                         
getopts("c:");                                                                           
                                                                                         
Readonly my $PUT_URI => '/var/bravo/reports/';         
                                                                                         
###############################################################################          
### Set Script Variables                                                                 
###                                                                                      
###############################################################################          
                                                                                         
exit if ( !$opt_c );                                                                     
                                                                                         
# FIXME -- to gsa only for testing                                                       
if ( exists $ENV{SWMULTI_TEST} ) {                                                       
	#run test on tap2.                                                                     
	$reportDir = '/var/bravo/web/sw_vers_test';                                           
	$JAR       = '/var/bravo/web/sw_vers_test';                                           
	$logFile   = '/var/bravo/web/sw_vers_test/log/bravoReport-test.log';                  
	                                                                                       
#	$reportDir = '/gsa/pokgsa/home/c/w/cweyl/web/sw_vers_test';                            
#    $JAR       = '/gsa/pokgsa/home/c/w/cweyl/web/sw_vers_test';                          
#    $logFile   = '/tmp/bravoReport-test.log';                                            
}                                                                                        
else {                                                                                   
	$reportDir = '/opt/IBMIHS/htdocs/en_US/sam/report/bin';                                
	$JAR       = '/opt/IBMIHS/htdocs/en_US/sam/report';                                    
	$logFile   = '/var/bravo/logs/bravoReport.log';                                        
}                                                                                        
                                                                                         
###############################################################################          
### Basic Checks                                                                         
###                                                                                      
###############################################################################          
                                                                                         
sub logit { 
}                                                                            
                                                                                         
logit( "Acquiring bravo database handle", $logFile );                                    
my $bravo = IBM::Schema::SWMULTI->easy_connect;                                            
my $dbh   = $bravo->storage->dbh;                                                        
logit( "Bravo Database handle acquired", $logFile );                                     

###############################################################################
### Main
###
###############################################################################

logit( "Acquiring bravo software", $logFile );
if ($opt_c) {
	eval { $bravoSoftware = &getBravoSoftwareReport( $dbh, $opt_c ); };
	if ($@) {
		logit( $@, $logFile );
		pageit($@);
		die;
	}
	logit( "Bravo software acquired", $logFile );
}
else {
	eval { $bravoSoftware = getBravoSoftwareReport($dbh); };
	if ($@) {
		logit( $@, $logFile );
		pageit($@);
		die;
	}
	logit( "Bravo software acquired", $logFile );
}

undef $bravo;
$dbh->disconnect;
undef $dbh;

my $workbook;

foreach my $accountNumber ( keys %{$bravoSoftware} ) {
	my $lineCount = 2;
	$workbook =
	  Spreadsheet::WriteExcel::Big->new("$reportDir/$accountNumber.xls");
	my $heartbeat = $workbook->add_worksheet("Heartbeat");

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

		chop $hBankAccounts;

		$heartbeat->write( $lineCount, 0, $hostname );
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
		$heartbeat->write( $lineCount, 6,
			$bravoSoftware->{$accountNumber}->{$hostname}->{'osVersion'} );
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
        $heartbeat->write( $lineCount, 12,
            $bravoSoftware->{$accountNumber}->{$hostname}->{'cpuGartnerMIPS'} );
        $heartbeat->write( $lineCount, 13,
            $bravoSoftware->{$accountNumber}->{$hostname}->{'cpuMSU'} );
        $heartbeat->write( $lineCount, 14,
            $bravoSoftware->{$accountNumber}->{$hostname}->{'partMIPS'} );
        $heartbeat->write( $lineCount, 15,
            $bravoSoftware->{$accountNumber}->{$hostname}->{'partGartnerMIPS'} );
        $heartbeat->write( $lineCount, 15,
            $bravoSoftware->{$accountNumber}->{$hostname}->{'partMSU'} );
        $heartbeat->write( $lineCount, 16,
            $bravoSoftware->{$accountNumber}->{$hostname}->{'lparStatus'} );
        $heartbeat->write( $lineCount, 17,
            $bravoSoftware->{$accountNumber}->{$hostname}->{'hardwareStatus'} );
		$lineCount++;
	}
}

foreach my $accountNumber ( keys %{$bravoSoftware} ) {
	my $lineCount  = 2;
	my $pLineCount = 2;
	my $page       = ( int( $lineCount / 60000 ) ) + 1;
	my $software   = $workbook->add_worksheet("Software $page");
	my $productCount;
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
	$software->write( $lineCount, 8,  "SOFTWARE NAME" );
	$software->write( $lineCount, 9,  "SOFTWARE VERSION" );
	$software->write( $lineCount, 10, "DISCREPANCY TYPE");
	$software->write( $lineCount, 11,  "LICENSE" );
	$software->write( $lineCount, 12, "BANK ACCOUNT" );
	$software->write( $lineCount, 13, "SCOPE" );

	$lineCount++;

	foreach my $hostname ( sort keys %{ $bravoSoftware->{$accountNumber} } ) {

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

			$software->write( $lineCount, 0, $hostname );
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
			$software->write( $lineCount, 5,
				$bravoSoftware->{$accountNumber}->{$hostname}->{'osVersion'} );
			$software->write( $lineCount, 6,
				$bravoSoftware->{$accountNumber}->{$hostname}
				  ->{'processorCount'} );
			$software->write( $lineCount, 7,
				$bravoSoftware->{$accountNumber}->{$hostname}
				  ->{'chipCount'} );
			$software->write( $lineCount, 8,
				$bravoSoftware->{$accountNumber}->{$hostname}->{'software'}
				  ->{$softwareCategory}->{'softwareName'} );
			$software->write( $lineCount, 9, $softwareVersions );
			$software->write( $lineCount, 10,
					$bravoSoftware->{$accountNumber}->{$hostname}->{'software'}
				  ->{$softwareCategory}->{'discrepancyType'} );
			$software->write( $lineCount, 11,
				$bravoSoftware->{$accountNumber}->{$hostname}->{'software'}
				  ->{$softwareCategory}->{'level'} );
			$software->write( $lineCount, 12, $bankAccounts );
			$software->write( $lineCount, 13,
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
				$software->write( $lineCount, 8,  "SOFTWARE NAME" );
				$software->write( $lineCount, 9,  "SOFTWARE VERSION" );
				$software->write( $lineCount, 10, "DISCREPANCY TYPE");
				$software->write( $lineCount, 11,  "LICENSE" );
				$software->write( $lineCount, 12, "BANK ACCOUNT" );
				$software->write( $lineCount, 13, "SCOPE" );
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

				$software->write( $lineCount, 0, $hostname );
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
				$software->write( $lineCount, 5,
					$bravoSoftware->{$accountNumber}->{$hostname}
					  ->{'osVersion'} );
				$software->write( $lineCount, 6,
					$bravoSoftware->{$accountNumber}->{$hostname}
					  ->{'processorCount'} );
			    $software->write( $lineCount, 7,
					$bravoSoftware->{$accountNumber}->{$hostname}
					  ->{'chipCount'} );
				$software->write( $lineCount, 8, $softwareName );
				$software->write( $lineCount, 9, $softwareVersions );
				$software->write( $lineCount, 10,
					$bravoSoftware->{$accountNumber}->{$hostname}->{'unknown'}
					->{$softwareCategory}->{$softwareName}->{'discrepancyType'} );
				$software->write( $lineCount, 11,
					$bravoSoftware->{$accountNumber}->{$hostname}->{'unknown'}
					  ->{$softwareCategory}->{$softwareName}->{'level'} );
				$software->write( $lineCount, 12,
					$bravoSoftware->{$accountNumber}->{$hostname}->{'unknown'}
					  ->{$softwareCategory}->{$softwareName}->{'bankAccount'} );
			   $software->write( $lineCount, 13,
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
					$software->write( $lineCount, 8,  "SOFTWARE NAME" );
					$software->write( $lineCount, 9,  "SOFTWARE VERSION" );
					$software->write( $lineCount, 10, "DISCREPANCY TYPE");
					$software->write( $lineCount, 11, "LICENSE" );
					$software->write( $lineCount, 12, "BANK ACCOUNT" );
					$software->write( $lineCount, 13, "SCOPE" );
				}

				my $osNameKey =
				  $bravoSoftware->{$accountNumber}->{$hostname}->{'osName'};
				$productCount->{$osNameKey}->{$softwareName}->{'productCount'}
				  ++;
				$productCount->{$osNameKey}->{$softwareName}->{'license'} =
				  $bravoSoftware->{$accountNumber}->{$hostname}->{'unknown'}
				  ->{$softwareCategory}->{$softwareName}->{'level'};
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

	my $prodCount = $workbook->add_worksheet("Product Count");
     
    $prodCount->write( 0, 0,"IBM Confidential" );
	$prodCount->write( 1, 0,
		"REPORT DATE: $month $date, $year $hour:$min:$sec" );
	$prodCount->write( $pLineCount, 0, "CUSTOMER" );
	$prodCount->write( $pLineCount, 1, "OS" );
	$prodCount->write( $pLineCount, 2, "SOFTWARE NAME" );
	$prodCount->write( $pLineCount, 3, "LICENSE TYPE" );
	$prodCount->write( $pLineCount, 4, "PRODUCT COUNT" );
	$prodCount->write( $pLineCount, 5, "PROCESSOR COUNT" );
    $prodCount->write( $pLineCount, 6, "CHIP COUNT" );

	$pLineCount++;

	foreach my $osName ( sort keys %{$productCount} ) {
		foreach my $softwareName ( sort keys %{ $productCount->{$osName} } ) {
			$prodCount->write( $pLineCount, 0, $accountNumber );
			$prodCount->write( $pLineCount, 1, $osName );
			$prodCount->write( $pLineCount, 2, $softwareName );
			$prodCount->write( $pLineCount, 3,
				$productCount->{$osName}->{$softwareName}->{'license'} );
			$prodCount->write( $pLineCount, 4,
				$productCount->{$osName}->{$softwareName}->{'productCount'} );
			$prodCount->write( $pLineCount, 5,
				$productCount->{$osName}->{$softwareName}->{'processorCount'} );
			$prodCount->write( $pLineCount, 6,
				$productCount->{$osName}->{$softwareName}->{'chipCount'} );
			$pLineCount++;
		}
	}

	$workbook->close();

	my $zipfile;
	if ( -e "$reportDir/$accountNumber.xls" ) {
		$zipfile = "$JAR/MULTI.$accountNumber.zip";
		unlink("$zipfile") if ( -e $zipfile );
		my $cmd = "zip -j $zipfile $reportDir/$accountNumber*.xls";
		logit( $cmd, $logFile );
		`$cmd`;
		chmod 0664, $zipfile;
		unlink <$reportDir/$accountNumber*.xls>;

		# now, push to am.boulder.ibm.com
		my $content = slurp $zipfile;
		my $ua      = LWP::UserAgent->new;
		$ua->request( PUT "$PUT_URI/MULTI.$accountNumber.zip",
			Content => $content, );

	}
	else {
		unlink("$zipfile");
	}
}


#-----------------------------------------------------------------------------

# AMT-TI80422-76416

#
#       Toralf Foerster
#       Hamburg
#       Germany
#

#-----------------------------------------------------------------------------
#
#   input: a list of version strings ('version.release.modification.fixpack')
#   output:a string clobbered the strings into a readable format
#
sub max_sw_version (@) {
    my @aStrings = @_;

    return "" unless ( scalar @aStrings );

    my %hString = ();
    foreach my $String (@aStrings) {
        my ( $Version, $Release ) = split( /\./, $String . "." );
        #return "*" if ( $Version eq "*" );    # rule 1

        $hString{$Version}->{$Release}->{$String} = 1;
    }

    my @aResult = ();
    foreach my $Version ( keys %hString ) {
        my @aRelease = keys %{ $hString{$Version} };

        next unless ( scalar @aRelease == 1 );
        my $Release = $aRelease[0];
        if ( scalar keys %{ $hString{$Version}->{$Release} } == 1 ) {   # rule 2
            push( @aResult, keys %{ $hString{$Version}->{$Release} } );
            delete( $hString{$Version} );
        }
    }

    foreach my $Version ( sort { $a <=> $b } keys %hString ) {          # rule 3
        my @aRelease = keys %{ $hString{$Version} };

        push( @aResult,
            ( scalar @aRelease > 1 )
            ? "$Version.*"
            : "$Version.$aRelease[0].*" );
    }

    return join( ",", sort @aResult );
}


#-----------------------------------------------------------------------------

sub getBravoSoftwareReport {
	my ( $dbh, $customerId ) = @_;

	my $accountNumber;
	my $name;
	my $model;
	my $biosSerial;
	my $processorCount;
	my $chipCount;
	my $scantime;
	my $softwareName;
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
	my $cpuGartnerMIPS
	my $cpuMSU;
	my $partMIPS;
	my $partGartnerMIPS
	my $partMSU;
	my $lparStatus;
	my $hardwareStatus;
	my %data;

	my $query = "
select 				   ol.account_number
                      ,ol.nodename
                      ,ol.model
                      ,ol.bios_serial
                      ,ol.processor_count
                      ,COALESCE(j.chips, 0)
                      ,ol.scantime
                      ,ol.software_name
                      ,ol.level
                      ,ol.priority
                      ,ol.version
                      ,ol.name
                      ,ol.software_category_name
                      ,ol.os_minor_vers
                      ,ol.os_sub_vers
                      ,ol.discrepancy_type
                      ,sc.description
                      ,j.server_type
                      ,j.cpu_mips
                      ,j.cup_gartner_mips
                      ,j.cpu_msu
                      ,i.part_mips
                      ,i.part_gartner_mips
                      ,i.part_msu
                      ,i.lpar_status
                      ,j.hardware_status
from 
                     (select
                      a.customer_id
                      ,b.software_id 
                      ,b.software_lpar_id
                      ,a.account_number
                      ,b.nodename
                      ,b.model
                      ,b.bios_serial
                      ,case
                          when g.processor_count is null or g.status = 'INACTIVE' then b.processor_count
                          else g.processor_count
                       end
                       as processor_count
                      ,b.scantime
                      ,c.name as software_name
                      ,case
                          when pi.licensable=1 then 'LICENSABLE'
                          else 'UN-LICENSABLE'
                       end
                       as level
                      ,pi.priority
                      ,b.version
                      ,d.name
                      ,e.software_category_name
                      ,b.os_minor_vers
                      ,b.os_sub_vers
                      ,f.name as discrepancy_type
                  from
                      eaadmin.customer a
                      ,eaadmin.v_installed_software b
                      left outer join eaadmin.software_lpar_eff g
                          on g.software_lpar_id = b.software_lpar_id
                      ,eaadmin.software_item c
                      ,eaadmin.product_info pi
                      ,eaadmin.bank_account d
                      ,eaadmin.software_category e
                      ,eaadmin.discrepancy_type f
                  where
                      a.customer_id = $customerId
                      and b.software_lpar_status = 'ACTIVE'
                      and b.discrepancy_type_id != 3
                      and b.discrepancy_type_id != 5
                      and b.software_lpar_status = b.inst_status
                      and b.inst_status = e.status
                      and a.customer_id = b.customer_id
                      and b.software_id = c.id
                      and c.id = pi.id
                      and b.bank_account_id = d.id
                      and pi.software_category_id = e.software_category_id
                      and b.discrepancy_type_id = f.id
                     ) as ol 
	      		    left outer join eaadmin.hw_sw_composite h
                        on h.software_lpar_id = ol.software_lpar_id
                    left outer join eaadmin.hardware_lpar i
                        on i.id = h.hardware_lpar_id 
                    left outer join eaadmin.hardware j
                        on j.id = i.hardware_id
                    left outer join eaadmin.schedule_f sf 
                        on ol.customer_id =  sf.customer_id and ol.software_id = sf.software_id
                    left outer join eaadmin.status st
                        on sf.status_id = st.id  and st.description = 'ACTIVE' 
                    left outer join eaadmin.scope sc
                        on sf.scope_id = sc.id 
                    order by priority ASC with ur";

	my $sth = $dbh->prepare($query);
	my $accNumber;
	my $accsth = $dbh->prepare("SELECT account_number from eaadmin.customer where customer_id=$customerId and status='ACTIVE' with ur");
	$accsth->bind_columns(\$accNumber);

	$sth->bind_columns(
		\$accountNumber,   	\$name,           	\$model,
		\$biosSerial,      	\$processorCount, 	\$chipCount,
		\$scantime,        	\$softwareName,   	\$level,          
		\$priority, 	   	\$softwareVersion, 	\$bankAccount,    
		\$softwareCategory,	\$osMinorVers,     	\$osSubVers, 
		\$discrepancyType,     
		\$scopeDescription, \$serverType,       \$cpuMIPS,
		\$cpuGartnerMIPS,
		\$cpuMSU,           \$partMIPS,        \$partGartnerMIPS, 
		\$partMSU,
		\$lparStatus,       \$hardwareStatus
	);

	$sth->execute();
	
    if ($sth->fetchrow_arrayref()){
    
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
		
        
		if ( $softwareCategory eq 'Operating Systems' ) {
			if ( !defined( $data{$accountNumber}{$name}{'osName'} ) ) {
				$data{$accountNumber}{$name}{'osName'}    = $softwareName;
				$data{$accountNumber}{$name}{'osVersion'} = $softwareVersion;
			}
		}
		elsif ( $softwareCategory eq 'UNKNOWN' ) {
			$data{$accountNumber}{$name}{'unknown'}{$softwareCategory}
			  {$softwareName}{'softwareVersion'}{$softwareVersion} = 0;
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
