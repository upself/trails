#!/usr/bin/perl -w

#
# modules
#
use strict; 
use CGI;
use DBI;
use File::Basename;
use Config::Properties::Simple;

#
# globals
#
my $DB_ENV = '/home/eaadmin/sqllib/db2profile';

my $BRAVO_DB = 'trails';
my $STAGING_DB = 'stagigho';
my $SCHEMA = 'eaadmin';
my %softwareMap = () ;
my %typicalItemMap =() ;
my $db_url ;
my $db_userid;
my $db_password ;
my $db2_url ;
my $db2_userid ;
my $db2_password ;

my %users = ();
$users{'gonght@cn.ibm.com'}++;
$users{'lamm@us.ibm.com'}++;
$users{'y99xwu@cz.ibm.com'}++;
$users{'gardnerj@us.ibm.com'}++;
$users{'dbryson@us.ibm.com'}++;
$users{'bobrutig@us.ibm.com'}++;
$users{'evazeng@cn.ibm.com'}++;
$users{'bobrutig@us.ibm.com'}++;
$users{'jiri.sterba@cz.ibm.com'}++;
$users{'liuhaidl@cn.ibm.com'}++;
$users{'zyizhang@cn.ibm.com'}++;
$users{'kfaler@us.ibm.com'}++;
$users{'szhehao@cn.ibm.com'}++;
$users{'zhysz@cn.ibm.com'}++;
$users{'runjial@cn.ibm.com'}++;
$users{'eugen.raceanu@cz.ibm.com'}++;
$users{'adam.trnka@cz.ibm.com'}++;
$users{'martin.kacor@cz.ibm.com'}++;
$users{'petr_soufek@cz.ibm.com'}++;
$users{'zengqh@cn.ibm.com'}++;
$users{'shaodsz@cn.ibm.com'}++;
$users{'ondrej_zivnustka@cz.ibm.com'}++;
$users{'Z28805@cz.ibm.com'}++;

my $cgi = new CGI;
my $self = basename($0);
    my $user = $ARGV[0];

#
# authentication
#
if (!defined $user || $user eq '') {
    error();
    exit 0;
}

#
# authorization
#
if (!exists $users{ $user }) {
    invalid_access();
    exit 0;
}

#
# db2 environment
#
setupDB2Env();
setDBConnInfo();

#
# db connections
#

#$staging->setDatabase($STAGING_DB);
#my $string = "dbi:DB2:DATABASE=staging;HOSTNAME=tap.raleigh.ibm.com;PORT=5104;PROTOCOL=TCPIP;";
my $staging = DBI->connect($db_url, $db_userid, $db_password) || die "Connection failed with error: $DBI::errstr";
my $bravo = DBI->connect($db2_url, $db2_userid, $db2_password) || die "Connection failed with error: $DBI::errstr";


#
# main
#
my $error = $cgi->param("error");
if (defined $error) {
    error();
}
else {
    my $objectF = $cgi->param("objectF") || "NULL";
    my $objectId = $cgi->param("objectId") || "NULL";
    if ($objectF eq 'SIGNATURE' || $objectF || 'FILTER' || $objectF || 'TLCMZ' && $objectF || 'MANUAL' || 'TADZ') {
     %softwareMap = getSoftwareMap($objectF,$objectId);
     %typicalItemMap = getTypicalItemMap($objectF,$objectId);
    }
 # printout($softwareMap);
     queryhost($objectF,$objectId);
   
}

#
# db disconnects
#
$bravo->disconnect();
$staging->disconnect();
exit 0;

#
# subroutines
#
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

# exec sql rs
sub exec_sql_rs {
    my $dbh = shift;
    my $sql = shift;
    my @rs = ();
    eval {
        my $sth = $dbh->prepare($sql);
        $sth->execute();
        push @rs, [ @{ $sth->{NAME} } ];
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

# print rs html
sub print_rs_html {
    my $rs = shift;
    my $s;
    print "<table border=1 >\n";
    for my $i (0 .. $#{$rs}) {
        $s = "";
        print "<tr>\n";
        for my $j (0 .. $#{$rs->[$i]}) {
           if ($i == 0) {
                print "<th>\n";
            }else {
                print "<td >\n";
            }
            print "<font size=1>\n";
            if (defined $rs->[$i][$j]) {
                
                if (uc($rs->[0][$j]) eq 'SOFTWARE_NAME') {
                    if ($i == 0) {
                        print 'SOFTWARE_NAME';
                    }
                    else {
                        print $softwareMap{ $rs->[$i][$j] } ;
                    }
                }
                 elsif (uc($rs->[0][$j]) eq 'SOFTWARE_SIGNATURE_NAME') {
                    if ($i == 0) {
                        print 'SOFTWARE_SIGNATURE_NAME';
                    }
                    else {
                        print $typicalItemMap{ $rs->[$i][$j] }{'name'};
                    }
                }
                 elsif (uc($rs->[0][$j]) eq 'SOFTWARE_SIGNATURE_PROPERTY') {
                    if ($i == 0) {
                        print 'SOFTWARE_SIGNATURE_SIZE';
                    }
                    else {
                        print $typicalItemMap{ $rs->[$i][$j] }{'property'};
                    }
                }
                    elsif (uc($rs->[0][$j]) eq 'SOFTWARE_FILTER_NAME') {
                    if ($i == 0) {
                        print 'SOFTWARE_FILTER_NAME';
                    }
                    else {
                        print $typicalItemMap{ $rs->[$i][$j] }{'name'};
                    }
                }
                 elsif (uc($rs->[0][$j]) eq 'SOFTWARE_FILTER_PROPERTY') {
                    if ($i == 0) {
                        print 'SOFTWARE_FILTER_VERSION';
                    }
                    else {
                        print $typicalItemMap{ $rs->[$i][$j] }{'property'};
                    }
                }
                    elsif (uc($rs->[0][$j]) eq 'SA_PRODUCT_NAME') {
                    if ($i == 0) {
                        print 'TLCMZ_PRODUCT_NAME';
                    }
                    else {
                        print $typicalItemMap{ $rs->[$i][$j] }{'name'};
                    }
                }
                 elsif (uc($rs->[0][$j]) eq 'SA_PRODUCT_PROPERTY') {
                    if ($i == 0) {
                        print 'SA_PRODUCT_VERSION';
                    }
                    else {
                        print $typicalItemMap{ $rs->[$i][$j] }{'property'};
                    }
                }
                 elsif (uc($rs->[0][$j]) eq 'TADZ_PRODUCT_NAME') {
                    if ($i == 0) {
                        print 'TADZ_PRODUCT_NAME';
                    }
                    else {
                        print $typicalItemMap{ $rs->[$i][$j] }{'name'};
                    }
                }
                 elsif (uc($rs->[0][$j]) eq 'TADZ_PRODUCT_PROPERTY') {
                    if ($i == 0) {
                        print 'TADZ_PRODUCT_VERSION';
                    }
                    else {
                        print $typicalItemMap{ $rs->[$i][$j] }{'property'};
                    }
                }
                elsif (uc($rs->[0][$j]) eq 'SOFTWARE_ID') { 
                     if ($i == 0) {
                        print 'SOFTWARE_ID';
                    }
                    else {                  
                        print "<A href='queryqueue.pl?objectF=SOFTWARE&objectId=$rs->[$i][$j-2]'>";
                        print  $rs->[$i][$j] ;
                        print "</A>";     
                    }           
                }
                 elsif (uc($rs->[0][$j]) eq 'BANK_ACCT') {
                    if ($i == 0) {
                        print 'BANK_ACCT';
                    }
                    else {
                        print "<A href='queryqueue.pl?objectF=BANK_ACCOUNT&objectId=$rs->[$i][$j-1]'>";
                        print  $rs->[$i][$j] ;
                        print "</A>";
                    }
                }
                else {
                        print $rs->[$i][$j];  
                }         
             } else {
                print "-";
            }
            print "</font>\n";
            print "</td>\n";
        }
        print "</tr>\n";
    }
    print "</table>\n";
}

#PRINT RH HTML
sub print_rh_html {
    my $rs = shift;
    my $s;
    print "<table border=1>\n";
    for my $i (0 .. $#{$rs->[0]}) {
        $s = "";
        print "<tr>\n";
        for my $j (0 .. $#{$rs}) {
          
               if ($j == 0) {
                print "<th>\n";
            } else {
                print "<td>\n";
            }
            print "<font size=1>\n";
            if (defined $rs->[$j][$i]) {
                       print $rs->[$j][$i];
                        } else {
                print "-";
            }
            print "</font>\n";
            print "</td>\n";
        }
        print "</tr>\n";
    }
    print "</table>\n";
}

#getmaps

sub getSoftwareMap {
    my %map ;
    my @rs ;
    my @srs;
    my @bs ;
    my $idstring = '999999';
    my $guidstring = '\'abcdefg1234\'';
    my $objectF = shift ;
    my $objectId = shift ;
    if ( $objectF eq 'SIGNATURE' ){
        @rs = exec_sql_rs($staging,
        "select SOFTWARE_ID from  software_signature where scan_record_id = $objectId group by software_id with ur");
    }
    if ( $objectF eq 'FILTER' ){
        @rs = exec_sql_rs($staging,
        "select SOFTWARE_ID from  software_filter where scan_record_id = $objectId group by software_id with ur");
    }
    if ( $objectF eq 'TLCMZ' ){
        @rs = exec_sql_rs($staging,
        "select SOFTWARE_ID from  software_tlcmz where scan_record_id = $objectId group by software_id with ur");
    }
    if ( $objectF eq 'MANUAL' ){
        @rs = exec_sql_rs($staging,
        "select SOFTWARE_ID from  software_manual where scan_record_id = $objectId group by software_id with ur");
    }
    if ( $objectF eq 'TADZ' ){
        @srs = exec_sql_rs($staging,
        "select GUID from  scan_software_item where scan_record_id = $objectId group by guid with ur");
    }
    if ( $objectF eq 'TADZ' ){
      for my $i (0 .. $#srs) {
        next if $i == 0;
        $guidstring= $guidstring.',\''.$srs[$i][0].'\'';
      }
       @bs = exec_sql_rs($bravo,
        "select upper(kb.guid),si.name from  software_item si join kb_definition kb on si.id=kb.id where upper(kb.guid) in ($guidstring) with ur");
    }else { 
      for my $i (0 .. $#rs) {
        next if $i == 0;
        $idstring= $idstring.','.$rs[$i][0];
      }     
     @bs = exec_sql_rs($bravo,
        "select id,name from  software_item where id in ($idstring) with ur");
    }
    
    for my $j (0 .. $#bs) {
        next if $j == 0;
        $map{ $bs[$j][0] } = $bs[$j][1];
    }

    return %map;
}

sub getTypicalItemMap {
    my %map =();
    my @rs ;
    my @srs;
    my @bs ;
    my $idstring = '999999';
    my $guidstring ='\'abcdefghijklmn0123456789\'';
    my $objectF = shift ;
    my $objectId = shift ;
    if ( $objectF eq 'SIGNATURE' ){
        @rs = exec_sql_rs($staging,
        "select SOFTWARE_SIGNATURE_ID from  software_signature where scan_record_id = $objectId group by SOFTWARE_SIGNATURE_ID with ur");
    }
    if ( $objectF eq 'FILTER' ){
        @rs = exec_sql_rs($staging,
        "select SOFTWARE_FILTER_ID from  software_filter where scan_record_id = $objectId group by SOFTWARE_FILTER_ID with ur");
    }
    if ( $objectF eq 'TLCMZ' ){
        @rs = exec_sql_rs($staging,
        "select SA_PRODUCT_ID from  software_tlcmz where scan_record_id = $objectId group by SA_PRODUCT_ID with ur");
    }
    if ( $objectF eq 'TADZ' ){
        @srs = exec_sql_rs($staging,
         "select GUID from  scan_software_item where scan_record_id = $objectId group by guid with ur");
    }

    for my $i (0 .. $#rs) {
        next if $i == 0;
        $idstring= $idstring.','.$rs[$i][0];
    }
    for my $i (0 .. $#srs) {
        next if $i == 0;
        $guidstring= $guidstring.',\''.$srs[$i][0].'\'';
    }
     if ( $objectF eq 'SIGNATURE' ){
     @bs = exec_sql_rs($bravo,
        "select SOFTWARE_SIGNATURE_ID,file_name,file_size from  software_signature where software_signature_id in ($idstring) with ur");
     }
     if ( $objectF eq 'FILTER' ){
     @bs = exec_sql_rs($bravo,
        "select SOFTWARE_FILTER_ID,software_name,software_version from  software_filter where software_filter_id in ($idstring) with ur");
     }
     if ( $objectF eq 'TLCMZ' ){
     @bs = exec_sql_rs($bravo,
        "select ID,sa_product,version from  sa_product where id in ($idstring) with ur");
     }
     if ( $objectF eq 'TADZ' ){
     @bs = exec_sql_rs($bravo,
        "select upper(kb.guid),si.name,mv.version from mainframe_version mv join software_item si on mv.product_id=si.id join kb_definition kb on mv.id=kb.id where upper(kb.guid) in ($guidstring) 
        union all 
        select upper(kb.guid),si.name,mv.version from mainframe_feature mf join kb_definition kb on mf.id=kb.id join mainframe_version mv on mf.version_id=mv.id join software_item si on mv.product_id=si.id where upper(kb.guid) in ($guidstring)");
     }
    for my $j (0 .. $#bs) {
        next if $j == 0;
        $map{ $bs[$j][0] }{'name'} = $bs[$j][1];
        $map{ $bs[$j][0] }{'property'} = $bs[$j][2];
    }

    return %map;
}

# header
sub header {
    print <<HTML;

<html>
<head>
<title>queryshost detail</title>
</head>
<body>
HTML
}

# footer
sub footer {
    print <<HTML;
</body>
</html>
HTML
}

# error page
sub error {
    header();
    print <<HTML;
<h3><font color=red>An application error has occurred!</font></h3>
HTML
    footer();
}

# error page
sub printout {
    my $var;
    $var = shift;
    header();
    print <<HTML;
<h3><font color=red>the output is $var </font></h3>
HTML
    footer();
}

# invalid access page
sub invalid_access {
    header();
    print <<HTML;
<h3><font color=red>You are not authorized to access this page.</font></h3>
HTML
    footer();
}

# shost
sub queryhost {
    my $objectF = shift;
    my $objecId = shift;
    $objectF =~ s/^\s+//;
    $objectF =~ s/\s+$//;
    $objecId =~ s/^\s+//;
    $objecId =~ s/\s+$//;
if ( $objecId =~ m/\D/ ) {
    exit 0;
}
if ( $objectF ne 'SWLPAR' && $objectF ne 'HWLPAR' && $objectF ne 'CUSTOMER' && $objectF eq 'SIGNATURE' && $objectF eq 'FILTER' && $objectF eq 'TLCMZ' && $objectF eq 'MANUAL' && $objectF eq 'SOFTWARE' && $objectF eq 'BANK_ACCOUNT') {
    exit 0;
}

    header();
   
    if ($objecId ne "NULL" && $objectF ne "NULL") {
        my @rs;
        eval {
            if ( $objectF eq 'SWLPAR' ) {
            print "<h3>Bravo SW Lpar Alert and Recon Info</h3>\n";
            @rs = exec_sql_rs($bravo,
                "select T.sl_id
  ,T.hostname
  ,T.alert_Id
  ,T.alert_IsOpen
  ,T.alert_Comment
  ,T.alert_CreationTime
  ,T.alert_RecordTime
  ,T.alert_RemoteUser
  ,T.Alert_Type
  ,rsl.id as recon_id
  ,rsl.action as recon_action
  ,rsl.remote_user as recon_remoteUser
  ,rsl.record_time as recon_recordTime
from (
select 
   sl.id as sl_id
  ,sl.name as hostname
  ,asl.id as alert_Id
  ,asl.open as alert_IsOpen
  ,asl.comments as alert_Comment
  ,asl.creation_time as alert_CreationTime
  ,asl.record_time as alert_RecordTime
  ,asl.remote_user as alert_RemoteUser
  ,'SW Lpar No Hw Lpar' as Alert_Type   
from software_lpar sl 
left outer join alert_sw_lpar asl on asl.software_lpar_id=sl.id
where sl.id = $objecId 

union all

select 
   sl.id as sl_id
  ,sl.name as hostname
  ,a.id as alert_Id
  ,a.open as alert_IsOpen
  ,a.comment as alert_Comment
  ,a.creation_time as alert_CreationTime
  ,a.record_time as alert_RecordTime
  ,a.remote_user as alert_RemoteUser
  ,at.Name as Alert_Type
from software_lpar sl
left outer join alert_software_lpar dsl on dsl.software_lpar_id=sl.id
left outer join alert a on dsl.id=a.id
left outer join alert_type at on a.alert_type_id=at.id
where sl.id = $objecId

union all

select 
   sl.id as sl_id
  ,sl.name as hostname
  ,aes.id as alert_Id
  ,aes.open as alert_IsOpen
  ,aes.comments as alert_Comment
  ,aes.creation_time as alert_CreationTime
  ,aes.record_time as alert_RecordTime
  ,aes.remote_user as alert_RemoteUser
  ,'Outdated SW LPAR Scan' as Alert_Type
from software_lpar sl
left outer join alert_expired_scan aes on aes.software_lpar_id=sl.id
where sl.id = $objecId 
) as T

left outer join recon_sw_lpar rsl on rsl.software_lpar_id=T.sl_id with ur");
            print_rs_html(\@rs);
            print "<h3>Bravo Installed Softwares of lpar, Alert and Recon Info</h3>\n";
            @rs = exec_sql_rs($bravo,
                "select 
   is.id as installedSW_id
   ,si.name as product_name
   ,si.id as software_id
   ,dt.name as discrepancy
   ,is.status as status
   ,ba.id as ba_id
   ,ba.name as bank_acct
   ,T.type as DataType
   ,is.CREATION_DATE_TIME as isw_creationTime
   ,is.record_time as isw_recordTime
   ,pi.LICENSABLE as licensable
   ,kb.DELETED as kb_status
   ,aus.id as alert_id
   ,aus.open as alert_Open
   ,aus.comments as alert_Comment
   ,aus.type as alert_type
   ,aus.creation_time as alert_creationTime
   ,aus.record_time as alert_recordTime
   ,ris.id as recon_IstalledSW_id
   ,ris.action as recon_Action
   ,ris.remote_user as recon_remoteUser
   ,ris.record_time as recon_recordTime
from installed_software is
join discrepancy_type dt on is.discrepancy_type_id=dt.id
join software_item si on is.software_id=si.id
join product_info pi on is.software_id=pi.id
join kb_definition kb on is.software_id=kb.id
join software_lpar sl on is.software_lpar_id=sl.id
left outer join (
select a.installed_software_id,a.bank_account_id,'filter' as type from installed_filter a join installed_software b on a.installed_software_id=b.id where b.software_lpar_id=$objecId
union
select a.installed_software_id,a.bank_account_id,'signature' as type from installed_signature a join installed_software b on a.installed_software_id=b.id where b.software_lpar_id=$objecId
union
select a.installed_software_id,a.bank_account_id,'SOFTAUDIT' as type from installed_sa_product a join installed_software b on a.installed_software_id=b.id where b.software_lpar_id=$objecId
union
select a.installed_software_id,a.bank_account_id,'dorana' as type from installed_dorana_product a join installed_software b on a.installed_software_id=b.id where b.software_lpar_id=$objecId
union
select a.installed_software_id,a.bank_account_id,'tadz' as type from installed_tadz a join installed_software b on a.installed_software_id=b.id where b.software_lpar_id=$objecId
) as T on T.installed_software_id=is.id
left outer join bank_account ba on T.bank_account_id=ba.id 
left outer join alert_unlicensed_sw aus on aus.installed_software_id=is.id
left outer join recon_installed_sw ris on ris.installed_software_id=is.id
where  sl.id =  $objecId     with ur");
            print_rs_html(\@rs);
    
            print "<h3>Bravo Installed Softwares Reconciliation Info</h3>\n";
            @rs = exec_sql_rs($bravo,
                "select 
   is.id as installedSW_id
   ,si.name as product_name
   ,mt.type as machine_type
   ,hw.serial as hw_serial
   ,hw.owner as hw_owner
   ,hw.country as hw_country
   ,hw.record_time as hw_recordTime
   ,hw.status as hw_status
   ,hw.hardware_status as atp_status
   ,hw.chips as hw_chips
   ,hw.processor_count as hw_processor_cn
   ,hw.server_type as hw_server_type
   ,hw.cpu_mips as cpu_mips
   ,hw.cpu_msu as cpu_msu 
   ,rc.id as reconcile_id
   ,rt.name as reconcile_type
   ,rt.is_manual as is_manual
   ,rc.PARENT_INSTALLED_SOFTWARE_ID as parent_installed_Sw_id
   ,rc.comments as reconcile_comment
   ,rc.remote_user as reconcile_user
   ,rc.record_time as reconcile_recordTime
   ,rc.machine_level as machine_level
   ,rcl.id as license_id
   ,rcl.ext_src_id as ext_src_id
   ,rcl.lic_type as lic_type
   ,rcl.cap_type as capacity_type
   ,rcl.quantity as quantity
   ,rcl.ibm_owned as lic_ibm_owned
   ,rcl.pool as lic_pool
   ,rcl.try_and_buy as try_buy
   ,rcl.expire_date as expire_Date
   ,rcl.version as lic_version
   ,rcl.cpu_serial as lic_cpu_serial
   ,rcl.status as lic_status
   ,rcl.AGREEMENT_TYPE as agrement_type
   ,rcl.lpar_name as lic_lpar_name
   ,rcl.environment as environment
   ,ul.used_quantity as used_quantity
   ,ul.capacity_type_id as capacity_type
from installed_software is
join software_item si on is.software_id=si.id
join software_lpar sl on is.software_lpar_id=sl.id
join hw_sw_composite hsc on hsc.software_lpar_id = sl.id
join hardware_lpar hl on hsc.hardware_lpar_id = hl.id
join hardware hw on hl.hardware_id=hw.id
join machine_type mt on hw.machine_type_id=mt.id
join reconcile rc on rc.installed_software_id=is.id
join reconcile_type rt on rc.reconcile_type_id=rt.id
left outer join reconcile_used_license rul on rul.reconcile_id=rc.id
left outer join used_license ul on rul.used_license_id=ul.id
left outer join license rcl on ul.license_id=rcl.id
where  sl.id = $objecId with ur");
            print_rs_html(\@rs);
            }
        if ( $objectF eq 'HWLPAR' ){
            print "<h3>Bravo HW Lpar  Alert and Recon Info</h3>\n";
            @rs = exec_sql_rs($bravo,
                "select 
  hl.id as hl_id
  ,hl.name as hostname
  ,ahl.id as alert_Id
  ,ahl.open as alert_IsOpen
  ,ahl.comments as alert_Comment
  ,ahl.creation_time as alert_CreationTime
  ,ahl.record_time as alert_RecordTime
  ,ahl.remote_user as alert_remoteUser
  ,rhl.id as recon_id
  ,rhl.action as recon_action
  ,rhl.remote_user as recon_remoteUser
  ,rhl.record_time as recon_recordTime
from hardware_lpar hl 
left outer join alert_hw_lpar ahl on ahl.hardware_lpar_id=hl.id
left outer join recon_hw_lpar rhl on rhl.hardware_lpar_id=hl.id
where hl.id = $objecId with ur");
            print_rs_html(\@rs);
          print "<h3>Bravo Hardware Alert and Recon Info</h3>\n";
            @rs = exec_sql_rs($bravo,
                "select 
  hw.id as hw_id
  ,hl.name as hostname
  ,ahw.id as hw_alert_Id
  ,ahw.open as hw_alert_IsOpen
  ,ahw.comments as hw_alert_Comment
  ,ahw.creation_time as hw_alert_CreationTime
  ,ahw.record_time as hw_alert_RecordTime
  ,ahw.remote_user as hw_alert_remoteUser
  ,rhw.id as hw_recon_id
  ,rhw.action as hw_recon_action
  ,rhw.remote_user as hw_recon_remoteUser
  ,rhw.record_time as hw_recon_recordTime
from hardware_lpar hl 
join hardware hw on hl.hardware_id=hw.id
left outer join alert_hardware ahw on ahw.hardware_id=hw.id
left outer join recon_hardware rhw on rhw.hardware_id=hw.id
where hl.id = $objecId with ur");
            print_rs_html(\@rs);
                      print "<h3>Bravo Hardware Infomation</h3>\n";
            @rs = exec_sql_rs($bravo,
                "select 
  hw.id as hw_id
  ,hl.name as hostname
  ,hl.server_type as hlpar_server_type
   ,mt.name as machine_type
   ,hw.serial as hw_serial
   ,hw.owner as hw_owner
   ,hw.CUSTOMER_NUMBER as customer_number
   ,hw.ACCOUNT_NUMBER as account_number
   ,hw.customer_id as customer_id
   ,hw.country as hw_country
   ,hw.record_time as hw_recordTime
   ,hw.status as hw_status
   ,hw.hardware_status as atp_status
   ,hw.chips as hw_chips
   ,hw.processor_count as hw_processor_cn
   ,hw.server_type as hw_server_type
   ,hw.cpu_mips as cpu_mips
   ,hw.cpu_msu as cpu_msu 
from hardware_lpar hl 
join hardware hw on hl.hardware_id=hw.id
join machine_type mt on hw.machine_type_id=mt.id
where hl.id = $objecId with ur");
            print_rs_html(\@rs);
        }
        if ( $objectF eq 'CUSTOMER' ){
            print "<h3>CUSTOMER Infomation</h3>\n";
            @rs = exec_sql_rs($bravo,
                "select
cs.CUSTOMER_ID as CUSTOMER_ID
,ct.CUSTOMER_TYPE_NAME as   cs_TYPE_NAME  
,cs.ACCOUNT_NUMBER as ACCOUNT_NUMBER
,cs.CUSTOMER_NAME  as CUSTOMER_NAME
,cc.name          as country
,in.INDUSTRY_NAME as industry
,cs.STATUS        as status
,cs.HW_INTERLOCK  as HW_INTERLOCK
,cs.SW_INTERLOCK  as SW_INTERLOCK
,cs.INV_INTERLOCK as INV_INTERLOCK
,cs.SW_LICENSE_MGMT as SW_LICENSE_MGMT 
,cs.SW_SUPPORT   as SW_SUPPORT
,cs.HW_SUPPORT   as HW_SUPPORT
,cs.SCAN_VALIDITY  as SCAN_VALIDITY
,cs.SW_TRACKING    as SW_TRACKING
,cs.SW_COMPLIANCE_MGMT as SW_COMPLIANCE_MGMT
,cs.SW_FINANCIAL_RESPONSIBILITY  as SW_FINANCIAL_RESPONSIBILITY
,cs.SW_FINANCIAL_MGMT  as SW_FINANCIAL_MGMT
,cs.CREATION_DATE_TIME  as   CREATION_DATE_TIME 
,cs.UPDATE_DATE_TIME    as   UPDATE_DATE_TIME
,cs.CONTRACT_SIGN_DATE  as CONTRACT_SIGN_DATE
from customer cs 
join customer_type ct on cs.customer_type_id=ct.customer_type_id
join industry in on cs.industry_id =in.industry_id
join COUNTRY_CODE cc on cs.COUNTRY_CODE_id=cc.id
where account_number = $objecId with ur");
            print_rh_html(\@rs);
            print "<h3>MemberShip Infomation</h3>\n";
            @rs = exec_sql_rs($bravo, 
            "         SELECT 
            cs.account_number as account_number
            ,mpcs.account_number as member_accounts
            ,pmcs.account_number as master_account
      from  customer cs     
           left outer join account_pool mp on  cs.customer_id = mp.master_account_id
           left outer join customer mpcs on mpcs.customer_id=mp.member_account_id
           left outer join account_pool pm  on cs.customer_id = pm.member_account_id
           left outer join customer pmcs on pmcs.customer_id = pm.master_account_id
      where cs.account_number = $objecId with ur");
       print_rs_html(\@rs);
        }
                if ( $objectF eq 'SIGNATURE' ){
            print "<h3>Staing SIGNATURE Infomation</h3>\n";
            @rs = exec_sql_rs($staging,
                "select
                ss.id as id
                ,ss.scan_record_id as scan_record_id
                ,ss.software_signature_id as software_signature_id
                ,ss.software_signature_id as software_signature_name
                ,ss.software_signature_id as software_signature_property
                ,ss.software_id as software_id
                ,ss.software_id as software_name
                ,ss.action
               from software_signature ss 
              where ss.scan_record_id = $objecId order by software_name with ur");
            print_rs_html(\@rs);
        }
        if ( $objectF eq 'FILTER' ){
            print "<h3>Staing FILTER Infomation</h3>\n";
            @rs = exec_sql_rs($staging,
                "select
                ft.id as id
                ,ft.scan_record_id as scan_record_id
                ,ft.software_FILTER_id as software_FILTER_id
                ,ft.software_FILTER_id as software_FILTER_name
                ,ft.software_FILTER_id as software_FILTER_property
                ,ft.software_id as software_id
                ,ft.software_id as software_name
                ,ft.action
               from software_FILTER ft
              where ft.scan_record_id = $objecId  order by software_name with ur");
            print_rs_html(\@rs);
        }
        if ( $objectF eq 'TLCMZ' ){
            print "<h3>Staing TLCMZ Product Infomation</h3>\n";
            @rs = exec_sql_rs($staging,
                "select
                tl.id as id
                ,tl.scan_record_id as scan_record_id
                ,tl.sa_product_id as sa_product_id
                ,tl.sa_product_id as sa_product_name
                ,tl.sa_product_id as sa_product_property
                ,tl.software_id as software_id
                ,tl.software_id as software_name
                ,tl.action
               from software_tlcmz tl 
              where tl.scan_record_id = $objecId order by software_name with ur");
            print_rs_html(\@rs);
        }
        if ( $objectF eq 'TADZ' ){
            print "<h3>Staing TADZ Product Infomation</h3>\n";
            @rs = exec_sql_rs($staging,
                "select
                ssi.id as id
                ,ssi.scan_record_id as scan_record_id
                ,ssi.last_used as last_used
                ,ssi.use_count as use_count
                ,ssi.guid as guid
                ,ssi.guid as tadz_product_name
                ,ssi.guid as tadz_product_property
                ,ssi.guid as software_id
                ,ssi.guid as software_name
                ,ssi.action
               from scan_software_item ssi
              where ssi.scan_record_id = $objecId order by software_name with ur");
            print_rs_html(\@rs);
        }
        if ( $objectF eq 'MANUAL' ){
            print "<h3>Staing MANUAL SOFTWARE Infomation</h3>\n";
            @rs = exec_sql_rs($staging,
                "select
                sm.id as id
                ,sm.scan_record_id as scan_record_id
                ,sm.version as software_version
                ,sm.users as users
                ,sm.software_id as software_id
                ,sm.software_id as software_name
                ,sm.action
               from software_manual sm 
              where sm.scan_record_id = $objecId order by software_name with ur");
            print_rs_html(\@rs);
        }
        if ( $objectF eq 'SOFTWARE' ){
                print "<h3>Bravo Software Infomation</h3>\n";
            @rs = exec_sql_rs($bravo,
                "select 
si.id
,si.name
,si.sub_capacity_licensing
,pi.licensable
,pd.license_type
,kb.active
,mf.name
,kb.custom_1
,kb.custom_2
,kb.custom_3
,kb.definition_source
,kb.deleted
,kb.description
,kb.GUID
,kb.modification_time
,sc.software_category_name
,si.IPLA
,pd.pvu
,pi.remote_user
,pi.record_time
from software_item si 
join kb_definition kb on si.id=kb.id
join product pd  on pd.id=si.id
join product_info pi on pi.id=pd.id
join manufacturer mf on pd.manufacturer_id=mf.id
join software_category sc on pi.software_category_id=sc.software_category_id
join installed_software is on is.software_id=si.id
where is.id = $objecId with ur");
            print_rs_html(\@rs);
                        print "<h3>Bravo Software License Infomation</h3>\n";
            @rs = exec_sql_rs($bravo,
                "select 
l.id 
,l.customer_id
,l.EXT_SRC_ID 
,l.LIC_TYPE
,l.CAP_TYPE 
,l.QUANTITY    
,l.IBM_OWNED DRAFT  
,l.POOL   
,l.TRY_AND_BUY 
,l.EXPIRE_DATE 
,l.END_DATE   
,l.PO_NUMBER                        
,l.PROD_NAME 
,l.FULL_DESC 
,l.VERSION                         
,l.CPU_SERIAL            
,l.LICENSE_STATUS 
,l.REMOTE_USER                                                      
,l.RECORD_TIME                
,l.STATUS                           
,l.AGREEMENT_TYPE 
,l.LPAR_NAME            
,l.ENVIRONMENT
from license l 
join license_sw_map lsm on lsm.license_id=l.id
join installed_software is on lsm.software_id=is.software_id
where is.id= $objecId and l.customer_id in (select b.customer_id from  installed_software a join software_lpar b on a.software_lpar_id=b.id where a.id =$objecId) with ur");
            print_rs_html(\@rs);
        }
                if ( $objectF eq 'BANK_ACCOUNT' ){
                print "<h3>Bank Account Infomation</h3>\n";
            @rs = exec_sql_rs($bravo,
                "select 
           a.id as id
           ,a.name as name
           ,a.type as type
           ,a.CONNECTION_TYPE as connection_type
           ,a.CONNECTION_STATUS as connection_status
           ,a.status as status
           ,a.RECORD_TIME as record_time
           ,a.remote_user as remote_user
           ,a.DESCRIPTION as description
           ,b.COMMENTS as real_status
           ,b.START_TIME as start
           ,b.END_TIME as end
           ,b.status as connecting_status
      from bank_account a
         join bank_account_job b on b.bank_account_id=a.id
where a.id = $objecId with ur");
            print_rs_html(\@rs);
        }
        };
        if ($@) {
            die "Error: $@\n";
            print $cgi->redirect("$self?error=true");
        }
    }
    footer();
}

sub setDBConnInfo{
	my $cfg=Config::Properties::Simple->new(file=>'/opt/SupportGui/connection.txt');        
      $db_url = "dbi:DB2:";
      $db_url .= $cfg->getProperty('staging.name');
      $db_userid = $cfg->getProperty('staging.user');;
      $db_password = $cfg->getProperty('staging.password');
      $db2_url = "dbi:DB2:";
      $db2_url .= $cfg->getProperty('trails.name');
      $db2_userid = $cfg->getProperty('trails.user');;
      $db2_password = $cfg->getProperty('trails.password');
}
