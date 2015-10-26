#!/usr/local/bin/perl -w

#
# modules
#
use strict; 
use CGI;
use DBI;
use File::Basename;
use TAP::DBConnection;
use Tap::NewPerl;
use Database::Connection;
#
# globals
#
my $DB_ENV = '/db2/tap/sqllib/db2profile';
my $BRAVO_DB = 'trails';
my $STAGING_DB = 'staging';
my $SCHEMA = 'eaadmin';

my %users = ();
$users{'gonght@cn.ibm.com'}++;
$users{'lamm@us.ibm.com'}++;
$users{'y99xwu@cz.ibm.com'}++;
$users{'gardnerj@us.ibm.com'}++;
$users{'dbryson@us#!/usr/bin/perl -w

#
# modules
#
use strict; 
use CGI;
use DBI;
use File::Basename;
use DBConnection;

#
# globals
#
my $DB_ENV = '/home/staging/sqllib/db2profile';
my $BRAVO_DB = 'trailspd';
my $STAGING_DB = 'staging';
my $SCHEMA = 'eaadmin';

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
$users{'tomas.sima@cz.ibm.com'}++;

my $cgi = new CGI;
my $self = basename($0);

#
# authentication
#
    my $user = $ARGV[0];
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

#
# db connections
#
my $bravo = new DBConnection();
$bravo->setDatabase($BRAVO_DB);
$bravo->connect();
$bravo->getDbh->do("set current schema $SCHEMA");

my $staging = new DBConnection();
#$staging->setDatabase($STAGING_DB);
#my $string = "dbi:DB2:DATABASE=staging;HOSTNAME=tap.raleigh.ibm.com;PORT=5104;PROTOCOL=TCPIP;";
#my $dbh = DBI->connect($string, 'eaadmin', 'apr03db2') || die "Connection failed with error: $DBI::errstr";
#$staging->setDbh($dbh);

$staging->setDatabase($STAGING_DB);
$staging->connect();
$staging->getDbh->do("set current schema $SCHEMA");

#
# maps
#
my %customerMap = getCustomerMap();
my %bankAcctMap = getBankAcctMap();

#
# main
#
my $error = $cgi->param("error");
if (defined $error) {
    error();
}
else {
    my $shost = $cgi->param("shost") || "null";
    shost($shost);
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
    print "<table border=1>\n";
    for my $i (0 .. $#{$rs}) {
        $s = "";
        print "<tr>\n";
        for my $j (0 .. $#{$rs->[$i]}) {
            if ($i == 0) {
                print "<th>\n";
            } else {
                print "<td>\n";
            }
            print "<font size=1>\n";
            if (defined $rs->[$i][$j]) {
                if (uc($rs->[0][$j]) eq 'CUSTOMER_ID') {
                    if ($i == 0) {
                        print 'ACCT_ID';
                    }
                    else {
                        print $customerMap{ $rs->[$i][$j] };
                    }
                }
                elsif (uc($rs->[0][$j]) eq 'BANK_ACCT_ID') {
                    if ($i == 0) {
                        print 'BANK_ACCT';
                    }
                    else {
                    	print "<A href='queryqueue.pl?objectF=BANK_ACCOUNT&objectId=$rs->[$i][$j]'>";
                        print $bankAcctMap{ $rs->[$i][$j] };
                        print "</A>";
                    }
                }
                elsif (uc($rs->[0][$j]) eq 'BRSL_ID') {
                    if ($i == 0) {
                        print 'BrSL_ID';
                    }
                    else {
                    	print "<A href='queryqueue.pl?objectF=SWLPAR&objectId=$rs->[$i][$j]'>";
                        print  $rs->[$i][$j] ;
                        print "</A>";
                    }
                }
                 elsif (uc($rs->[0][$j]) eq 'BRHL_ID') {
                    if ($i == 0) {
                        print 'BrHL_ID';
                    }
                    else {
                    	print "<A href='queryqueue.pl?objectF=HWLPAR&objectId=$rs->[$i][$j]'>";
                        print  $rs->[$i][$j] ;
                        print "</A>";
                    }
                } 
                 elsif (uc($rs->[0][$j]) eq 'ACCT_ID') {
                    if ($i == 0) {
                        print 'ACCT_ID';
                    }
                    else {
                    	print "<A href='queryqueue.pl?objectF=CUSTOMER&objectId=$rs->[$i][$j]'>";
                        print  $rs->[$i][$j] ;
                        print "</A>";
                    }
                }    
                  elsif (uc($rs->[0][$j]) eq 'DATA_TYPE') {
                    if ($i == 0) {
                        print 'TYPE';
                    }
                    else {
                    	print "<A href='queryqueue.pl?objectF=$rs->[$i][$j]&objectId=$rs->[$i][$j-5]'>";
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

sub getCustomerMap {
    my %map = ();
    my @rs = exec_sql_rs($bravo->getDbh,
        "select customer_id, account_number from customer with ur");
    for my $i (0 .. $#rs) {
        next if $i == 0;
        $map{ $rs[$i][0] } = $rs[$i][1];
    }

    return %map;
}

sub getBankAcctMap {
    my %map = ();
    my @rs = exec_sql_rs($bravo->getDbh,
        "select id, name from bank_account with ur");
    for my $i (0 .. $#rs) {
        next if $i == 0;
        $map{ $rs[$i][0] } = $rs[$i][1];
    }

    return %map;
}

# header
sub header {
    print <<HTML;

<html>
<head>
<title>shost detail</title>
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

# invalid access page
sub invalid_access {
    header();
    print <<HTML;
<h3><font color=red>You are not authorized to access this page.</font></h3>
HTML
    footer();
}

# shost
sub shost {
    my $shost = shift;
    $shost =~ s/^\s+//;
    $shost =~ s/\s+$//;
    $shost = uc($shost);

    # escape any underscores to avoid use as wildcard.
    my $shostForLike = $shost;
    $shostForLike =~ s/\\/\\\\/g;
    $shostForLike =~ s/_/\\_/g;
    $shostForLike .= '.%';

    header();
    print <<HTML;
<script type="text/javascript">
function validateShostInput() {
    var search = document.shostInput.shost.value;
    if (search == null || search.length < 3) {
        alert('You must specify a search string with at least 3 characters.');
        return false;
    }
    return true;
}
</script>
<form name="shostInput" method="get" action="$self" onsubmit="return validateShostInput();">
<table>
<tr>
<td>Short Hostname:</td>
<td><input type="text" name="shost" size="20"/></td>
</tr>
<tr>
<td><input type="submit" value="submit"</td>
<td>&nbsp;</td>
</tr>
</table>
</form>
HTML
    if ($shost ne "NULL") {
        my @rs;
        eval {
            # bravo data
            print "<h3>bravo hw lpar to sw lpar</h3>\n";
            @rs = exec_sql_rs($bravo->getDbh,
                "select
                    hl.id as brhl_id
                    ,hl.name as hl_name
                    ,hl.status as hl_status
                    ,hl.record_time as hl_record_time
                    ,hw.SERIAL as serial
                    ,hl.lpar_status as lpr_status
                    ,hw.hardware_status as atp_status
                    ,c.account_number as acct_id
                    ,sl.id as brsl_id
                    ,sl.name as sl_name
                    ,sl.status as sl_status
                    ,sl.processor_count as sl_proc
                    ,sl.scantime as sl_scan_time
                    ,sl.record_time as sl_record_time
                    ,sle.processor_count as sl_eff_proc
                    from hardware_lpar hl
                    join customer c on c.customer_id = hl.customer_id
                    join hardware hw on hl.hardware_id = hw.id
                    left outer join hw_sw_composite hsc on hsc.hardware_lpar_id = hl.id
                    left outer join software_lpar sl on sl.id = hsc.software_lpar_id
                    left outer join software_lpar_eff sle on sle.id = sl.id
                    where (hl.name = '$shost' or hl.name like '$shostForLike' escape \'\\\')
                    with ur");
            print_rs_html(\@rs);
            print "<h3>bravo sw lpar to hw lpar</h3>\n";
            @rs = exec_sql_rs($bravo->getDbh,
                "select
                    hl.id as brhl_id
                    ,hl.name as hl_name
                    ,hl.status as hl_status
                    ,hl.record_time as hl_record_time
                    ,hw.SERIAL as serial
                    ,hl.lpar_status as lpr_status
                    ,hw.hardware_status as atp_status
                    ,c.account_number as acct_id
                    ,sl.id as brsl_id
                    ,sl.name as sl_name
                    ,sl.status as sl_status
                    ,sl.processor_count as sl_proc
                    ,sl.scantime as sl_scan_time
                    ,sl.record_time as sl_record_time
                    ,sle.processor_count as sl_eff_proc
                    from software_lpar sl
                    join customer c on c.customer_id = sl.customer_id
                    left outer join software_lpar_eff sle on sle.id = sl.id
                    left outer join hw_sw_composite hsc on hsc.software_lpar_id = sl.id
                    left outer join hardware_lpar hl on hl.id = hsc.hardware_lpar_id
                    left outer join hardware hw on hl.hardware_id = hw.id
                    where (sl.name = '$shost' or sl.name like '$shostForLike' escape \'\\\')
                    with ur");
            print_rs_html(\@rs);
    
            # staging data
            print "<h3>staging hw lpar</h3>\n";
            @rs = exec_sql_rs($staging->getDbh,
                "select
                    hl.id as hl_id
                    ,hl.name as hl_name
                    ,hl.customer_id as customer_id
                    ,hl.hardware_id as hw_id
                    ,hl.status as hl_status
                    ,hw.SERIAL as serial
                    ,hl.lpar_status as lpr_status
                    ,hw.hardware_status as atp_status
                    ,hl.action as hl_action
                    ,hw.action as hw_action
                    ,hl.update_date as hl_update_date
                    ,ep.id as eff_proc_id
                    ,ep.processor_count as eff_proc
                    ,ep.status as eff_proc_status
                    ,ep.action as eff_proc_action
                    from hardware_lpar hl
                    join hardware hw on hl.hardware_id = hw.id
                    left outer join effective_processor ep on ep.hardware_lpar_id = hl.id
                    where (hl.name = '$shost' or hl.name like '$shostForLike' escape \'\\\')
                    with ur");
            print_rs_html(\@rs);
            print "<h3>staging scan record to sw lpar</h3>\n";
            @rs = exec_sql_rs($staging->getDbh,
                "select
                    sr.id as sr_id
                    ,sr.name as sr_name
                    ,sr.bank_account_id as bank_acct_id
                    ,sr.scan_time as sr_scan_time
                    ,sr.action as sr_action
                    ,sr.processor_count as sr_proc_cnt
                    ,sr.SERIAL_NUMBER as sr_serial
                    ,slm.action as slm_action
                    ,sl.customer_id as customer_id
                    ,sl.id as sl_id
                    ,sl.name as sl_name
                    ,sl.processor_count as sl_proc_cnt
                    ,sl.scan_time as sl_scan_time
                    ,sl.status as sl_status
                    ,sl.action as sl_action
                    from scan_record sr
                    left outer join software_lpar_map slm on slm.scan_record_id = sr.id
                    left outer join software_lpar sl on sl.id = slm.software_lpar_id
                    where (sr.name = '$shost' or sr.name like '$shostForLike' escape \'\\\')
                    with ur");
            print_rs_html(\@rs);
            print "<h3>staging sw lpar to scan record</h3>\n";
            @rs = exec_sql_rs($staging->getDbh,
                "select
                    sr.id as sr_id
                    ,sr.name as sr_name
                    ,sr.bank_account_id as bank_acct_id
                    ,sr.scan_time as sr_scan_time
                    ,sr.action as sr_action
                    ,sr.processor_count as sr_proc_cnt
                    ,sr.SERIAL_NUMBER as sr_serial
                    ,slm.action as slm_action
                    ,sl.customer_id as customer_id
                    ,sl.id as sl_id
                    ,sl.name as sl_name
                    ,sl.processor_count sl_proc_cnt
                    ,sl.scan_time as sl_scan_time
                    ,sl.status as sl_status
                    ,sl.action as sl_action
                    from software_lpar sl
                    left outer join software_lpar_map slm on slm.software_lpar_id = sl.id
                    left outer join scan_record sr on sr.id = slm.scan_record_id
                    where (sl.name = '$shost' or sl.name like '$shostForLike' escape \'\\\')
                    with ur");
            print_rs_html(\@rs);
            print "<h3>staging sw lpar to scan record inst sw</h3>\n";
            @rs = exec_sql_rs($staging->getDbh,
                "select
                    sr_id
                    ,bank_acct_id
                    ,customer_id
                    ,sl_id
                    ,sl_name
                    ,data_type
                    ,count(data_type) as count
                    ,action
                    from (
                        select
                        sr.id as sr_id
                        ,sr.bank_account_id as bank_acct_id
                        ,sl.customer_id as customer_id
                        ,sl.id as sl_id
                        ,sl.name as sl_name
                        ,'MANUAL' as data_type
                        ,sit.action as action
                        from software_lpar sl
                        join software_lpar_map slm on slm.software_lpar_id = sl.id
                        join scan_record sr on sr.id = slm.scan_record_id
                        join software_manual sit on sit.scan_record_id = sr.id
                        where (sl.name = '$shost' or sl.name like '$shostForLike' escape \'\\\')
                        union all
                        select
                        sr.id as sr_id
                        ,sr.bank_account_id as bank_acct_id
                        ,sl.customer_id as customer_id
                        ,sl.id as sl_id
                        ,sl.name as sl_name
                        ,'SIGNATURE' as data_type
                        ,sit.action as action
                        from software_lpar sl
                        join software_lpar_map slm on slm.software_lpar_id = sl.id
                        join scan_record sr on sr.id = slm.scan_record_id
                        join software_signature sit on sit.scan_record_id = sr.id
                        where (sl.name = '$shost' or sl.name like '$shostForLike' escape \'\\\')
                        union all
                        select
                        sr.id as sr_id
                        ,sr.bank_account_id as bank_acct_id
                        ,sl.customer_id as customer_id
                        ,sl.id as sl_id
                        ,sl.name as sl_name
                        ,'FILTER' as data_type
                        ,sit.action as action
                        from software_lpar sl
                        join software_lpar_map slm on slm.software_lpar_id = sl.id
                        join scan_record sr on sr.id = slm.scan_record_id
                        join software_filter sit on sit.scan_record_id = sr.id
                        where (sl.name = '$shost' or sl.name like '$shostForLike' escape \'\\\')
                        union all
                        select
                        sr.id as sr_id
                        ,sr.bank_account_id as bank_acct_id
                        ,sl.customer_id as customer_id
                        ,sl.id as sl_id
                        ,sl.name as sl_name
                        ,'TLCMZ' as data_type
                        ,sit.action as action
                        from software_lpar sl
                        join software_lpar_map slm on slm.software_lpar_id = sl.id
                        join scan_record sr on sr.id = slm.scan_record_id
                        join software_tlcmz sit on sit.scan_record_id = sr.id
                        where (sl.name = '$shost' or sl.name like '$shostForLike' escape \'\\\')
                        union all
                        select
                        sr.id as sr_id
                        ,sr.bank_account_id as bank_acct_id
                        ,sl.customer_id as customer_id
                        ,sl.id as sl_id
                        ,sl.name as sl_name
                        ,'TADZ' as data_type
                        ,CHAR(sit.action) as action
                        from software_lpar sl
                        join software_lpar_map slm on slm.software_lpar_id = sl.id
                        join scan_record sr on sr.id = slm.scan_record_id
                        join scan_software_item sit on sit.scan_record_id = sr.id
                        where (sl.name = '$shost' or sl.name like '$shostForLike' escape \'\\\')
                        ) as x
                    group by
                        sr_id
                        ,bank_acct_id
                        ,customer_id
                        ,sl_id
                        ,sl_name
                        ,data_type
                        ,action
                    with ur");
            print_rs_html(\@rs);
        };
        if ($@) {
            die "Error: $@\n";
            print $cgi->redirect("$self?error=true");
        }
    }
    footer();
}
.ibm.com'}++;
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
$users{'tomas.sima@cz.ibm.com'}++;

my $cgi = new CGI;
my $self = basename($0);

#
# authentication
#
if (!defined $ENV{'REMOTE_USER'} || $ENV{"REMOTE_USER"} eq '') {
    error();
    exit 0;
}

#
# authorization
#
if (!exists $users{ $ENV{'REMOTE_USER'} }) {
    invalid_access();
    exit 0;
}

#
# db2 environment
#
  setDB2ENVPath();

sub setDB2ENVPath{
    if($SERVER_MODE eq $TAP){#TAP Server
	  $DB_ENV = '/home/db2inst2/sqllib/db2profile';
    }
	elsif($SERVER_MODE eq $TAP2){#TAP2 Server
	  $DB_ENV = "/home/tap/sqllib/db2profile";
	}
	elsif($SERVER_MODE eq $TAP3){#TAP3 Server
	  $DB_ENV = '/home/eaadmin/sqllib/db2profile';
	}
	elsif($SERVER_MODE eq 'b03cxnp15029'){#GHO
	  $DB_ENV = '/home/db2inst2/sqllib/db2profile';
	}
}
}
  #Setup DB2 environment
  setupDB2Env();
  
  #Set DB Connection Information
  setDBConnInfo();
  
    $bravo = Database::Connection->new('trails');
  ###Get staging db connection
  $staging = Database::Connection->new('staging');

my $staging = new DBConnection();
$staging->setDatabase($STAGING_DB);
my $string = "dbi:DB2:DATABASE=staging;HOSTNAME=tap.raleigh.ibm.com;PORT=5104;PROTOCOL=TCPIP;";
my $dbh = DBI->connect($string, 'eaadmin', 'apr03db2') || die "Connection failed with error: $DBI::errstr";
$staging->setDbh($dbh);

#$staging->setDatabase($STAGING_DB);
#$staging->connect();
#$staging->do("set current schema $SCHEMA");

#
# maps
#
my %customerMap = getCustomerMap();
my %bankAcctMap = getBankAcctMap();

#
# main
#
my $error = $cgi->param("error");
if (defined $error) {
    error();
}
else {
    my $shost = $cgi->param("shost") || "null";
    shost($shost);
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
    print "<table border=1>\n";
    for my $i (0 .. $#{$rs}) {
        $s = "";
        print "<tr>\n";
        for my $j (0 .. $#{$rs->[$i]}) {
            if ($i == 0) {
                print "<th>\n";
            } else {
                print "<td>\n";
            }
            print "<font size=1>\n";
            if (defined $rs->[$i][$j]) {
                if (uc($rs->[0][$j]) eq 'CUSTOMER_ID') {
                    if ($i == 0) {
                        print 'ACCT_ID';
                    }
                    else {
                        print $customerMap{ $rs->[$i][$j] };
                    }
                }
                elsif (uc($rs->[0][$j]) eq 'BANK_ACCT_ID') {
                    if ($i == 0) {
                        print 'BANK_ACCT';
                    }
                    else {
                    	print "<A href='queryqueue.pl?objectF=BANK_ACCOUNT&objectId=$rs->[$i][$j]'>";
                        print $bankAcctMap{ $rs->[$i][$j] };
                        print "</A>";
                    }
                }
                elsif (uc($rs->[0][$j]) eq 'BRSL_ID') {
                    if ($i == 0) {
                        print 'BrSL_ID';
                    }
                    else {
                    	print "<A href='queryqueue.pl?objectF=SWLPAR&objectId=$rs->[$i][$j]'>";
                        print  $rs->[$i][$j] ;
                        print "</A>";
                    }
                }
                 elsif (uc($rs->[0][$j]) eq 'BRHL_ID') {
                    if ($i == 0) {
                        print 'BrHL_ID';
                    }
                    else {
                    	print "<A href='queryqueue.pl?objectF=HWLPAR&objectId=$rs->[$i][$j]'>";
                        print  $rs->[$i][$j] ;
                        print "</A>";
                    }
                } 
                 elsif (uc($rs->[0][$j]) eq 'ACCT_ID') {
                    if ($i == 0) {
                        print 'ACCT_ID';
                    }
                    else {
                    	print "<A href='queryqueue.pl?objectF=CUSTOMER&objectId=$rs->[$i][$j]'>";
                        print  $rs->[$i][$j] ;
                        print "</A>";
                    }
                }    
                  elsif (uc($rs->[0][$j]) eq 'DATA_TYPE') {
                    if ($i == 0) {
                        print 'TYPE';
                    }
                    else {
                    	print "<A href='queryqueue.pl?objectF=$rs->[$i][$j]&objectId=$rs->[$i][$j-5]'>";
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

sub getCustomerMap {
    my %map = ();
    my @rs = exec_sql_rs($bravo,
        "select customer_id, account_number from customer with ur");
    for my $i (0 .. $#rs) {
        next if $i == 0;
        $map{ $rs[$i][0] } = $rs[$i][1];
    }

    return %map;
}

sub getBankAcctMap {
    my %map = ();
    my @rs = exec_sql_rs($bravo,
        "select id, name from bank_account with ur");
    for my $i (0 .. $#rs) {
        next if $i == 0;
        $map{ $rs[$i][0] } = $rs[$i][1];
    }

    return %map;
}

# header
sub header {
    print <<HTML;
Content-type: text/html

<html>
<head>
<title>shost detail</title>
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

# invalid access page
sub invalid_access {
    header();
    print <<HTML;
<h3><font color=red>You are not authorized to access this page.</font></h3>
HTML
    footer();
}

# shost
sub shost {
    my $shost = shift;
    $shost =~ s/^\s+//;
    $shost =~ s/\s+$//;
    $shost = uc($shost);

    # escape any underscores to avoid use as wildcard.
    my $shostForLike = $shost;
    $shostForLike =~ s/\\/\\\\/g;
    $shostForLike =~ s/_/\\_/g;
    $shostForLike .= '.%';

    header();
    print <<HTML;
<script type="text/javascript">
function validateShostInput() {
    var search = document.shostInput.shost.value;
    if (search == null || search.length < 3) {
        alert('You must specify a search string with at least 3 characters.');
        return false;
    }
    return true;
}
</script>
<form name="shostInput" method="get" action="$self" onsubmit="return validateShostInput();">
<table>
<tr>
<td>Short Hostname:</td>
<td><input type="text" name="shost" size="20"/></td>
</tr>
<tr>
<td><input type="submit" value="submit"</td>
<td>&nbsp;</td>
</tr>
</table>
</form>
HTML
    if ($shost ne "NULL") {
        my @rs;
        eval {
            # bravo data
            print "<h3>bravo hw lpar to sw lpar</h3>\n";
            @rs = exec_sql_rs($bravo,
                "select
                    hl.id as brhl_id
                    ,hl.name as hl_name
                    ,hl.status as hl_status
                    ,hl.record_time as hl_record_time
                    ,hw.SERIAL as serial
                    ,hl.lpar_status as lpr_status
                    ,hw.hardware_status as atp_status
                    ,c.account_number as acct_id
                    ,sl.id as brsl_id
                    ,sl.name as sl_name
                    ,sl.status as sl_status
                    ,sl.processor_count as sl_proc
                    ,sl.scantime as sl_scan_time
                    ,sl.record_time as sl_record_time
                    ,sle.processor_count as sl_eff_proc
                    from hardware_lpar hl
                    join customer c on c.customer_id = hl.customer_id
                    join hardware hw on hl.hardware_id = hw.id
                    left outer join hw_sw_composite hsc on hsc.hardware_lpar_id = hl.id
                    left outer join software_lpar sl on sl.id = hsc.software_lpar_id
                    left outer join software_lpar_eff sle on sle.id = sl.id
                    where (hl.name = '$shost' or hl.name like '$shostForLike' escape \'\\\')
                    with ur");
            print_rs_html(\@rs);
            print "<h3>bravo sw lpar to hw lpar</h3>\n";
            @rs = exec_sql_rs($bravo,
                "select
                    hl.id as brhl_id
                    ,hl.name as hl_name
                    ,hl.status as hl_status
                    ,hl.record_time as hl_record_time
                    ,hw.SERIAL as serial
                    ,hl.lpar_status as lpr_status
                    ,hw.hardware_status as atp_status
                    ,c.account_number as acct_id
                    ,sl.id as brsl_id
                    ,sl.name as sl_name
                    ,sl.status as sl_status
                    ,sl.processor_count as sl_proc
                    ,sl.scantime as sl_scan_time
                    ,sl.record_time as sl_record_time
                    ,sle.processor_count as sl_eff_proc
                    from software_lpar sl
                    join customer c on c.customer_id = sl.customer_id
                    left outer join software_lpar_eff sle on sle.id = sl.id
                    left outer join hw_sw_composite hsc on hsc.software_lpar_id = sl.id
                    left outer join hardware_lpar hl on hl.id = hsc.hardware_lpar_id
                    left outer join hardware hw on hl.hardware_id = hw.id
                    where (sl.name = '$shost' or sl.name like '$shostForLike' escape \'\\\')
                    with ur");
            print_rs_html(\@rs);
    
            # staging data
            print "<h3>staging hw lpar</h3>\n";
            @rs = exec_sql_rs($staging,
                "select
                    hl.id as hl_id
                    ,hl.name as hl_name
                    ,hl.customer_id as customer_id
                    ,hl.hardware_id as hw_id
                    ,hl.status as hl_status
                    ,hw.SERIAL as serial
                    ,hl.lpar_status as lpr_status
                    ,hw.hardware_status as atp_status
                    ,hl.action as hl_action
                    ,hw.action as hw_action
                    ,hl.update_date as hl_update_date
                    ,ep.id as eff_proc_id
                    ,ep.processor_count as eff_proc
                    ,ep.status as eff_proc_status
                    ,ep.action as eff_proc_action
                    from hardware_lpar hl
                    join hardware hw on hl.hardware_id = hw.id
                    left outer join effective_processor ep on ep.hardware_lpar_id = hl.id
                    where (hl.name = '$shost' or hl.name like '$shostForLike' escape \'\\\')
                    with ur");
            print_rs_html(\@rs);
            print "<h3>staging scan record to sw lpar</h3>\n";
            @rs = exec_sql_rs($staging,
                "select
                    sr.id as sr_id
                    ,sr.name as sr_name
                    ,sr.bank_account_id as bank_acct_id
                    ,sr.scan_time as sr_scan_time
                    ,sr.action as sr_action
                    ,sr.processor_count as sr_proc_cnt
                    ,sr.SERIAL_NUMBER as sr_serial
                    ,slm.action as slm_action
                    ,sl.customer_id as customer_id
                    ,sl.id as sl_id
                    ,sl.name as sl_name
                    ,sl.processor_count as sl_proc_cnt
                    ,sl.scan_time as sl_scan_time
                    ,sl.status as sl_status
                    ,sl.action as sl_action
                    from scan_record sr
                    left outer join software_lpar_map slm on slm.scan_record_id = sr.id
                    left outer join software_lpar sl on sl.id = slm.software_lpar_id
                    where (sr.name = '$shost' or sr.name like '$shostForLike' escape \'\\\')
                    with ur");
            print_rs_html(\@rs);
            print "<h3>staging sw lpar to scan record</h3>\n";
            @rs = exec_sql_rs($staging,
                "select
                    sr.id as sr_id
                    ,sr.name as sr_name
                    ,sr.bank_account_id as bank_acct_id
                    ,sr.scan_time as sr_scan_time
                    ,sr.action as sr_action
                    ,sr.processor_count as sr_proc_cnt
                    ,sr.SERIAL_NUMBER as sr_serial
                    ,slm.action as slm_action
                    ,sl.customer_id as customer_id
                    ,sl.id as sl_id
                    ,sl.name as sl_name
                    ,sl.processor_count sl_proc_cnt
                    ,sl.scan_time as sl_scan_time
                    ,sl.status as sl_status
                    ,sl.action as sl_action
                    from software_lpar sl
                    left outer join software_lpar_map slm on slm.software_lpar_id = sl.id
                    left outer join scan_record sr on sr.id = slm.scan_record_id
                    where (sl.name = '$shost' or sl.name like '$shostForLike' escape \'\\\')
                    with ur");
            print_rs_html(\@rs);
            print "<h3>staging sw lpar to scan record inst sw</h3>\n";
            @rs = exec_sql_rs($staging,
                "select
                    sr_id
                    ,bank_acct_id
                    ,customer_id
                    ,sl_id
                    ,sl_name
                    ,data_type
                    ,count(data_type) as count
                    ,action
                    from (
                        select
                        sr.id as sr_id
                        ,sr.bank_account_id as bank_acct_id
                        ,sl.customer_id as customer_id
                        ,sl.id as sl_id
                        ,sl.name as sl_name
                        ,'MANUAL' as data_type
                        ,sit.action as action
                        from software_lpar sl
                        join software_lpar_map slm on slm.software_lpar_id = sl.id
                        join scan_record sr on sr.id = slm.scan_record_id
                        join software_manual sit on sit.scan_record_id = sr.id
                        where (sl.name = '$shost' or sl.name like '$shostForLike' escape \'\\\')
                        union all
                        select
                        sr.id as sr_id
                        ,sr.bank_account_id as bank_acct_id
                        ,sl.customer_id as customer_id
                        ,sl.id as sl_id
                        ,sl.name as sl_name
                        ,'SIGNATURE' as data_type
                        ,sit.action as action
                        from software_lpar sl
                        join software_lpar_map slm on slm.software_lpar_id = sl.id
                        join scan_record sr on sr.id = slm.scan_record_id
                        join software_signature sit on sit.scan_record_id = sr.id
                        where (sl.name = '$shost' or sl.name like '$shostForLike' escape \'\\\')
                        union all
                        select
                        sr.id as sr_id
                        ,sr.bank_account_id as bank_acct_id
                        ,sl.customer_id as customer_id
                        ,sl.id as sl_id
                        ,sl.name as sl_name
                        ,'FILTER' as data_type
                        ,sit.action as action
                        from software_lpar sl
                        join software_lpar_map slm on slm.software_lpar_id = sl.id
                        join scan_record sr on sr.id = slm.scan_record_id
                        join software_filter sit on sit.scan_record_id = sr.id
                        where (sl.name = '$shost' or sl.name like '$shostForLike' escape \'\\\')
                        union all
                        select
                        sr.id as sr_id
                        ,sr.bank_account_id as bank_acct_id
                        ,sl.customer_id as customer_id
                        ,sl.id as sl_id
                        ,sl.name as sl_name
                        ,'TLCMZ' as data_type
                        ,sit.action as action
                        from software_lpar sl
                        join software_lpar_map slm on slm.software_lpar_id = sl.id
                        join scan_record sr on sr.id = slm.scan_record_id
                        join software_tlcmz sit on sit.scan_record_id = sr.id
                        where (sl.name = '$shost' or sl.name like '$shostForLike' escape \'\\\')
                        union all
                        select
                        sr.id as sr_id
                        ,sr.bank_account_id as bank_acct_id
                        ,sl.customer_id as customer_id
                        ,sl.id as sl_id
                        ,sl.name as sl_name
                        ,'TADZ' as data_type
                        ,CHAR(sit.action) as action
                        from software_lpar sl
                        join software_lpar_map slm on slm.software_lpar_id = sl.id
                        join scan_record sr on sr.id = slm.scan_record_id
                        join scan_software_item sit on sit.scan_record_id = sr.id
                        where (sl.name = '$shost' or sl.name like '$shostForLike' escape \'\\\')
                        ) as x
                    group by
                        sr_id
                        ,bank_acct_id
                        ,customer_id
                        ,sl_id
                        ,sl_name
                        ,data_type
                        ,action
                    with ur");
            print_rs_html(\@rs);
        };
        if ($@) {
            die "Error: $@\n";
            print $cgi->redirect("$self?error=true");
        }
    }
    footer();
}
