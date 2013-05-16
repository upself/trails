#!/usr/local/bin/perl -w
#
# This perl script is used to provide a GUI to let person query event information
# Author: liuhaidl@cn.ibm.com 
# Date        Who            Version         Description
# ----------  ------------   -----------     ----------------------------------------------------------------------------
# 2013-04-09  Liu Hai(Larry) 1.0.0           This is the initial version for event query GUI perl script
# 2013-04-10  Liu Hai(Larry) 1.0.1           Add Event Record DB Query Function
# 2013-05-09  Liu Hai(Larry) 1.1.0           Change to query monitor data from Trails DB to Staging DB

#Load required modules
use strict;
use DBI;
use CGI;

BEGIN{
        #fatal handler setting.
        $SIG{__DIE__}=$SIG{__WARN__}=\&handler_fatal;
}

sub handler_fatal {
     print "Content-type: text/html\n\n";
     print "@_";
}

#
# Globals
#
my $DB_SCHEMA = "eaadmin";
#For Tap DB_ENV
my $DB_ENV = '/db2/tap/sqllib/db2profile';
my $DB_STAGING_URL = "dbi:DB2:DATABASE=staging;HOSTNAME=tap.raleigh.ibm.com;PORT=5104;PROTOCOL=TCPIP;";
my $DB_STAGING_USERID = "eaadmin";
my $DB_STAGING_PASSWORD = "apr03db2";
#For Tap2 DB_ENV
#my $DB_ENV = '/home/tap/sqllib/db2profile';
#Staging Testing DB
#my $DB_STAGING_URL = "dbi:DB2:DATABASE=STAGING;HOSTNAME=tap2.raleigh.ibm.com;PORT=50000;PROTOCOL=TCPIP;";
#my $DB_STAGING_USERID = "eaadmin";
#my $DB_STAGING_PASSWORD = "apr03db2";

#Vars Definition
my $cgi;
my $dbh;
my $db_url;
my $db_userid;
my $db_password;
my $TIME_SUFFIX = ".000000";

my @mockEventData = (["1","6744153","2013-04-08-21.19.43.677399","TOTAL_RECORDS_IN_QUEUE","RECON_ENGINE"]
                	,["1","6744100","2013-04-08-21.19.49.791401","TOTAL_RECORDS_IN_QUEUE","RECON_ENGINE"]
					,["1","6733000","2013-04-08-21.19.55.915418","TOTAL_RECORDS_IN_QUEUE","RECON_ENGINE"]
					,["2","1870","2013-04-08-21.19.47.213030","TOTAL_CUSTOMERS_IN_QUEUE","RECON_ENGINE"]
					,["2","1860","2013-04-08-21.19.53.364191","TOTAL_CUSTOMERS_IN_QUEUE","RECON_ENGINE"]
					,["2","1800","2013-04-08-21.19.59.579712","TOTAL_CUSTOMERS_IN_QUEUE","RECON_ENGINE"]
					);

my @TABLE_HEADER_COLUMN_NAMES = ("Event Id","Event Value","Event Time","Event Type Name","Event Group Name");

#SQL Statements
my $GET_EVENT_INFO_SQL  = "SELECT E.EVENT_ID, E.VALUE, E.RECORD_TIME, ET.NAME, EG.NAME
                           FROM EVENT E, EVENT_TYPE ET, EVENT_GROUP EG
						   WHERE E.EVENT_ID = ET.EVENT_ID
						     AND ET.EVENT_GROUP_ID = EG.EVENT_GROUP_ID
						     ORDER BY E.EVENT_ID ASC, E.RECORD_TIME DESC
							 WITH UR";


#Main Order
#1.Invokes init method to do init work
 init();
#2.Process
 process();
 exit 0;

#This method is used to do init work
sub init{
	$cgi = new CGI;
	#Setup DB2 environment
	setupDB2Env();
    #Please note that there is no DB client installed.So the type 3 network db connection method needs to be used. 
	#Staging DB
    $db_url      = $DB_STAGING_URL;
    $db_userid   = $DB_STAGING_USERID;
    $db_password = $DB_STAGING_PASSWORD;
    $dbh = DBI->connect( "$db_url", "$db_userid", "$db_password" ) || die "Connection failed with error: $DBI::errstr";
}

#This method is used to output HTML header
sub outputHtmlHeader{
	print "Content-type: text/html\n\n";
	print "<html>\n";
	print "  <head>\n";  
	print "    <title>Event Query GUI</title>\n";
	addJavascriptCheckUIControlsLogic();
	print "  </head>\n";
	print "  <body>\n";
}

#This method is used to output HTML footer
sub outputHtmlFooter{
    print "  </body>\n";
    print "</html>\n";
}

#This method is used to output HTML detail
sub outputHtmlBody{
  #Define temp vars
  my $eventId = ""; 
  my $eventStartTime = "";
  my $eventEndTime = ""; 

  if(defined $cgi->param("eventID"))
  {
    $eventId = trim($cgi->param("eventID"));
    $eventStartTime = trim($cgi->param("eventStartTime"));#For example: one valid event start time value: 2013-04-10-08:00:00
	$eventEndTime = trim($cgi->param("eventEndTime"));#For example: one valid event end time value: 2013-04-10-09:00:00
  }

  addUIControls();
  #The table header and detailes will be ouput when the event query parameters have valid values
  if($eventId ne "" 
   &&$eventStartTime ne ""
   &&$eventEndTime ne ""){
	print "<font color='blue'>\n";
    print "<b>Input Event ID:</b> $eventId<br>\n";
    print "<b>Input Event Start Time:</b> $eventStartTime<br>\n";
    print "<b>Input Event End Time:</b> $eventEndTime<br><br>\n";
	print "<font size='3'><b>The following is the Event Query Result List</b></font><br>\n";
    print "</font>\n";
    
    outputHtmlTableHeader(\@TABLE_HEADER_COLUMN_NAMES);

    #Process input event start time and event end time parameter values
    $eventStartTime =~ s/\:/\./g;#Replace all the chars ':' to '.' - For example convert from 2013-04-10-08:00:00 to 2013-04-10-08.00.00
	$eventStartTime.= $TIME_SUFFIX;
	$eventEndTime =~ s/\:/\./g;#Replace all the chars ':' to '.' - For example convert from 2013-04-10-09:00:00 to 2013-04-10-09.00.00
	$eventEndTime.= $TIME_SUFFIX;

	my @eventResultSet = exec_sql_rs($dbh
		 ,"SELECT E.EVENT_ID, E.VALUE, E.RECORD_TIME, ET.NAME, EG.NAME
	       FROM EVENT E, EVENT_TYPE ET, EVENT_GROUP EG
           WHERE E.EVENT_ID = ET.EVENT_ID
           AND ET.EVENT_GROUP_ID = EG.EVENT_GROUP_ID
		   AND E.EVENT_ID = $eventId
		   AND E.RECORD_TIME > '$eventStartTime'
		   AND E.RECORD_TIME < '$eventEndTime'
           ORDER BY E.EVENT_ID ASC, E.RECORD_TIME DESC
           WITH UR");
    #outputHtmlTableDetail(\@mockEventData);#For mock event data testing
	outputHtmlTableDetail(\@eventResultSet);
  }
}
  

#This method is used to execute SQL and then return a resultSet array
sub exec_sql_rs {
    my $dbh = shift;
    my $sql = shift;
    my @rs = ();
    eval {
        my $sth = $dbh->prepare($sql);
        $sth->execute();
        #push @rs, [ @{ $sth->{NAME} } ];#Get the db column meta data information
        while (my @row = $sth->fetchrow_array()) {
            push @rs, [ @row ];
        }
        $sth->finish();
    };
    if ($@) {
        $dbh->rollback();
        die "Unable to execute sql command ($sql): $@\n";
    }
    return @rs;
}

#This method is used to output HTML table header
sub outputHtmlTableHeader{
    my $tableHeaderColumnNames = shift;
	print "    <table border = '1' width='100%'>\n";
	print "       <tr bgcolor='lightgray' align='left'>\n";
    for my $i (0 .. $#{$tableHeaderColumnNames}){
     print "        <td>$tableHeaderColumnNames->[$i]</td>\n";
	}
	print "      </tr>\n";
}

#This method is used to add javascript to check UI controls
sub addJavascriptCheckUIControlsLogic{
 #Add javascript logic here
 print "      <script type='text/javascript'>\n";
 print "        function validateEventQueryUIFields(){\n";
 print "          var eventID = document.eventQueryInput.eventID.value;\n";
 print "          var eventStartTime = document.eventQueryInput.eventStartTime.value;\n";
 print "          var eventEndTime = document.eventQueryInput.eventEndTime.value;\n";
 print "          var regEventID = /^[1-9]+[0-9]*]*\$/;//Judge if a positive integer\n";
 print "          var regDateTime = /^(\\d{4})-(\\d{2})-(\\d{2})-(\\d{2}).(\\d{2}).(\\d{2})\$/;//Judge if the date format is YYYY-MM-DD-HH.MM.SS\n";
 print "          if (eventID == null||eventID ==''){\n";
 print "            alert('You must input value for Event ID field.');\n";
 print "            return false;\n";
 print "          }\n";
 print "          else if(!regEventID.test(eventID)){\n";
 print "            alert('You must input postive integer for Event ID field.')\n";
 print "            return false;\n";
 print "          }\n";
 
 print "          if (eventStartTime == null||eventStartTime ==''){\n";
 print "            alert('You must input value for Event Start Time field.');\n";
 print "            return false;\n";
 print "          }\n";
 print "          else if(!regDateTime.test(eventStartTime)){\n";
 print "            alert('You must input value for Event Start Time field using format YYYY-MM-DD-HH.MM.SS')\n";
 print "            return false;\n";
 print "          }\n";
 
 print "         if (eventEndTime == null||eventEndTime ==''){\n";
 print "            alert('You must input value for Event End Time field.');\n";
 print "            return false;\n";
 print "          }\n";
 print "          else if(!regDateTime.test(eventEndTime)){\n";
 print "            alert('You must input value for Event End Time field using format YYYY-MM-DD-HH.MM.SS')\n";
 print "            return false;\n";
 print "          }\n";
 print "          return true;\n";
 print "        }\n"; 
 print "      </script>\n";
}

#This method is used to put UI controls into the event query web page
sub addUIControls{
   print "    <form name='eventQueryInput' method='get' action= '' onsubmit='return validateEventQueryUIFields();'>\n";
   print "      <table border='1px'>\n";
   print "        <tr>\n";
   print "          <td align='right'>Event ID:</td>\n";
   print "          <td align='left'><input type='text' name='eventID' size='20'/>&nbsp;<font color='red'><b>(*)Required Field</b> - Please input integer value for this field. For example: 1</font></td>\n";
   print "        </tr>\n";
   print "        <tr>\n";
   print "          <td align='right'>Event Start Time:</td>\n";
   print "          <td align='left'><input type='text' name='eventStartTime' size='30'/>&nbsp;<font color='red'><b>(*)Required Field</b> - Please input value using format: YYYY-MM-DD-HH:MM:SS for this field. For example: 2013-04-02-01:00:00</font></td></td>\n";
   print "        </tr>\n";
   print "        <tr>\n";
   print "          <td align='right'>Event End Time:</td>\n";
   print "          <td align='left'><input type='text' name='eventEndTime' size='30'/>&nbsp;<font color='red'><b>(*)Required Field</b> - Please input value using format: YYYY-MM-DD-HH:MM:SS for this field. For example: 2013-04-02-03:00:00</font></td></td>\n";
   print "        </tr>\n";
   print "        <tr colspan='2'>\n";
   print "          <td><input type='submit' value='Submit Event Query' style='height:30px;'/></td>\n";
   print "        </tr>\n";
   print "      </table>\n";
   print "    </form>\n"; 
}

#This method is used to output HTML table detail
sub outputHtmlTableDetail{
  my $resultSet = shift;
  for my $i (0 .. $#{$resultSet}){
     print "       <tr align='left'>\n";
	 for my $j (0 .. $#{$resultSet->[$i]}){
	 print "         <td>$resultSet->[$i][$j]</td>\n";
	 }
     print "       </tr>\n";
	}
  print "    </table>\n";
}

#This method is used to do actual business logic
sub process{
  outputHtmlHeader();#output HTML header
  outputHtmlBody();#output HTML detail
  outputHtmlFooter();#output HTML footer
}


#This method is used to setup DB2 environment
sub setupDB2Env {
    die "ERROR: Unable to setup DB2 env !!"
        unless -e "$DB_ENV";
    my @elements = `. $DB_ENV; env`;
    foreach my $elem (@elements) {
        chomp $elem;
        my ($elementKey,$elementVal) = split(/=/, $elem);
        next unless defined($elementKey);
        $ENV{"$elementKey"} = "$elementVal";
    }
    return 1;
}

#This sub trim() method is used to remove before and after space chars of a string
sub trim
{  
   my $trimString = shift;
   if(!defined $trimString)
   {
     $trimString = "";
   }
  
   $trimString =~s/^\s+//;
   $trimString =~s/\s+$//;
   return $trimString;
}