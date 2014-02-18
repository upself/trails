#!/usr/bin/perl -w
#
# This perl script is used to provide a GUI to let AM support team add operations into Operation Queue 
# Author: liuhaidl@cn.ibm.com 
# Date        Who            Version         Description
# ----------  ------------   -----------     -------------------------------------------------------------------------------------------------------------------
# 2013-07-17  Liu Hai(Larry) 1.0.0           This is the initial version for Operation GUI perl script
#                                            The Operation GUI Design and Implementation
#                                            The basic architecture design and implementation of System Support Component for Operation GUI
# 2013-07-18  Liu Hai(Larry) 1.0.1           Add the 'operationDefinition.properties' operation definition properties Support Feature
# 2013-07-19  Liu Hai(Larry) 1.0.2           Control Dynamically Operation Parameter Fields based on the 'operationDefinition.properties' operation definition
#                                            Operation Parameter Fields Input Value Validation Support Feature
# 2013-07-23  Liu Hai(Larry) 1.0.3           Add 'OPERATION_QUEUE' DB Table Storage Logic Support Feature
# 2013-07-26  Liu Hai(Larry) 1.0.4           Display and Adjust GUI for all the data records of 'OPERATION_QUEUE' DB Table
#                                            1. Add a 'Index #' column which is used to show record number
#                                            2. Add a 'Operation User' column which is used to record operation user. For example: 'liuhaidl@cn.ibm.com'
#                                            3. Remove the 'Operation ID' and 'Operation Name Code' columns from the 'OPERATION_QUEUE' DB HTML Table
# 2013-07-29  Liu Hai(Larry) 1.0.5           1. Add 'Yes/No' Javascript Confirm Panel for 'OPERATION_QUEUE' DB Table Insert Operation   
#                                            2. Add 'OPERATION_QUEUE' DB Table Insert Logic Support Feature
#                                            3. Remove the 'RECORD_TIME' column and then add two new 'OPERATION_ADD_TIME' and 'OPERATION_UPDATE_TIME' columns for the 'OPERATION_QUEUE' DB Table
#                                            Please note that:
#                                              A. The new 'OPERATION_ADD_TIME' DB column is used to record operation added time.
#                                              B. The new 'OPERATION_UPDATE_TIME' DB column is used to record operation updated time. For example: Operation Execution Successful Time or Operation Execution Failed Time
# 2013-08-07  Liu Hai(Larry) 1.0.6           Add Login User Authorization Support Feature
# 2013-08-15  Liu Hai(Larry) 1.0.7           Adjust Operation Queue Table Column to be fixed width
# 2013-08-26  Liu Hai(Larry) 1.0.8           Add the 'operationGUI.properties' properties file Support Feature - For example: server mode 'TAP'
# 2013-08-27  Liu Hai(Larry) 1.0.9           Add 'System Support Operation User Manual' URL Link Support Feature
###################################################################################################################################################################################################
#                                            Phase 3 Development Formal Tag: 'Added by Larry for System Support And Self Healing Service Components - Phase 3'
# 2013-10-12  Liu Hai(Larry) 1.3.0           Adjust Operation Queue Table Data Column to be fixed width
# 2013-10-14  Liu Hai(Larry) 1.3.1           Generate Operation Parameters Input String whatever Operation Parameters have values or not. The Operation Parameters String has included 10 values using ^ char to seperate. For example: TI30326-36768^reconEngine.pl^^^^^^^^
# 2013-11-05  Liu Hai(Larry) 1.3.2           System Support And Self Healing Service Components - Phase 3 - Add the special char '\' support for the Operation Parameters 
###################################################################################################################################################################################################
#                                            Phase 6 Development Formal Tag: 'Added by Larry for System Support And Self Healing Service Components - Phase 6'
# 2014-02-13  Liu Hai(Larry) 1.6.0           Add Operation Parameter Value Type Check Support Feature
#

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

#Globals
my $OPERATION_DEFINITION_FILE = "./operationDefinition.properties";#File 'operationDefinition.properties' Related Path './'
my $OPERATION_GUI_CONFIG_FILE = "./operationGUI.properties";

#SERVER MODE
my $TAP  = "TAP";#TAP Server
my $TAP2 = "TAP2";#TAP2 Server
my $SERVER_MODE;

#Database
my $DB_ENV;
my $dbh;
my $db_url;
my $db_userid;
my $db_password;

#SQL Statement
my $GET_OPERATION_QUEUE_DATA_SQL = "SELECT OPERATION_NAME_DESCRIPTION, OPERATION_PARMS, OPERATION_STATUS, OPERATION_USER, OPERATION_ADD_TIME, OPERATION_UPDATE_TIME, COMMENTS FROM OPERATION_QUEUE ORDER BY OPERATION_ID DESC WITH UR";
my $INSERT_OPERATION_RECORD_SQL = "INSERT INTO OPERATION_QUEUE(OPERATION_NAME_CODE, OPERATION_NAME_DESCRIPTION, OPERATION_PARMS, OPERATION_STATUS, OPERATION_USER, OPERATION_ADD_TIME) VALUES(?,?,?,?,?,CURRENT TIMESTAMP)";

#Vars Definition
my $cgi;

#Comment Char
my $COMMENT_CHAR                              = "#";
#Operation Sequence Prefix Code Definition
my $OPERATION_SEQUENCE_PREFIX_CODE_DEFINITION = "OPT";
my @operationMetaRecords;

#Operation GUI Config File Indexes Definition
my $OPERATION_GUI_CONFIG_LINE_KEY   = 0;
my $OPERATION_GUI_CONFIG_LINE_VALUE = 1;
my $CONFIG_LINE_KEY_SERVER          = "server";

#Operation Meta Data Indexes
my $OPERATION_SEQUENCE_CODE_INDEX         = 0;#For example, "OPT001"
my $OPERATION_GROUP_CODE_INDEX	          = 1;#For example, "LOADER_GROUP"
my $OPERATION_GROUP_DESC_INDEX			  = 2;#For example, "Loader Group"
my $OPERATION_NAME_CODE_INDEX	          = 3;#For example, "RESTART_LOADER"
my $OPERATION_NAME_DESC_INDEX			  = 4;#For example, "Restart Loader"
my $PARAMETER_FIELD_1_INDEX				  = 5;#For example, "Y|Related Ticket Number|CHR|R"
my $PARAMETER_FIELD_2_INDEX				  = 6;#For example, "Y|Related Ticket Number|CHR|R"
my $PARAMETER_FIELD_3_INDEX				  = 7;#For example, "Y|Related Ticket Number|CHR|R"
my $PARAMETER_FIELD_4_INDEX				  = 8;#For example, "Y|Related Ticket Number|CHR|R"
my $PARAMETER_FIELD_5_INDEX				  = 9;#For example, "Y|Related Ticket Number|CHR|R"
my $PARAMETER_FIELD_6_INDEX				  = 10;#For example, "Y|Related Ticket Number|CHR|R"
my $PARAMETER_FIELD_7_INDEX				  = 11;#For example, "Y|Related Ticket Number|CHR|R"
my $PARAMETER_FIELD_8_INDEX				  = 12;#For example, "Y|Related Ticket Number|CHR|R"
my $PARAMETER_FIELD_9_INDEX				  = 13;#For example, "Y|Related Ticket Number|CHR|R"
my $PARAMETER_FIELD_10_INDEX			  = 14;#For example, "Y|Related Ticket Number|CHR|R"
#Operation Parameter Meta Data Indexes
my $PARAMETER_DISPLAY_FLAG_INDEX	      = 0;#Parameter Dispaly Flag: Y or N(Y = Display or N = Hidden). For example: 'Y'
my $PARAMETER_DISPLAY_LABEL_INDEX		  = 1;#Parameter Display Label: Any text is ok. For example: 'Related Ticket Number'
my $PARAMETER_VALUE_TYPE_INDEX			  = 2;#Parameter Value Type: (CHR: String Only, INT: Integter Only, ALL:String and Integer are ok). For example: 'CHR'
my $PARAMETER_REQUIRED_FLAG_INDEX		  = 3;#Parameter Required Flag: R or N(R: Required, N: Non Required). For example: 'R'
#Parameter Dispaly Flag Values
my $PARAMETER_DISPLAY_FLAG_Y_VALUE        = "Y";#Display
my $PARAMETER_DISPLAY_FLAG_N_VALUE        = "N";#Hidden
#Parameter Value Types
my $CHR_VALUE_TYPE                        = "CHR";#String Type
my $INT_VALUE_TYPE                        = "INT";#Integer Type
#Added by Larry for System Support And Self Healing Service Components - Phase 6 Start
my $POSINT_VALUE_TYPE                     = "POSINT";#Positive Integer Type [+0-9]
my $NEGINT_VALUE_TYPE                     = "NEGINT";#Negative Integer Type [-0-9]
my $ANY_VALUE_TYPE                        = "ANY";#Any String,Integer and Specail Chars
#Added by Larry for System Support And Self Healing Service Components - Phase 6 End
#Parameter Required Flag Values
my $PARAMETER_REQUIRED_FLAG_R_VALUE       = "R";#Required
my $PARAMETER_REQUIRED_FLAG_N_VALUE       = "N";#Non Required
#Operation Parameter Field Default Definition
my $OPERATION_PARAMETER_FIELD_DEFAULT_DEFINITION = "N|Default Label|ANY|N";

#Operation Meta Data Vars
my $metaOperationSequenceCode;#For example, "OPT001"
my $metaOperationGroupCode;#For example, "LOADER_GROUP"
my $metaOperationGroupDesc;#For example, "Loader Group"
my $metaOperationNameCode;#For example, "RESTART_LOADER"
my $metaOperationNameDesc;#For example, "Restart Loader"
my $metaOperationParameterField1;#For example, "Y|Related Ticket Number|CHR|R"
my $metaOperationParameterField2;#For example, "Y|Related Ticket Number|CHR|R"
my $metaOperationParameterField3;#For example, "Y|Related Ticket Number|CHR|R"
my $metaOperationParameterField4;#For example, "Y|Related Ticket Number|CHR|R"
my $metaOperationParameterField5;#For example, "Y|Related Ticket Number|CHR|R"
my $metaOperationParameterField6;#For example, "Y|Related Ticket Number|CHR|R"
my $metaOperationParameterField7;#For example, "Y|Related Ticket Number|CHR|R"
my $metaOperationParameterField8;#For example, "Y|Related Ticket Number|CHR|R"
my $metaOperationParameterField9;#For example, "Y|Related Ticket Number|CHR|R"
my $metaOperationParameterField10;#For example, "Y|Related Ticket Number|CHR|R"
#Operation Parameter Meta Data Vars
my $metaOperationParameterDisplayFlag;#Parameter Dispaly Flag: Y or N(Y = Display or N = Hidden). For example: 'Y'
my $metaOperationParameterDisplayLabel;#Parameter Display Label: Any text is ok. For example: 'Related Ticket Number'
my $metaOperationParameterValueType;#Parameter Value Type: (CHR: String Only, INT: Integter Only, ALL:String and Integer are ok). For example: 'CHR'
my $metaOperationParameterRequiredFlag;#Parameter Required Flag: R or N(R: Required, N: Non Required). For example: 'R'

my @OPERATION_QUEUE_TABLE_HEADER_COLUMN_NAMES = ("Index #","Operation Name Description","Operation Parameters","Operation Status","Operation User","Operation Add Time","Operation Update Time","Comments");
#Operation Queue Record Data Indexes
my $OPERATION_QUEUE_OPERATION_NAME_DESC_INDEX   = 0; 
my $OPERATION_QUEUE_OPERATION_PARAMETERS_INDEX  = 1; 
my $OPERATION_QUEUE_OPERATION_STATUS_INDEX      = 2;
my $OPERATION_QUEUE_OPERATION_USER_INDEX        = 3;
my $OPERATION_QUEUE_OPERATION_ADD_TIME_INDEX    = 4;
my $OPERATION_QUEUE_OPERATION_UPDATE_TIME_INDEX = 5;
my $OPERATION_QUEUE_COMMENTS_INDEX              = 6; 

#Operation Status Code List
my $OPERATION_STATUS_ADDED_CODE       = "ADDED";
my $OPERATION_STATUS_PROGRESSING_CODE = "PROGRESSING";
my $OPERATION_STATUS_FAILED_CODE      = "FAILED";
my $OPERATION_STATUS_DONE_CODE        = "DONE";

#Authorized User List
my %authorizedUserList = ();
#AM DEV Team
$authorizedUserList{'liuhaidl@cn.ibm.com'}++;
$authorizedUserList{'dbryson@us.ibm.com'}++;
$authorizedUserList{'kfaler@us.ibm.com'}++;
$authorizedUserList{'zyizhang@cn.ibm.com'}++;
$authorizedUserList{'petr_soufek@cz.ibm.com'}++;
$authorizedUserList{'zhysz@cn.ibm.com'}++;
$authorizedUserList{'bobrutig@us.ibm.com'}++;
$authorizedUserList{'HDRUST@de.ibm.com'}++;
#AM Suppot Team
$authorizedUserList{'gonght@cn.ibm.com'}++;
$authorizedUserList{'evazeng@cn.ibm.com'}++;
$authorizedUserList{'eugen.raceanu@cz.ibm.com'}++;
$authorizedUserList{'martin.kacor@cz.ibm.com'}++;
$authorizedUserList{'adam.trnka@cz.ibm.com'}++;
$authorizedUserList{'zengqh@cn.ibm.com'}++;
$authorizedUserList{'y99xwu@cz.ibm.com'}++;
#Others
$authorizedUserList{'jiri.sterba@cz.ibm.com'}++;

#Invoke loginUserAuthentication method to do login user authentication
loginUserAuthentication();

#This method is used to do login User Authentication
sub loginUserAuthentication{
  
  if(!defined $ENV{'REMOTE_USER'} || $ENV{"REMOTE_USER"} eq ''){
    error();
    exit 0;
  }

  if(!exists $authorizedUserList{$ENV{'REMOTE_USER'}}){
    invalidUserAccess();
    exit 0;
  }
}

#Invoke the main method of Operation GUI
main();

#This is the main method of Operation GUI
sub main{
  init();
  process();
  postProcess();
}

#This method is used to do init operations
sub init{
  $cgi = new CGI;
  
  #Get Server Mode - For example: 'TAP'
  $SERVER_MODE = getServerMode($OPERATION_GUI_CONFIG_FILE);

  #set db2 env path
  setDB2ENVPath();

  #Setup DB2 environment
  setupDB2Env();
  
  #Set DB Connection Information
  setDBConnInfo();

  $dbh = DBI->connect($db_url, $db_userid, $db_password) || die "Connection failed with error: $DBI::errstr";

  #Load Operation Definition Metadata
  loadOperationDefinitionMetadata($OPERATION_DEFINITION_FILE);
}

#This method is used to load operation definition metadata
sub loadOperationDefinitionMetadata{
  #Add logic here  
  my $operationDefinitionFile= shift;
  
  open(OPERATION_DEFINITION_FILE_HANDLER, "<", $operationDefinitionFile ) or die "Operation Definition File {$operationDefinitionFile} doesn't exist. Perl script exits due to this reason.";
  while (my $operationDefinitionConfigLine = <OPERATION_DEFINITION_FILE_HANDLER>) {
    $operationDefinitionConfigLine = trim($operationDefinitionConfigLine);
    #Get the first char of a string
	my $strFirstChar = substr($operationDefinitionConfigLine,0,1);
	#Bypass comment line
    if($strFirstChar eq $COMMENT_CHAR){
	  next;
	}

    #Get the first three chars of a string
	my $strCode = substr($operationDefinitionConfigLine,0,3);
	
    #Judge if operation definition line
	if($strCode eq $OPERATION_SEQUENCE_PREFIX_CODE_DEFINITION){#Operation Sequence Prefix Code "OPT"
	  #Split operation definition line using '^' char
	  my @operationMetaRecord = split(/\^/,$operationDefinitionConfigLine);
      push @operationMetaRecords, [@operationMetaRecord];
  	}#end while (my $operationDefinitionConfigLine = <OPERATION_DEFINITION_FILE_HANDLER>)
  }
  close OPERATION_DEFINITION_FILE_HANDLER;
}

#This method is used to do Operation Business Process
sub process{
  generateOperationGUI();
}

#This method is used to do Operation Business Post Process for example, close db handlers, close file handers etc
sub postProcess{
	#Disconnect DB
	$dbh->disconnect();
}

#This method is used to generate Operation GUI
sub generateOperationGUI{
  print "Content-type: text/html\n\n";
  print "<html>\n";
  print "  <head>\n";
  print "     <title>Operation Support GUI</title>\n";
  #Add Javascript Logic for Operation GUI
  addJavascriptLogic();
  print "  </head>\n";
  print "  <body onload='load();'>\n";
  #Print Server Mode
  #printServerMode();#For Server Mode Testing Purpose
  print "    <form id='operationInputFormId' name='operationInputForm' method='post' action= ''>\n";
  #Add UI Widgets for Operation GUI
  addUIWidgets();
  #Print out the Operation Metadata Definition
  #printOperationMetadataDefinition();#For funciton testing using purpose
  #Print out the Operation and Parameter Fields Input Values
  #printOperationAndParameterFieldsInputValues();#For funciton testing using purpose
  #Insert Operation Record
  insertOperationRecord();
  #Print out the Operation Queue Table Data
  printOperationQueueTableData();
  print "    </form>\n";
  print "  </body> \n";
  print "</html>\n";
}
#This method is used to add javascript logic
sub addJavascriptLogic{
  #Add javascript logic here
  print "      <script type='text/javascript'>\n";
  print "        //Vars Definition\n";
  print "        //Operation Parameter Meta Data Indexes\n";
  print "        var PARAMETER_DISPLAY_FLAG_INDEX	 = 0;//Parameter Dispaly Flag: Y or N(Y = Display or N = Hidden). For example: 'Y'\n";
  print "        var PARAMETER_DISPLAY_LABEL_INDEX	 = 1;//Parameter Display Label: Any text is ok. For example: 'Related Ticket Number'\n";
  print "        var PARAMETER_VALUE_TYPE_INDEX	     = 2;//Parameter Value Type: (CHR: String Only, INT: Integter Only, ANY:Any String,Integer and Specail Chars). For example: 'CHR'\n";
  print "        var PARAMETER_REQUIRED_FLAG_INDEX   = 3;//Parameter Required Flag: R or N(R: Required, N: Non Required). For example: 'R'\n";
  print "        //Parameter Dispaly Flag Values\n";
  print "        var PARAMETER_DISPLAY_FLAG_Y_VALUE  = 'Y';//Display\n";
  print "        var PARAMETER_DISPLAY_FLAG_N_VALUE  = 'N';//Hidden\n";
  print "        //Parameter Value Types\n";
  print "        var CHR_VALUE_TYPE                  = 'CHR';//String Type - [a-zA-Z]\n";
  print "        var INT_VALUE_TYPE                  = 'INT';//Integer Type - [0-9]\n";
  print "        //Added by Larry for System Support And Self Healing Service Components - Phase 6 Start\n";
  print "        var POSINT_VALUE_TYPE               = 'POSINT';//Positive Integer Type - [+0-9]\n";
  print "        var NEGINT_VALUE_TYPE               = 'NEGINT';//Negative Integer Type - [-0-9]\n";
  print "        var ANY_VALUE_TYPE                  = 'ANY';//Any String,Integer and Specail Chars\n";
  print "        //Added by Larry for System Support And Self Healing Service Components - Phase 6 End\n";
  print "        //Parameter Required Flag Values\n";
  print "        var PARAMETER_REQUIRED_FLAG_R_VALUE = 'R';//Required\n";
  print "        var PARAMETER_REQUIRED_FLAG_N_VALUE = 'N';//Non Required\n";
  print "        //Operation Parameter Meta Data Vars\n";
  print "        var metaOperationParameterDisplayFlag;//Parameter Dispaly Flag: Y or N(Y = Display or N = Hidden). For example: 'Y'\n";
  print "        var metaOperationParameterDisplayLabel;//Parameter Display Label: Any text is ok. For example: 'Related Ticket Number'\n";
  print "        var metaOperationParameterValueType;//Parameter Value Type: (CHR: String Only, INT: Integter Only, ANY:Any String,Integer and Specail Chars). For example: 'CHR'\n";
  print "        var metaOperationParameterRequiredFlag;//Parameter Required Flag: R or N(R: Required, N: Non Required). For example: 'R'\n";
  print "        //Tr Default Prefix Definition\n";
  print "        var TR_PARM_FLD                     = 'tr_parm_fld'\n";
  print "        var PARM_LAB                        = 'parm_lab'\n";
  print "        var PARM_FLD                        = 'parm_fld'\n";
  print "        var ASTERISK_PREFIX                 = '(*)'\n";
  print "                                                                                                                                                        \n";
  print "        function setTRParameterFieldDisplay(tr_parm_fld_id,displayFlagValue){\n";
  print "          if(displayFlagValue==PARAMETER_DISPLAY_FLAG_Y_VALUE){\n";
  print "            document.getElementById(tr_parm_fld_id).style.display='';\n";
  print "          }\n";
  print "          else{\n";
  print "            document.getElementById(tr_parm_fld_id).style.display='none';\n";  
  print "          }\n";
  print "        }\n";
  print "                                                                                                                                                        \n";
  print "        function setParameterLabel(parm_lab_id,fieldLabelValue){\n";
  print "            document.getElementById(parm_lab_id).innerHTML=fieldLabelValue+':';\n";
  print "        }\n";
  print "                                                                                                                                                        \n";
  print "        function changeOperationSelectListObject(){\n";
  print "          var operationSelectListObject = document.getElementById('operationList');\n";
  print "          var operationParameterFieldsDefinition = operationSelectListObject.options[operationSelectListObject.selectedIndex].value;\n";
  print "          setOperationParameterFields(operationParameterFieldsDefinition);\n";
  print "          clearOperationParameterInputFieldValues();//Clear Operation Parameter Input Field Values\n";
  print "        }\n";
  print "                                                                                                                                                        \n";
  print "        function setOperationParameterFields(operationParameterFieldsDefinition){\n";
  print "          var operationParameterFieldsDefinition = operationParameterFieldsDefinition;\n";
  print "          var operationParameterFieldsArray = operationParameterFieldsDefinition.split('^');\n";
  print "          for(var i=2; i<operationParameterFieldsArray.length; i++){\n";
  print "            var operationParameterField = operationParameterFieldsArray[i];\n";
  print "            var operationParameterFieldArray = operationParameterField.split('|');\n";
  print "            var operationParameterLabelValue = '';\n";
  print "            for(var j=0; j<operationParameterFieldArray.length; j++){\n";
  print "              if(j == PARAMETER_DISPLAY_FLAG_INDEX){\n";
  print "                var parameterDisplayFlagValue = operationParameterFieldArray[j];\n";
  print "                var trIndex = i-1;\n";
  print "                var trParameterFieldId = TR_PARM_FLD+trIndex;\n";  
  print "                setTRParameterFieldDisplay(trParameterFieldId,parameterDisplayFlagValue);\n";
  print "              }//end if(j == PARAMETER_DISPLAY_FLAG_INDEX)\n";
  print "              else if(j == PARAMETER_DISPLAY_LABEL_INDEX){\n";
  print "                var parameterLabelValue = operationParameterFieldArray[j];\n";
  print "                operationParameterLabelValue = parameterLabelValue;\n";
  print "              }//end else if(j == PARAMETER_DISPLAY_LABEL_INDEX)\n";
  print "              else if(j == PARAMETER_REQUIRED_FLAG_INDEX){\n";
  print "                var parameterRequiredFlag = operationParameterFieldArray[j];\n";
  print "                var parameterLabelId = PARM_LAB+trIndex;\n";
  print "                if(parameterRequiredFlag == PARAMETER_REQUIRED_FLAG_R_VALUE){\n";
  print "                  operationParameterLabelValue = '<font color=\"red\"><b>'+ASTERISK_PREFIX+'</b></font>'+operationParameterLabelValue;\n";
  print "                }\n";
  print "                setParameterLabel(parameterLabelId,operationParameterLabelValue);\n";
  print "              }//end else if(j == PARAMETER_REQUIRED_FLAG_INDEX)\n";
  print "            }//end for(var j=0; j<operationParameterFieldArray.length; j++)\n";
  print "          }//end for(var i=2; i<operationParameterFieldsArray.length; i++)\n";
  print "        }\n";
  print "                                                                                                                                                        \n";
  print "        function load(){\n";
  print "          //Load Default Operation Definition\n";
  print "          changeOperationSelectListObject();\n";
  print "        }\n";
  print "                                                                                                                                                        \n";
  print "        function validateOperationUIFields(){\n";
  print "          var operationSelectListObject = document.getElementById('operationList');\n";
  print "          var operationParameterFieldsDefinition = operationSelectListObject.options[operationSelectListObject.selectedIndex].value;\n";
  print "          //alert('Operation Defintion ->'+operationParameterFieldsDefinition);//For function testing using purpose\n";
  print "          var operationParameterFieldsArray = operationParameterFieldsDefinition.split('^');\n";
  print "          for(var i=2; i<operationParameterFieldsArray.length; i++){\n";
  print "            var operationParameterField = operationParameterFieldsArray[i];\n";
  print "            var operationParameterFieldArray = operationParameterField.split('|');\n";
  print "            var operationParameterDisplayFlag;\n";
  print "            var operationParameterLabelValue;\n";
  print "            var operationParameterValueType;//Added by Larry for System Support And Self Healing Service Components - Phase 6\n";
  print "            var operationParameterRequiredFlag;\n";
  print "            var operationParameterInputFieldObject;\n";
  print "            var operationParameterInputFieldValue;\n";
  print "            for(var j=0; j<operationParameterFieldArray.length; j++){\n";
  print "              if(j == PARAMETER_DISPLAY_FLAG_INDEX){\n";
  print "                var parameterDisplayFlagValue = operationParameterFieldArray[j];\n";
  print "                if(parameterDisplayFlagValue == PARAMETER_DISPLAY_FLAG_Y_VALUE){\n";
  print "                  operationParameterDisplayFlag = true;\n";
  print "                }//end if(parameterDisplayFlagValue == PARAMETER_DISPLAY_FLAG_Y_VALUE)\n";
  print "                else{\n";
  print "                  operationParameterDisplayFlag = false;\n";
  print "                }//end else\n";
  print "              }//end if(j == PARAMETER_DISPLAY_FLAG_INDEX)\n";
  print "              else if(j == PARAMETER_DISPLAY_LABEL_INDEX){\n";
  print "                operationParameterLabelValue = operationParameterFieldArray[j];\n";
  print "              }//end else if(j == PARAMETER_DISPLAY_LABEL_INDEX)\n";
  print "              //Added by Larry for System Support And Self Healing Service Components - Phase 6 Start\n";
  print "              else if(j == PARAMETER_VALUE_TYPE_INDEX){\n";
  print "                operationParameterValueType = operationParameterFieldArray[j];\n";
  print "              }//end else if(j == PARAMETER_VALUE_TYPE_INDEX)\n";
  print "              //Added by Larry for System Support And Self Healing Service Components - Phase 6 End\n";
  print "              else if(j == PARAMETER_REQUIRED_FLAG_INDEX){\n";
  print "                var parameterRequiredFlagValue = operationParameterFieldArray[j];\n";
  print "                if(parameterRequiredFlagValue == PARAMETER_REQUIRED_FLAG_R_VALUE){\n";
  print "                  operationParameterRequiredFlag = true;\n";
  print "                }//end if(parameterRequiredFlagValue == PARAMETER_REQUIRED_FLAG_R_VALUE)\n";
  print "                else{\n";
  print "                  operationParameterRequiredFlag = false;\n";
  print "                }//end else\n";
  print "              }//end else if(j == PARAMETER_REQUIRED_FLAG_INDEX)\n";
  print "            }//end for(var j=0; j<operationParameterFieldArray.length; j++)\n";
  print "                                                                                                                                                        \n";
  print "            var trIndex = i-1;\n";
  print "            operationParameterInputFieldObject = document.getElementById(PARM_FLD+trIndex);\n";
  print "            operationParameterInputFieldValue = operationParameterInputFieldObject.value;\n";
  print "            //alert('Operation Parameter['+trIndex+'] Input Value: {'+operationParameterInputFieldValue+'}');\n";
  print "            if((operationParameterInputFieldValue == '') && (operationParameterDisplayFlag == true) && (operationParameterRequiredFlag == true)){\n";
  print "              alert('You must input value for {'+operationParameterLabelValue+'} field.');\n";
  print "              operationParameterInputFieldObject.focus();//Set focus if there is no input value for operation parameter input field\n";
  print "              return false;\n";
  print "            }//end if((operationParameterInputFieldValue == '') && (operationParameterDisplayFlag == true) && (operationParameterRequiredFlag == true))\n";
  print "            //Added by Larry for System Support And Self Healing Service Components - Phase 6 Start\n";
  print "            if((operationParameterInputFieldValue != '') && (operationParameterDisplayFlag == true)){\n";
  print "              if((operationParameterValueType == INT_VALUE_TYPE) && (/^[0-9]+\$/.test(operationParameterInputFieldValue) == false)){\n";
  print "                alert('You must input integer [0-9] for {'+operationParameterLabelValue+'} field.');\n";
  print "                operationParameterInputFieldObject.focus();//Set focus if the input value is not integer [0~9] for operation parameter input field\n";
  print "                return false;\n";
  print "              }//end if((operationParameterValueType == INT_VALUE_TYPE) && (/^[0-9]+\$/.test(operationParameterInputFieldValue) == false))\n";
  print "              if((operationParameterValueType == POSINT_VALUE_TYPE) && (/^\\+?[1-9][0-9]*\$/.test(operationParameterInputFieldValue) == false)){\n";
  print "                alert('You must input positive integer for {'+operationParameterLabelValue+'} field.');\n";
  print "                operationParameterInputFieldObject.focus();//Set focus if the input value is not positive integer for operation parameter input field\n";
  print "                return false;\n";
  print "              }//end if((operationParameterValueType == POSINT_VALUE_TYPE) && (/^\\+?[1-9][0-9]*\$/.test(operationParameterInputFieldValue) == false))\n";
  print "              if((operationParameterValueType == NEGINT_VALUE_TYPE) && (/^\\-[1-9][0-9]*\$/.test(operationParameterInputFieldValue) == false)){\n";
  print "                alert('You must input negative integer for {'+operationParameterLabelValue+'} field.');\n";
  print "                operationParameterInputFieldObject.focus();//Set focus if the input value is not negative integer for operation parameter input field\n";
  print "                return false;\n";
  print "              }//end if((operationParameterValueType == NEGINT_VALUE_TYPE) && (/^\\-[1-9][0-9]*\$/.test(operationParameterInputFieldValue) == false))\n";
  print "              if((operationParameterValueType == CHR_VALUE_TYPE) && (/^[A-Za-z]+\$/.test(operationParameterInputFieldValue) == false)){\n";
  print "                alert('You must input char [a-zA-Z] for {'+operationParameterLabelValue+'} field.');\n";
  print "                operationParameterInputFieldObject.focus();//Set focus if the input value is not char [a-zA-Z] for operation parameter input field\n";
  print "                return false;\n";
  print "              }//end if((operationParameterValueType == CHR_VALUE_TYPE) && (/^[A-Za-z]+\$/.test(operationParameterInputFieldValue) == false))\n";
  print "            }//end if((operationParameterInputFieldValue != '') && (operationParameterDisplayFlag == true))\n";
  print "            //Added by Larry for System Support And Self Healing Service Components - Phase 6 End\n";
  print "          }//end for(var i=2; i<operationParameterFieldsArray.length; i++)\n";
  print "          return true;\n";
  print "        }\n";
  print "                                                                                                                                                        \n";
  print "        function clearOperationParameterInputFieldValues(){\n";
  print "          var operationParameterInputFieldObject;\n";
  print "          for(var i=1; i<=10; i++){\n";
  print "            operationParameterInputFieldObject = document.getElementById(PARM_FLD+i);\n";
  print "            operationParameterInputFieldObject.value = '';//Reset operation parameter input field value to empty string\n";
  print "          }\n";
  print "        }\n";
  print "                                                                                                                                                        \n";
  print "        function confirmYesNo(){\n";
  print "          var addConfirmFlag=confirm(\"Do you confirm to add Operation into Operation Queue?\");\n";
  print "          if(addConfirmFlag){\n";
  print "            var valiateUIFieldsResultFlag =  validateOperationUIFields();\n";
  print "            if(valiateUIFieldsResultFlag == true){\n";
  print "              var operationFormObject = document.getElementById('operationInputFormId');\n";
  print "              operationFormObject.submit();//Submit Form Manually\n";
  print "            }\n";
  print "          }\n";
  print "        }\n";
  print "                                                                                                                                                        \n";
  print "      </script>\n";
}

#This method is used to add UI widgets
sub addUIWidgets{
  print "    <font color='red' size='5'><i>Please note that the <b>'Operation Support GUI'</b> is used for support team to fix usual Trails/Bravo System Maintenance Issue Fix Work!!!</i></font><br>\n";
  print "    <font color='blue' size='5'><a href='https://w3-connections.ibm.com/wikis/home?lang=en#!/wiki/Asset%20Management%20Support/page/System%20Support%20Operation%20User%20Manual' target=_blank><i><b>Please refer 'System Support Operation User Manual' for more detailed information</b></i></a></font><br>\n";
  print "    <font color='red' size='4'><i>Fields marked with an asterisk <b>(*)</b> are required!</i></font><br>\n";
  print "    <table width='50%' border='1'>\n";
  print "      <tr bgcolor='#FCFCFC'>\n";
  print "        <td style='font-weight: bolder;' width='25%' align='right'><label for='operation_fld'>Operation:</label></td>\n";
  print "        <td>\n";
  print "          <select id='operationList' name='operationListName' style='width:350px;height:25px;' onchange='changeOperationSelectListObject()'>\n";
  addOperationListValues();#Add Operation Values into Operation 'Select' object
  print "          </select>\n";
  print "        </td>\n";
  print "      </tr>\n";
  print "      <tr id='tr_parm_fld1'>\n";
  print "        <td style='font-weight: bolder;' width='25%' align='right'><label id='parm_lab1' for='parm_fld1'>Parameter 1:</label></td>\n";
  print "        <td><input type='text' id='parm_fld1' name='parm_fld1_name' style='width:260px;height:25px;'/></td>\n";
  print "      </tr>\n";
  print "      <tr bgcolor='#FCFCFC' id='tr_parm_fld2'>\n";
  print "        <td style='font-weight: bolder;' width='25%' align='right'><label id='parm_lab2' for='parm_fld2'>Parameter 2:</label></td>\n";
  print "        <td><input type='text' id='parm_fld2' name='parm_fld2_name' style='width:260px;height:25px;'/></td>\n";
  print "      </tr>\n";
  print "      <tr id='tr_parm_fld3'>\n";
  print "        <td style='font-weight: bolder;' width='25%' align='right'><label id='parm_lab3' for='parm_fld3'>Parameter 3:</label></td>\n";
  print "        <td><input type='text' id='parm_fld3' name='parm_fld3_name' style='width:260px;height:25px;'/></td>\n";
  print "      </tr>\n";
  print "      <tr bgcolor='#FCFCFC' id='tr_parm_fld4'>\n";
  print "        <td style='font-weight: bolder;' width='25%' align='right'><label id='parm_lab4' for='parm_fld4'>Parameter 4:</label></td>\n";
  print "        <td><input type='text' id='parm_fld4' name='parm_fld4_name' style='width:260px;height:25px;'/></td>\n";
  print "      </tr>\n";
  print "      <tr id='tr_parm_fld5'>\n";
  print "        <td style='font-weight: bolder;' width='25%' align='right'><label id='parm_lab5' for='parm_fld5'>Parameter 5:</label></td>\n";
  print "        <td><input type='text' id='parm_fld5' name='parm_fld5_name' style='width:260px;height:25px;'/></td>\n";
  print "      </tr>\n";
  print "      <tr bgcolor='#FCFCFC' id='tr_parm_fld6'>\n";
  print "        <td style='font-weight: bolder;' width='25%' align='right'><label id='parm_lab6' for='parm_fld6'>Parameter 6:</label></td>\n";
  print "        <td><input type='text' id='parm_fld6' name='parm_fld6_name' style='width:260px;height:25px;'/></td>\n";
  print "      </tr>\n";
  print "      <tr id='tr_parm_fld7'>\n";
  print "        <td style='font-weight: bolder;' width='25%' align='right'><label id='parm_lab7' for='parm_fld7'>Parameter 7:</label></td>\n";
  print "        <td><input type='text' id='parm_fld7' name='parm_fld7_name' style='width:260px;height:25px;'/></td>\n";
  print "      </tr>\n";
  print "      <tr bgcolor='#FCFCFC' id='tr_parm_fld8'>\n";
  print "        <td style='font-weight: bolder;' width='25%' align='right'><label id='parm_lab8' for='parm_fld8'>Parameter 8:</label></td>\n";
  print "        <td><input type='text' id='parm_fld8' name='parm_fld8_name' style='width:260px;height:25px;'/></td>\n";
  print "      </tr>\n";
  print "      <tr id='tr_parm_fld9'>\n";
  print "        <td style='font-weight: bolder;' width='25%' align='right'><label id='parm_lab9' for='parm_fld9'>Parameter 9:</label></td>\n";
  print "        <td><input type='text' id='parm_fld9' name='parm_fld9_name' style='width:260px;height:25px;'/></td>\n";
  print "      </tr>\n";
  print "      <tr bgcolor='#FCFCFC' id='tr_parm_fld10'>\n";
  print "        <td style='font-weight: bolder;' width='25%' align='right'><label id='parm_lab10' for='parm_fld10'>Parameter 10:</label></td>\n";
  print "        <td><input type='text' id='parm_fld10' name='parm_fld10_name' style='width:260px;height:25px;'/></td>\n";
  print "      </tr>\n";
  print "      <tr>\n";
  print "        <td></td>\n";
  print "        <td><input type='button' name='add' value='Add' style='width:150px;height:35px;' onclick='confirmYesNo();'/>&nbsp;&nbsp;&nbsp;\n";
  print "            <input type='button' name='cancel' value='Reset' style='width:150px;height:35px;' onclick='clearOperationParameterInputFieldValues();'/>\n";
  print "        </td>\n";
  print "      </tr>\n";
  print "    </table><br>\n";
}

#This method is used to print out operation metadata defintion 
sub printOperationMetadataDefinition{
   print "<table width='100%' border='1'>\n";
   #Print out the Operation Metadata Column Names
   print "  <tr bgcolor='#FCFCFC'>\n";
   print "    <td>Operation Sequence Code</td>\n";
   print "    <td>Operation Group Code</td>\n";
   print "    <td>Operation Group Description</td>\n";
   print "    <td>Operation Name Code</td>\n";
   print "    <td>Operation Name Description</td>\n";
   print "    <td>Parameter Field 1</td>\n";
   print "    <td>Parameter Field 2</td>\n";
   print "    <td>Parameter Field 3</td>\n";
   print "    <td>Parameter Field 4</td>\n";
   print "    <td>Parameter Field 5</td>\n";
   print "    <td>Parameter Field 6</td>\n";
   print "    <td>Parameter Field 7</td>\n";
   print "    <td>Parameter Field 8</td>\n";
   print "    <td>Parameter Field 9</td>\n";
   print "    <td>Parameter Field 10</td>\n";
   print "  </tr>\n";

   my $count = scalar(@operationMetaRecords);
   print "Operation Record Count: {$count}<br>\n";

   foreach my $metaOperation (@operationMetaRecords){#Go loop operation metadata definition
          $metaOperationSequenceCode = trim($metaOperation->[$OPERATION_SEQUENCE_CODE_INDEX]);#Remove space chars
	      $metaOperationGroupCode = trim($metaOperation->[$OPERATION_GROUP_CODE_INDEX]);#Remove space chars
          $metaOperationGroupDesc = trim($metaOperation->[$OPERATION_GROUP_DESC_INDEX]);#Remove space chars
          $metaOperationNameCode = trim($metaOperation->[$OPERATION_NAME_CODE_INDEX]);#Remove space chars
		  $metaOperationNameDesc = trim($metaOperation->[$OPERATION_NAME_DESC_INDEX]);#Remove space chars
          $metaOperationParameterField1 = trim($metaOperation->[$PARAMETER_FIELD_1_INDEX]);#Remove space chars
		  $metaOperationParameterField2 = trim($metaOperation->[$PARAMETER_FIELD_2_INDEX]);#Remove space chars
		  $metaOperationParameterField3 = trim($metaOperation->[$PARAMETER_FIELD_3_INDEX]);#Remove space chars
          $metaOperationParameterField4 = trim($metaOperation->[$PARAMETER_FIELD_4_INDEX]);#Remove space chars
          $metaOperationParameterField5 = trim($metaOperation->[$PARAMETER_FIELD_5_INDEX]);#Remove space chars
		  $metaOperationParameterField6 = trim($metaOperation->[$PARAMETER_FIELD_6_INDEX]);#Remove space chars
		  $metaOperationParameterField7 = trim($metaOperation->[$PARAMETER_FIELD_7_INDEX]);#Remove space chars
		  $metaOperationParameterField8 = trim($metaOperation->[$PARAMETER_FIELD_8_INDEX]);#Remove space chars
		  $metaOperationParameterField9 = trim($metaOperation->[$PARAMETER_FIELD_9_INDEX]);#Remove space chars
		  $metaOperationParameterField10 = trim($metaOperation->[$PARAMETER_FIELD_10_INDEX]);#Remove space chars 
      
	  #Print out the Operation Metadata Column Values
	  print "  <tr>\n";
      print "    <td>$metaOperationSequenceCode</td>\n";
      print "    <td>$metaOperationGroupCode</td>\n";
	  print "    <td>$metaOperationGroupDesc</td>\n";
	  print "    <td>$metaOperationNameCode</td>\n";
	  print "    <td>$metaOperationNameDesc</td>\n";
	  print "    <td>$metaOperationParameterField1</td>\n";
      print "    <td>$metaOperationParameterField2</td>\n";
	  print "    <td>$metaOperationParameterField3</td>\n";
	  print "    <td>$metaOperationParameterField4</td>\n";
	  print "    <td>$metaOperationParameterField5</td>\n";
	  print "    <td>$metaOperationParameterField6</td>\n";
	  print "    <td>$metaOperationParameterField7</td>\n";
	  print "    <td>$metaOperationParameterField8</td>\n";
	  print "    <td>$metaOperationParameterField9</td>\n";
	  print "    <td>$metaOperationParameterField10</td>\n";
	  print "  </tr>\n";
   }
   print "</table><br>\n";
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

#This method is used to add Operation List Values into 'Select' object
sub addOperationListValues{
  my $optionIndex = 0;
  foreach my $metaOperation (@operationMetaRecords){#Go loop operation metadata definition
	my $metaOperationParameterFieldsDefinition = "";
    $metaOperationNameCode = trim($metaOperation->[$OPERATION_NAME_CODE_INDEX]);#Remove space chars
    $metaOperationParameterFieldsDefinition.= $metaOperationNameCode;
    
	$metaOperationNameDesc = trim($metaOperation->[$OPERATION_NAME_DESC_INDEX]);#Remove space chars
	$metaOperationParameterFieldsDefinition.= "^";
    $metaOperationParameterFieldsDefinition.= $metaOperationNameDesc;
	
    $metaOperationParameterField1 = trim($metaOperation->[$PARAMETER_FIELD_1_INDEX]);#Remove space chars
	if($metaOperationParameterField1 ne ""){
	  $metaOperationParameterFieldsDefinition.= "^";
	  $metaOperationParameterFieldsDefinition.= $metaOperationParameterField1;
	}
	else{
	  $metaOperationParameterFieldsDefinition.= "^";
	  $metaOperationParameterFieldsDefinition.= $OPERATION_PARAMETER_FIELD_DEFAULT_DEFINITION;
	}

    $metaOperationParameterField2 = trim($metaOperation->[$PARAMETER_FIELD_2_INDEX]);#Remove space chars
	if($metaOperationParameterField2 ne ""){
	  $metaOperationParameterFieldsDefinition.= "^";
	  $metaOperationParameterFieldsDefinition.= $metaOperationParameterField2;
	}
	else{
	  $metaOperationParameterFieldsDefinition.= "^";
	  $metaOperationParameterFieldsDefinition.= $OPERATION_PARAMETER_FIELD_DEFAULT_DEFINITION;
	}

    $metaOperationParameterField3 = trim($metaOperation->[$PARAMETER_FIELD_3_INDEX]);#Remove space chars
	if($metaOperationParameterField3 ne ""){
	  $metaOperationParameterFieldsDefinition.= "^";
	  $metaOperationParameterFieldsDefinition.= $metaOperationParameterField3;
	}
	else{
	  $metaOperationParameterFieldsDefinition.= "^";
	  $metaOperationParameterFieldsDefinition.= $OPERATION_PARAMETER_FIELD_DEFAULT_DEFINITION;
	}

    $metaOperationParameterField4 = trim($metaOperation->[$PARAMETER_FIELD_4_INDEX]);#Remove space chars
	if($metaOperationParameterField4 ne ""){
	  $metaOperationParameterFieldsDefinition.= "^";
	  $metaOperationParameterFieldsDefinition.= $metaOperationParameterField4;
	}
	else{
	  $metaOperationParameterFieldsDefinition.= "^";
	  $metaOperationParameterFieldsDefinition.= $OPERATION_PARAMETER_FIELD_DEFAULT_DEFINITION;
	}

    $metaOperationParameterField5 = trim($metaOperation->[$PARAMETER_FIELD_5_INDEX]);#Remove space chars
	if($metaOperationParameterField5 ne ""){
	  $metaOperationParameterFieldsDefinition.= "^";
	  $metaOperationParameterFieldsDefinition.= $metaOperationParameterField5;
	}
	else{
	  $metaOperationParameterFieldsDefinition.= "^";
	  $metaOperationParameterFieldsDefinition.= $OPERATION_PARAMETER_FIELD_DEFAULT_DEFINITION;
	}

    $metaOperationParameterField6 = trim($metaOperation->[$PARAMETER_FIELD_6_INDEX]);#Remove space chars
	if($metaOperationParameterField6 ne ""){
	  $metaOperationParameterFieldsDefinition.= "^";
	  $metaOperationParameterFieldsDefinition.= $metaOperationParameterField6;
	}
	else{
	  $metaOperationParameterFieldsDefinition.= "^";
	  $metaOperationParameterFieldsDefinition.= $OPERATION_PARAMETER_FIELD_DEFAULT_DEFINITION;
	}

    $metaOperationParameterField7 = trim($metaOperation->[$PARAMETER_FIELD_7_INDEX]);#Remove space chars
	if($metaOperationParameterField7 ne ""){
	  $metaOperationParameterFieldsDefinition.= "^";
	  $metaOperationParameterFieldsDefinition.= $metaOperationParameterField7;
	}
	else{
	  $metaOperationParameterFieldsDefinition.= "^";
	  $metaOperationParameterFieldsDefinition.= $OPERATION_PARAMETER_FIELD_DEFAULT_DEFINITION;
	}

    $metaOperationParameterField8 = trim($metaOperation->[$PARAMETER_FIELD_8_INDEX]);#Remove space chars
	if($metaOperationParameterField8 ne ""){
	  $metaOperationParameterFieldsDefinition.= "^";
	  $metaOperationParameterFieldsDefinition.= $metaOperationParameterField8;
	}
	else{
	  $metaOperationParameterFieldsDefinition.= "^";
	  $metaOperationParameterFieldsDefinition.= $OPERATION_PARAMETER_FIELD_DEFAULT_DEFINITION;
	}

    $metaOperationParameterField9 = trim($metaOperation->[$PARAMETER_FIELD_9_INDEX]);#Remove space chars
	if($metaOperationParameterField9 ne ""){
	  $metaOperationParameterFieldsDefinition.= "^";
	  $metaOperationParameterFieldsDefinition.= $metaOperationParameterField9;
	}
	else{
	  $metaOperationParameterFieldsDefinition.= "^";
	  $metaOperationParameterFieldsDefinition.= $OPERATION_PARAMETER_FIELD_DEFAULT_DEFINITION;
	}

    $metaOperationParameterField10 = trim($metaOperation->[$PARAMETER_FIELD_10_INDEX]);#Remove space chars
	if($metaOperationParameterField10 ne ""){
	  $metaOperationParameterFieldsDefinition.= "^";
	  $metaOperationParameterFieldsDefinition.= $metaOperationParameterField10;
	}
	else{
	  $metaOperationParameterFieldsDefinition.= "^";
	  $metaOperationParameterFieldsDefinition.= $OPERATION_PARAMETER_FIELD_DEFAULT_DEFINITION;
	}
 
    if($optionIndex == 0){
  	  print "            <option selected='selected' value='$metaOperationParameterFieldsDefinition'>$metaOperationNameDesc</option>\n";
    }
	else{
	  print "            <option value='$metaOperationParameterFieldsDefinition'>$metaOperationNameDesc</option>\n";
	}

    $optionIndex++;
  }#end foreach my $metaOperation (@operationMetaRecords)
}

#This method is used to print out Operation and Parameter Fields Input Values
sub printOperationAndParameterFieldsInputValues{
   #Define Vars
   my $operationParameterFieldsDefinition = "";
   my @operationParameterFieldsDefinitionArray;
   my $operationNameSelectedCode = "";
   my $operationNameSelectedDesc = ""; 
   my $operationParameterField1InputValue = "";
   my $operationParameterField2InputValue = "";
   my $operationParameterField3InputValue = "";
   my $operationParameterField4InputValue = "";
   my $operationParameterField5InputValue = "";
   my $operationParameterField6InputValue = "";
   my $operationParameterField7InputValue = "";
   my $operationParameterField8InputValue = "";
   my $operationParameterField9InputValue = "";
   my $operationParameterField10InputValue = "";
   my $mergedOperationParameterFieldsValue = "";

   if(defined $cgi->param("operationListName") && trim($cgi->param("operationListName")) ne ""){
     print "<table width='100%' border='1'>\n";
     print "  <tr bgcolor='#FCFCFC'>\n";
     print "    <td>Operation Name Selected Code</td>\n";
	 print "    <td>Operation Name Selected Description</td>\n";
     print "    <td>Parameter Field 1 Input Value</td>\n";
     print "    <td>Parameter Field 2 Input Value</td>\n";
     print "    <td>Parameter Field 3 Input Value</td>\n";
     print "    <td>Parameter Field 4 Input Value</td>\n";
     print "    <td>Parameter Field 5 Input Value</td>\n";
     print "    <td>Parameter Field 6 Input Value</td>\n";
     print "    <td>Parameter Field 7 Input Value</td>\n";
     print "    <td>Parameter Field 8 Input Value</td>\n";
     print "    <td>Parameter Field 9 Input Value</td>\n";
     print "    <td>Parameter Field 10 Input Value</td>\n";
	 print "    <td>The Merged Parameter Fields Value</td>\n";
     print "  </tr>\n";
     print "  <tr>\n";
     $operationParameterFieldsDefinition = trim($cgi->param("operationListName"));
     @operationParameterFieldsDefinitionArray = split(/\^/,$operationParameterFieldsDefinition);
     $operationNameSelectedCode = trim($operationParameterFieldsDefinitionArray[0]);#Get the Operation Name Selected Code Value
     print "    <td>$operationNameSelectedCode</td>\n";

     $operationNameSelectedDesc = trim($operationParameterFieldsDefinitionArray[1]);#Get the Operation Name Selected Description Value
     print "    <td>$operationNameSelectedDesc</td>\n";

	 if(defined $cgi->param("parm_fld1_name") && (trim($cgi->param("parm_fld1_name")) ne "")){
       $operationParameterField1InputValue = trim($cgi->param("parm_fld1_name"));
       $operationParameterField1InputValue =~ s/\\/\\\\/g;#Replace all the chars '\' using '\\' if Operation Parameter has #Added by Larry for System Support And Self Healing Service Components - Phase 3
       print "    <td>$operationParameterField1InputValue</td>\n";
	   $mergedOperationParameterFieldsValue.= $operationParameterField1InputValue;
     }
	 else{
	   print "    <td>-</td>\n";
	 }

     if(defined $cgi->param("parm_fld2_name") && (trim($cgi->param("parm_fld2_name")) ne "")){
       $operationParameterField2InputValue = trim($cgi->param("parm_fld2_name"));
	   $operationParameterField2InputValue =~ s/\\/\\\\/g;#Replace all the chars '\' using '\\' if Operation Parameter has #Added by Larry for System Support And Self Healing Service Components - Phase 3
       print "    <td>$operationParameterField2InputValue</td>\n";
	   $mergedOperationParameterFieldsValue.= "^";
	   $mergedOperationParameterFieldsValue.= $operationParameterField2InputValue;
     }
	 else{
	   print "    <td>-</td>\n";
	 }

     if(defined $cgi->param("parm_fld3_name") && (trim($cgi->param("parm_fld3_name")) ne "")){
	   $operationParameterField3InputValue = trim($cgi->param("parm_fld3_name"));
	   $operationParameterField3InputValue =~ s/\\/\\\\/g;#Replace all the chars '\' using '\\' if Operation Parameter has #Added by Larry for System Support And Self Healing Service Components - Phase 3
       print "    <td>$operationParameterField3InputValue</td>\n";
	   $mergedOperationParameterFieldsValue.= "^";
	   $mergedOperationParameterFieldsValue.= $operationParameterField3InputValue;
     }
	 else{
	   print "    <td>-</td>\n";
	 }

     if(defined $cgi->param("parm_fld4_name") && (trim($cgi->param("parm_fld4_name")) ne "")){
	   $operationParameterField4InputValue = trim($cgi->param("parm_fld4_name"));
       $operationParameterField4InputValue =~ s/\\/\\\\/g;#Replace all the chars '\' using '\\' if Operation Parameter has #Added by Larry for System Support And Self Healing Service Components - Phase 3
       print "    <td>$operationParameterField4InputValue</td>\n";
	   $mergedOperationParameterFieldsValue.= "^";
	   $mergedOperationParameterFieldsValue.= $operationParameterField4InputValue;
     }
	 else{
	   print "    <td>-</td>\n";
	 }

     if(defined $cgi->param("parm_fld5_name") && (trim($cgi->param("parm_fld5_name")) ne "")){
	   $operationParameterField5InputValue = trim($cgi->param("parm_fld5_name"));
	   $operationParameterField5InputValue =~ s/\\/\\\\/g;#Replace all the chars '\' using '\\' if Operation Parameter has #Added by Larry for System Support And Self Healing Service Components - Phase 3
       print "    <td>$operationParameterField5InputValue</td>\n";
	   $mergedOperationParameterFieldsValue.= "^";
	   $mergedOperationParameterFieldsValue.= $operationParameterField5InputValue;
     }
	 else{
	   print "    <td>-</td>\n";
	 }

     if(defined $cgi->param("parm_fld6_name") && (trim($cgi->param("parm_fld6_name")) ne "")){
	   $operationParameterField6InputValue = trim($cgi->param("parm_fld6_name"));
	   $operationParameterField6InputValue =~ s/\\/\\\\/g;#Replace all the chars '\' using '\\' if Operation Parameter has #Added by Larry for System Support And Self Healing Service Components - Phase 3
       print "    <td>$operationParameterField6InputValue</td>\n";
	   $mergedOperationParameterFieldsValue.= "^";
	   $mergedOperationParameterFieldsValue.= $operationParameterField6InputValue;
     }
	 else{
	   print "    <td>-</td>\n";
	 }

     if(defined $cgi->param("parm_fld7_name") && (trim($cgi->param("parm_fld7_name")) ne "")){
	   $operationParameterField7InputValue = trim($cgi->param("parm_fld7_name"));
	   $operationParameterField7InputValue =~ s/\\/\\\\/g;#Replace all the chars '\' using '\\' if Operation Parameter has #Added by Larry for System Support And Self Healing Service Components - Phase 3
       print "    <td>$operationParameterField7InputValue</td>\n";
	   $mergedOperationParameterFieldsValue.= "^";
	   $mergedOperationParameterFieldsValue.= $operationParameterField7InputValue;
     }
	 else{
	   print "    <td>-</td>\n";
	 }

     if(defined $cgi->param("parm_fld8_name") && (trim($cgi->param("parm_fld8_name")) ne "")){
	   $operationParameterField8InputValue = trim($cgi->param("parm_fld8_name"));
	   $operationParameterField8InputValue =~ s/\\/\\\\/g;#Replace all the chars '\' using '\\' if Operation Parameter has #Added by Larry for System Support And Self Healing Service Components - Phase 3
       print "    <td>$operationParameterField8InputValue</td>\n";
	   $mergedOperationParameterFieldsValue.= "^";
	   $mergedOperationParameterFieldsValue.= $operationParameterField8InputValue;
     }
	 else{
	   print "    <td>-</td>\n";
	 }

     if(defined $cgi->param("parm_fld9_name") && (trim($cgi->param("parm_fld9_name")) ne "")){
	   $operationParameterField9InputValue = trim($cgi->param("parm_fld9_name"));
	   $operationParameterField9InputValue =~ s/\\/\\\\/g;#Replace all the chars '\' using '\\' if Operation Parameter has #Added by Larry for System Support And Self Healing Service Components - Phase 3
       print "    <td>$operationParameterField9InputValue</td>\n";
	   $mergedOperationParameterFieldsValue.= "^";
	   $mergedOperationParameterFieldsValue.= $operationParameterField9InputValue;
     }
	 else{
	   print "    <td>-</td>\n";
	 }

     if(defined $cgi->param("parm_fld10_name") && (trim($cgi->param("parm_fld10_name")) ne "")){
	   $operationParameterField10InputValue = trim($cgi->param("parm_fld10_name"));
	   $operationParameterField10InputValue =~ s/\\/\\\\/g;#Replace all the chars '\' using '\\' if Operation Parameter has #Added by Larry for System Support And Self Healing Service Components - Phase 3
       print "    <td>$operationParameterField10InputValue</td>\n";
	   $mergedOperationParameterFieldsValue.= "^";
	   $mergedOperationParameterFieldsValue.= $operationParameterField10InputValue;
     }
	 else{
	   print "    <td>-</td>\n";
	 }

     if($mergedOperationParameterFieldsValue ne ""){
	   print "    <td>$mergedOperationParameterFieldsValue</td>\n";
	 }
	 else{
	   print "    <td>-</td>\n";
	 } 

     print "  </tr>\n";
     print "</table><br>\n";
   }  
}

#This method is used to insert the new Operation Record into 'OPERATION_QUEUE' DB Table
sub insertOperationRecord{
   #Define Vars
   my $operationParameterFieldsDefinition = "";
   my @operationParameterFieldsDefinitionArray;
   my $operationNameSelectedCode = "";
   my $operationNameSelectedDesc = ""; 
   my $operationParameterField1InputValue = "";
   my $operationParameterField2InputValue = "";
   my $operationParameterField3InputValue = "";
   my $operationParameterField4InputValue = "";
   my $operationParameterField5InputValue = "";
   my $operationParameterField6InputValue = "";
   my $operationParameterField7InputValue = "";
   my $operationParameterField8InputValue = "";
   my $operationParameterField9InputValue = "";
   my $operationParameterField10InputValue = "";
   my $mergedOperationParameterFieldsValue = "";
   my $operationUser = "";

   if(defined $cgi->param("operationListName") && trim($cgi->param("operationListName")) ne ""){
     $operationParameterFieldsDefinition = trim($cgi->param("operationListName"));
     @operationParameterFieldsDefinitionArray = split(/\^/,$operationParameterFieldsDefinition);
     $operationNameSelectedCode = $operationParameterFieldsDefinitionArray[0];#Get the Operation Name Selected Code Value
  	 $operationNameSelectedDesc = trim($operationParameterFieldsDefinitionArray[1]);#Get the Operation Name Selected Description Value
  	
	 #Added by Larry for System Support And Self Healing Service Components - Phase 3 Start - Append Operation Parameter value whatevet it has value or not 
	 #if(defined $cgi->param("parm_fld1_name") && (trim($cgi->param("parm_fld1_name")) ne "")){
	 if(defined $cgi->param("parm_fld1_name")){
       $operationParameterField1InputValue = trim($cgi->param("parm_fld1_name"));
	   $operationParameterField1InputValue =~ s/\\/\\\\/g;#Replace all the chars '\' using '\\' if Operation Parameter has #Added by Larry for System Support And Self Healing Service Components - Phase 3
       $mergedOperationParameterFieldsValue.= $operationParameterField1InputValue;
     }
 
     #if(defined $cgi->param("parm_fld2_name") && (trim($cgi->param("parm_fld2_name")) ne "")){
	 if(defined $cgi->param("parm_fld2_name")){
       $operationParameterField2InputValue = trim($cgi->param("parm_fld2_name"));
	   $operationParameterField2InputValue =~ s/\\/\\\\/g;#Replace all the chars '\' using '\\' if Operation Parameter has #Added by Larry for System Support And Self Healing Service Components - Phase 3
	   #if($mergedOperationParameterFieldsValue ne ""){
	     $mergedOperationParameterFieldsValue.= "^";
       #}
	   $mergedOperationParameterFieldsValue.= $operationParameterField2InputValue;
     }

     #if(defined $cgi->param("parm_fld3_name") && (trim($cgi->param("parm_fld3_name")) ne "")){
     if(defined $cgi->param("parm_fld3_name")){
	   $operationParameterField3InputValue = trim($cgi->param("parm_fld3_name"));
	   $operationParameterField3InputValue =~ s/\\/\\\\/g;#Replace all the chars '\' using '\\' if Operation Parameter has #Added by Larry for System Support And Self Healing Service Components - Phase 3
	   #if($mergedOperationParameterFieldsValue ne ""){
	     $mergedOperationParameterFieldsValue.= "^";
       #}
	   $mergedOperationParameterFieldsValue.= $operationParameterField3InputValue;
     }

     #if(defined $cgi->param("parm_fld4_name") && (trim($cgi->param("parm_fld4_name")) ne "")){
     if(defined $cgi->param("parm_fld4_name")){
	   $operationParameterField4InputValue = trim($cgi->param("parm_fld4_name"));
	   $operationParameterField4InputValue =~ s/\\/\\\\/g;#Replace all the chars '\' using '\\' if Operation Parameter has #Added by Larry for System Support And Self Healing Service Components - Phase 3
	   #if($mergedOperationParameterFieldsValue ne ""){
	     $mergedOperationParameterFieldsValue.= "^";
       #}
	   $mergedOperationParameterFieldsValue.= $operationParameterField4InputValue;
     }

     #if(defined $cgi->param("parm_fld5_name") && (trim($cgi->param("parm_fld5_name")) ne "")){
     if(defined $cgi->param("parm_fld5_name")){
	   $operationParameterField5InputValue = trim($cgi->param("parm_fld5_name"));
	   $operationParameterField5InputValue =~ s/\\/\\\\/g;#Replace all the chars '\' using '\\' if Operation Parameter has #Added by Larry for System Support And Self Healing Service Components - Phase 3
	   #if($mergedOperationParameterFieldsValue ne ""){
	     $mergedOperationParameterFieldsValue.= "^";
       #}
	   $mergedOperationParameterFieldsValue.= $operationParameterField5InputValue;
     }

     #if(defined $cgi->param("parm_fld6_name") && (trim($cgi->param("parm_fld6_name")) ne "")){
     if(defined $cgi->param("parm_fld6_name")){
	   $operationParameterField6InputValue = trim($cgi->param("parm_fld6_name"));
	   $operationParameterField6InputValue =~ s/\\/\\\\/g;#Replace all the chars '\' using '\\' if Operation Parameter has #Added by Larry for System Support And Self Healing Service Components - Phase 3
	   #if($mergedOperationParameterFieldsValue ne ""){
	     $mergedOperationParameterFieldsValue.= "^";
       #}
	   $mergedOperationParameterFieldsValue.= $operationParameterField6InputValue;
     }

     #if(defined $cgi->param("parm_fld7_name") && (trim($cgi->param("parm_fld7_name")) ne "")){
     if(defined $cgi->param("parm_fld7_name")){
	   $operationParameterField7InputValue = trim($cgi->param("parm_fld7_name"));
	   $operationParameterField7InputValue =~ s/\\/\\\\/g;#Replace all the chars '\' using '\\' if Operation Parameter has #Added by Larry for System Support And Self Healing Service Components - Phase 3
	   #if($mergedOperationParameterFieldsValue ne ""){
	     $mergedOperationParameterFieldsValue.= "^";
       #}
	   $mergedOperationParameterFieldsValue.= $operationParameterField7InputValue;
     }

     #if(defined $cgi->param("parm_fld8_name") && (trim($cgi->param("parm_fld8_name")) ne "")){
     if(defined $cgi->param("parm_fld8_name")){
	   $operationParameterField8InputValue = trim($cgi->param("parm_fld8_name"));
	   $operationParameterField8InputValue =~ s/\\/\\\\/g;#Replace all the chars '\' using '\\' if Operation Parameter has #Added by Larry for System Support And Self Healing Service Components - Phase 3
	   #if($mergedOperationParameterFieldsValue ne ""){
	     $mergedOperationParameterFieldsValue.= "^";
       #}
	   $mergedOperationParameterFieldsValue.= $operationParameterField8InputValue;
     }

     #if(defined $cgi->param("parm_fld9_name") && (trim($cgi->param("parm_fld9_name")) ne "")){
     if(defined $cgi->param("parm_fld9_name")){
	   $operationParameterField9InputValue = trim($cgi->param("parm_fld9_name"));
	   $operationParameterField9InputValue =~ s/\\/\\\\/g;#Replace all the chars '\' using '\\' if Operation Parameter has #Added by Larry for System Support And Self Healing Service Components - Phase 3
	   #if($mergedOperationParameterFieldsValue ne ""){
	     $mergedOperationParameterFieldsValue.= "^";
       #}
	   $mergedOperationParameterFieldsValue.= $operationParameterField9InputValue;
     }

     #if(defined $cgi->param("parm_fld10_name") && (trim($cgi->param("parm_fld10_name")) ne "")){
     if(defined $cgi->param("parm_fld10_name")){
	   $operationParameterField10InputValue = trim($cgi->param("parm_fld10_name"));
	   $operationParameterField10InputValue =~ s/\\/\\\\/g;#Replace all the chars '\' using '\\' if Operation Parameter has #Added by Larry for System Support And Self Healing Service Components - Phase 3
	   #if($mergedOperationParameterFieldsValue ne ""){
	     $mergedOperationParameterFieldsValue.= "^";
       #}
	   $mergedOperationParameterFieldsValue.= $operationParameterField10InputValue;
     }
	 #Added by Larry for System Support And Self Healing Service Components - Phase 3 End - Append Operation Parameter value whatevet it has value or not 
     
     if($operationNameSelectedCode ne ""){
  	   $operationUser = getValidLoginUserid();
	   #Invoke Insert Operation Record Method
       insertOperationRecordMethod($dbh,$INSERT_OPERATION_RECORD_SQL,$operationNameSelectedCode,$operationNameSelectedDesc,$mergedOperationParameterFieldsValue,$OPERATION_STATUS_ADDED_CODE,$operationUser);
	 }
   }#end if(defined $cgi->param("operationListName") && trim($cgi->param("operationListName")) ne "")
}#end insertOperationRecord

#This method is used to output HTML Operation Queue Table Data
sub printOperationQueueTableData{
  my @operationQueueDataRecordResultSet = exec_sql_rs($dbh,$GET_OPERATION_QUEUE_DATA_SQL);
  my $operationQueueDataRecordCount = scalar(@operationQueueDataRecordResultSet);
  if($operationQueueDataRecordCount > 0){
    print "<table border = '1' width='100%'>\n";
    printOperationQueueTableHeader(\@OPERATION_QUEUE_TABLE_HEADER_COLUMN_NAMES);
    printOperationQueueTableRecords(\@operationQueueDataRecordResultSet);
    print "</table>\n";
  }
}

#This method is used to output HTML Operation Queue Table Header
sub printOperationQueueTableHeader{
    my $tableHeaderColumnNames = shift;
	print "  <tr bgcolor='#FCFCFC' align='left' style='height:30px;'>\n";
    for my $i (0 .. $#{$tableHeaderColumnNames}){
	  if($i == 0){#'Index #' column - td width='4%'
        print "   <td width='4%'><b><font size='3'>$tableHeaderColumnNames->[$i]</font></b></td>\n";
      }
	  elsif($i == 1){#'Operation Name Description' column - td width='15%'
	    print "   <td width='15%'><b><font size='3'>$tableHeaderColumnNames->[$i]</font></b></td>\n";
	  }
      elsif($i == 2){#'Operation Parameters' column - td width='15%'
	    print "   <td width='15%'><b><font size='3'>$tableHeaderColumnNames->[$i]</font></b></td>\n";
	  }
      elsif($i == 3){#'Operation Status' column - td width='6%'
	    print "   <td width='6%'><b><font size='3'>$tableHeaderColumnNames->[$i]</font></b></td>\n";
	  }
	  elsif($i == 4){#'Operation User' column - td width='10%'
	    print "   <td width='10%'><b><font size='3'>$tableHeaderColumnNames->[$i]</font></b></td>\n";
	  }
	  elsif($i == 5){#'Operation Add Time' column - td width='10%'
	    print "   <td width='10%'><b><font size='3'>$tableHeaderColumnNames->[$i]</font></b></td>\n";
	  }
	  elsif($i == 6){#'Operation Update Time' column - td width='10%'
	    print "   <td width='10%'><b><font size='3'>$tableHeaderColumnNames->[$i]</font></b></td>\n";
	  }
	  elsif($i == 7){#'Comments' column - td width='30%'
	    print "   <td width='30%'><b><font size='3'>$tableHeaderColumnNames->[$i]</font></b></td>\n";
	  }
	}
	print "  </tr>\n";
}

#This method is used to print Operation Queue Table Records
sub printOperationQueueTableRecords{
  my $resultSet = shift;
  my $i = 0;
  my $j = 0;

  for $i (0 .. $#{$resultSet}){
	 if($i % 2 == 0){
       print "  <tr align='left'>\n";
     }
	 else{
	   print "  <tr bgcolor='#FCFCFC' align='left'>\n";
	 }
     
	 #Added by Larry for System Support And Self Healing Service Components - Phase 3 Start
	 #print out the index # for every row
	 my $indexNumber = $i+1;
     print "    <td width='4%'><font size='2'>$indexNumber</font></td>\n";#'Index #' column - td width='4%' 

     for $j (0 .. $#{$resultSet->[$i]}){
	   my $columnValue = $resultSet->[$i][$j];
	   if($j==0){#'Operation Name Description' column - td width='15%'
	     if(defined $columnValue){#If the value of column is not null, then output the value of this column
           $columnValue =~ s/\\\\/\\/g;#Replace all the chars '\\' back using '\' if Operation Parameter has 
	       print "    <td width='15%'><font size='2'>$columnValue</font></td>\n";
         }
	     else{#If the value of column is null, then output '-' as the value of this column
           print "    <td width='15%'><font size='2'>-</font></td>\n";
	     }
	   }
	   elsif($j==1){#'Operation Parameters' column - td width='15%'
	     if(defined $columnValue){#If the value of column is not null, then output the value of this column
           $columnValue =~ s/\\\\/\\/g;#Replace all the chars '\\' back using '\' if Operation Parameter has 
	       print "    <td width='15%'><font size='2'>$columnValue</font></td>\n";
         }
	     else{#If the value of column is null, then output '-' as the value of this column
           print "    <td width='15%'><font size='2'>-</font></td>\n";
	     }  
	   }
	   elsif($j==2){#'Operation Status' column - td width='6%'
	     if(defined $columnValue){#If the value of column is not null, then output the value of this column
           $columnValue =~ s/\\\\/\\/g;#Replace all the chars '\\' back using '\' if Operation Parameter has 
	       print "    <td width='6%'><font size='2'>$columnValue</font></td>\n";
         }
	     else{#If the value of column is null, then output '-' as the value of this column
           print "    <td width='6%'><font size='2'>-</font></td>\n";
	     }  
	   }
	   elsif($j==3){#'Operation User' column - td width='10%'
	     if(defined $columnValue){#If the value of column is not null, then output the value of this column
           $columnValue =~ s/\\\\/\\/g;#Replace all the chars '\\' back using '\' if Operation Parameter has 
	       print "    <td width='10%'><font size='2'>$columnValue</font></td>\n";
         }
	     else{#If the value of column is null, then output '-' as the value of this column
           print "    <td width='10%'><font size='2'>-</font></td>\n";
	     }  
	   }
	   elsif($j==4){#'Operation Add Time' column - td width='10%'
	     if(defined $columnValue){#If the value of column is not null, then output the value of this column
		   $columnValue =~ s/\\\\/\\/g;#Replace all the chars '\\' back using '\' if Operation Parameter has 	  
	       print "    <td width='10%'><font size='2'>$columnValue</font></td>\n";
         }
	     else{#If the value of column is null, then output '-' as the value of this column
           print "    <td width='10%'><font size='2'>-</font></td>\n";
	     }  
	   }
	   elsif($j==5){#'Operation Update Time' column - td width='10%'
	     if(defined $columnValue){#If the value of column is not null, then output the value of this column
           $columnValue =~ s/\\\\/\\/g;#Replace all the chars '\\' back using '\' if Operation Parameter has 
	       print "    <td width='10%'><font size='2'>$columnValue</font></td>\n";
         }
	     else{#If the value of column is null, then output '-' as the value of this column
           print "    <td width='10%'><font size='2'>-</font></td>\n";
	     }  
	   }
	   elsif($j==6){#'Comments' column - td width='30%'
	     if(defined $columnValue){#If the value of column is not null, then output the value of this column
           $columnValue =~ s/\\\\/\\/g;#Replace all the chars '\\' back using '\' if Operation Parameter has 
	       print "    <td width='30%'><font size='2'>$columnValue</font></td>\n";
         }
	     else{#If the value of column is null, then output '-' as the value of this column
           print "    <td width='30%'><font size='2'>-</font></td>\n";
	     }  
	   }
	 }
	 #Added by Larry for System Support And Self Healing Service Components - Phase 3 End

     print "  </tr>\n";
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

#This method is used to get the current login valid userid
sub getValidLoginUserid{
  my $validLoginUserId = $ENV{"REMOTE_USER"};
  return $validLoginUserId;
}

#my $INSERT_OPERATION_RECORD_SQL = "INSERT INTO OPERATION_QUEUE(OPERATION_NAME_CODE, OPERATION_NAME_DESCRIPTION, OPERATION_PARMS, OPERATION_STATUS, OPERATION_USER, OPERATION_ADD_TIME) VALUES(?,?,?,?,?,CURRENT TIMESTAMP)";
#This method is used to insert Operation Record Method
sub insertOperationRecordMethod{
    my $dbh = shift;
    my $insertOperationSQL = shift;
    my $operationNameCode = shift;
	my $operationNameDesc = shift;
	my $operationParametersValue = shift; 
	my $operationStatus = shift; 
	my $operationUser = shift;
	my $sth;

    eval {
        $sth = $dbh->prepare($insertOperationSQL);
        $sth->execute($operationNameCode,$operationNameDesc,$operationParametersValue,$operationStatus,$operationUser);
        $sth->finish();
    };
    if ($@) {
        $dbh->rollback();
        die "Unable to execute sql command ($insertOperationSQL): $@\n";
    }
}

#Error Page
sub error{
  print "Content-type: text/html\n\n";
  print "<html>\n";
  print "  <head>\n";
  print "     <title>Operation Support GUI</title>\n";
  print "     <body>\n";
  print "       <h3><font color='red'>An application error has occurred!</font></h3>\n";
  print "     </body>\n";
  print "  </head>\n";
  print "</html>\n";
}

#Invalid User Access
sub invalidUserAccess{
  print "Content-type: text/html\n\n";
  print "<html>\n";
  print "  <head>\n";
  print "     <title>Operation Support GUI</title>\n";
  print "     <body>\n";
  print "       <h3><font color='red'>You are not authorized to access this page!<br>\n"; 
  print "                             Please contact Larry(liuhaidl\@cn.ibm.com) to add you into the authorized user list if you need. Thanks!</font></h3>\n";
  print "     </body>\n";
  print "  </head>\n";
  print "</html>\n";
}

#This method is used to get server mode value from properties file
sub getServerMode{
  my $operationGUIConfigFile = shift;
  my $serverMode = ""; 
  
  open(OPERATION_GUI_CONFIG_FILE_HANDLER, "<", $operationGUIConfigFile ) or die "Operation GUI Configuration File {$operationGUIConfigFile} doesn't exist. Perl script exits due to this reason.";
  while (my $operationGUIConfigLine = <OPERATION_GUI_CONFIG_FILE_HANDLER>){
    $operationGUIConfigLine = trim($operationGUIConfigLine);
    #Get the first char of a string
	my $strFirstChar = substr($operationGUIConfigLine,0,1);
	#Bypass comment line
    if($strFirstChar eq $COMMENT_CHAR){
	  next;
	}
 
    my @operationGUIConfigLineArray = split(/\=/,$operationGUIConfigLine);
	my $operationGUIConfigLineArrayCnt = scalar(@operationGUIConfigLineArray);
	if($operationGUIConfigLineArrayCnt == 2){
	  my $configKey = trim($operationGUIConfigLineArray[$OPERATION_GUI_CONFIG_LINE_KEY]);#Config Line Key - For example: 'server'
      if($configKey eq $CONFIG_LINE_KEY_SERVER){
	    $serverMode = trim($operationGUIConfigLineArray[$OPERATION_GUI_CONFIG_LINE_VALUE]);#Config Line Value - For example: 'TAP'
		last;
	  }
	} 		
  }#end while (my $operationGUIConfigLine = <OPERATION_GUI_CONFIG_FILE_HANDLER>)
  close OPERATION_GUI_CONFIG_FILE_HANDLER;

  return $serverMode;
}

#This method is used to print Server Mode for testing purpose
sub printServerMode{
  print "  <font color='blue' size='5'><b>Server Mode:</b> {$SERVER_MODE}</font>\n";
}

#This method is used to set DB2 ENV path
sub setDB2ENVPath{
    if($SERVER_MODE eq $TAP){#TAP Server
      $DB_ENV = "/db2/tap/sqllib/db2profile";
    }
	elsif($SERVER_MODE eq $TAP2){#TAP2 Server
	  $DB_ENV = "/home/tap/sqllib/db2profile";
	}
}

#This method is used to set DB Connection Information
sub setDBConnInfo{
    if($SERVER_MODE eq $TAP){#TAP Server
      $db_url = "dbi:DB2:STAGING";
      $db_userid = "eaadmin";
      $db_password = "apr03db2";
    }
	elsif($SERVER_MODE eq $TAP2){#TAP2 Server
	  $db_url = "dbi:DB2:STAGING";
      $db_userid = "eaadmin";
      $db_password = "apr03db2";
	}
}