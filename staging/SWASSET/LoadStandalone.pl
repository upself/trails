#!/usr/local/bin/perl
#-----------------------------------------------------------------------------#
# Author:    Thomas Newton
# Contact:   newtont@us.ibm.com
# Copyright: IBM Global Services
#-----------------------------------------------------------------------------#
# This script will run once a minute and load information into the swasstdb
# database.
#
# If the script is already running, then it will not load another instance.
# 
# Likewise, if the assetftp user is using the ftpd process then the script
# assumes an upload is occurring and will not initiate another load.
#-----------------------------------------------------------------------------#
#my $sql_file = "/opt/sigbank/sql/tap.sql.pl";


# LIBRARIES
#-----------------------------------------------------------------------------#
use strict;
use Tap::NewPerl;
use File::Copy;
use Getopt::Std;
use MifParser::MifParse;
use MifParser::inv40::Inv40;

# GLOBALS
#-----------------------------------------------------------------------------#
my $DEBUG    = 0;
my $DEPOT    = '/var/ftp/scan';
my $FINISHED = "$DEPOT/inv_complete";
my $TEMP     = "$DEPOT/inv_work";
my $BAD      = "$DEPOT/inv_error";
my $REGISTER = "$DEPOT/inv_unregistered";
my $GARBAGE  = "$DEPOT/inv_garbage";
my $LOGS     = "$DEPOT/inv_logs";
my $LOG      = "$LOGS/loadmif.".fstamp().".log";
my $LOCK     = "$DEPOT/.loadmif_lock";

# SETUP STEPS
#-----------------------------------------------------------------------------#

# Flush STDOUT
$| = 1;

# validation
validate_run();

# open log handles
open LOG, ">>$LOG";

# get database handles
my $trailsConnection = Database::Connection->new('trails');
my $swassetConnection = Database::Connection->new('swasset');







# standard getopts
getopts("dh");
usage() if $opt_h;

# MAIN
#-----------------------------------------------------------------------------#
# open the depot directory that holds teh .tar files
opendir(BIN, $DEPOT) or die "Can't open $DEPOT: $!";
while ( defined (my $file = readdir BIN) ) {

#next unless $file eq '34280.tar';


    next if $file =~ /^\.\.?$/;     # skip . and ..
    if ( $file !~ /\.tar$/i ) {
        next if $file =~ /^inv_/;
        logger ("moving file $file to $GARBAGE");
        move("$DEPOT/$file","$GARBAGE");
        next;
    }
   
    my $orig_file = $file;
    $file = uc($file); 
    $file =~ s/\.TAR$/\.tar/;

    logger("reading $file");

    $CUSTOMER = undef;  # Init global customer

    my $archive_file = bigfstamp().".$file";

    unless (exists $map->{$file}) {
        logger("TAR NOT FOUND IN CUSTOMER LOOKUP: $file");
        move("$DEPOT/$orig_file","$REGISTER/$archive_file");
        next;
    }

    $CUSTOMER = $file;
    $CUSTOMER =~ s/\.tar//i;
    
    if (checktar($orig_file)) {
        clear_db($file) if $opt_d; ### CAUTION ####
        # clear the working directory of past garbage
        init();
        extract_and_save($orig_file);
        logit("finished importing ... moveing to archive");
        move("$DEPOT/$orig_file","$FINISHED/$archive_file");
        logit("finished importing ... sending status");
        #send_status($file);
        #load_wiz($file);
    }
    else {
        logit(" move\($DEPOT/$orig_file\,$BAD/$archive_file\)");
        move("$DEPOT/$orig_file","$BAD/$archive_file");
    }

}
closedir BIN;

# CLEANUP
#-----------------------------------------------------------------------------#
$dbh->disconnect();
$dbhwiz->disconnect();
close LOG;
`chown www.www $LOG`;
close WIZLOG;

#-----------------------------------------------------------------------------#
#                                   Subs
#-----------------------------------------------------------------------------#
sub logger {
    my $string = shift;
    chomp $string;
    #print  "[".stamp()."] $string\n";

    if ($CUSTOMER) {
         my $customer_log = "$LOGS/$CUSTOMER.".fstamp().".log";
         open CUSTOMER_LOG, ">>$customer_log";
         print CUSTOMER_LOG "[".stamp()."] $string\r\n";
         close CUSTOMER_LOG;
         `chown www.www $customer_log`;
    }

    print LOG "[".stamp()."] $string\n";
}
#-----------------------------------------------------------------------------#
sub bigfstamp {
    my @localtime = localtime();
    my $rc = sprintf("%04d-%02d-%02d.%02d%02d%02d", $localtime[5]+1900,
        $localtime[4]+1, $localtime[3], $localtime[2], $localtime[1],
        $localtime[0]);
}
#-----------------------------------------------------------------------------#
sub checktar {
    my $file = shift;

    my $cmd = "tar -tvf $DEPOT/$file 2>&1";
    my @count = `$cmd`;

    if ($?) {
        my $number = (scalar @count) -1;
        logger ("ERROR $file $number (found in checktar)");
        return 0;
    }
    else {
        # Check for subdirs
        foreach my $subfile (@count) {
        # Fix for wierd ownership problems, only look at last array entry
            my $file = (split(/\s+/,$subfile))[-1];
            my @check = split (/\//,$file);
            if ((scalar @check == 2)) {
                unless ($subfile =! /\.$/) {
                    logger("SUBDIRS $file");
                }
            }
            if ((scalar @check) > 2) {
                logger("SUBDIRS $file");
                return 0;
            }
        }

        my $number = scalar @count;
        logger ("OK $file $number");
        return 1;
    }
}
#-----------------------------------------------------------------------------#
sub send_status {
    my $fn = shift;
    return unless $CUSTOMER;

    my $customer_log = "$LOGS/$CUSTOMER.".fstamp().".log";

#    my $select = "select contacts.email from contacts,customer where " .
#        "contacts.customer_id = customer.customer_id and ".
#        "customer.customer_name = \'".$map->{$fn}->{"NAME"}."\' and ".
#        "customer.sdc = \'".$map->{$fn}->{"SDC"}."\' and ".
##        "customer.account_type = \'".$map->{$fn}->{"AC"}."\' and ".
#        "customer.usf_version = \'".$map->{$fn}->{"USF"}."\' ";
#
#    my $sth = $dbhwiz->prepare("$select");
##
#    $sth->execute();
    
    my $send_list = 'alexmois@us.ibm.com,adilling@us.ibm.com,gardnerj@us.ibm.com,ldunkin@us.ibm.com,cweyl@cicero.sby.ibm.com,bvail@us.ibm.com,rauj@us.ibm.com,dhiggins@us.ibm.com,antucker@us.ibm.com';
 
#    while (my @columns = $sth->fetchrow_array() ) {
#        $send_list .= " $columns[0] ";
#    }

    my $customer_name = $map->{"$fn"};

    open (MAIL, "|/usr/lib/sendmail -f 'swasset' -t");

    print MAIL "Mime-Version: 1.0\n";
    print MAIL "To: $send_list\n";
    print MAIL "Subject: Load Log for: $CUSTOMER\n";
    print MAIL "Content-Type: multipart/mixed; boundary=boundarystring\n";
    print MAIL "--boundarystring\n";
    print MAIL "Content-Type: text/plain\n\n";
    print MAIL "Machine Generated: Do not reply to this email\n\n\n";
    print MAIL "--boundarystring\n";
    print MAIL "Content-Type: text/binary\n";
    print MAIL "Content-Disposition: attachment; filename=$customer_log\n";
    print MAIL "--boundarystring--\n";
    
    open CUSTOMER_LOG, $customer_log;

    while (<CUSTOMER_LOG>) {
        print MAIL;
    }

    close CUSTOMER_LOG;
    close (MAIL);
   
}
#-----------------------------------------------------------------------------#


#-----------------------------------------------------------------------------#
sub usage {
    print "loadmif -h (this screen)\n";
    print "loadmif -d (delete the account first)\n";
    cleanup($dbh);
    exit 0;
}
#-----------------------------------------------------------------------------#
sub validate_run {
 
    my $progname  = `basename $0`;
    chomp $progname;

    foreach (`ps -ef | grep assetftp | grep ftpd |grep -v grep`) {
        print STDERR "An upload is being peformed, try again later...\n";
        exit 0;
    }

    my $cmd = "ps -ef | grep -v grep  | grep -c $progname";
    if (scalar `$cmd` >= 3 ) {
        print STDERR "This program is currently running, try again later...\n";
        exit 0;
    }


}
#-----------------------------------------------------------------------------#
# clear out the emp working directory
sub init {
    opendir(BININIT, $TEMP) or die "Can't open $TEMP: $!";
    while ( defined (my $file = readdir BININIT) ) {
        next if $file =~ /^\.\.?$/;     # skip . and ..
        unlink("$TEMP/$file");
    }
    closedir BININIT;
}
#-----------------------------------------------------------------------------#
sub extract_and_save  {
    my $extract = shift;
    my $mif     = $extract;
    $mif        =~ s/\.tar$//i;

    logger("Extracting $extract");

    my @count = `cd $TEMP;tar -xvf $DEPOT/$extract`;
   
    logger(("Extracted ".scalar @count." $extract"));

    opendir(BINEXTRACT, $TEMP) or die "Can't open $TEMP: $!";

    logger("creating mifs from individual files");
    while ( defined (my $file = readdir BINEXTRACT) ) {
        next if $file =~ /^\.\.?$/;     # skip . and ..
     
        my $next = 1;
        my $tar  = $file;

        if ($file =~ /.*\.Z$/) {
            $next = 0;
            $tar =~ s/\.Z$//;
        }
        if ($file =~ /.*\.z$/) {
            $next = 0;
            $tar =~ s/\.z$//;

            #### 06/22/2004 - FSD - uncompress won't work on .z files.  have to move to .Z
            qx(mv $TEMP/$file $TEMP/$tar.Z);
            $file =~ s/\.z$/\.Z/;
        }
        
        next if $next;
    
        logger(("uncompress $TEMP/$file"));
        `uncompress $TEMP/$file`;

        my $error = 0;
        if ($?) {
            $error = 1;
            logger("COMPRESSION ERROR: $extract -> $file");
            `tar -tvf $TEMP/$file`;
  
            if ($?) {
                logger("COULD NOT FIX COMPRESSION ERROR $extract -> $file");
            }
            else {
                $error = 0;
                logger("FIXED COMPRESSION ERROR $extract -> $file");
                my $fixed = $file;
                $fixed =~ s/\.Z$//;
                move ("$TEMP/$file","$TEMP/$fixed");
            }
        }
       
            
        unless ($error) {
            logger("COMPRESSION OK: $extract -> $file");
            `cd $TEMP;tar -xvf $TEMP/$tar`;
            logger("changing to cd $TEMP;tar -xvf $TEMP/$tar");
            unlink("$TEMP/$tar");
            logger("deleting $TEMP/$tar");
            $tar =~ s/(.*)\.tar$/$1/i;
            my $import = "$mif.$tar.import";
            `rm $TEMP/tivwscan.mif`; 
            `cat $TEMP/*.mif $TEMP/*.MIF > $TEMP/$import 2>/dev/null`;
            `rm $TEMP/*.mif 2>&1 > /dev/null`;
            `rm $TEMP/*.MIF 2>&1 > /dev/null`;
            logger("cleaning $TEMP/*.mif");
          
            # parse and store in the db
            savemif($import);
            unlink("$TEMP/$import");
        }
    }

    closedir BINEXTRACT;

}
#-----------------------------------------------------------------------------#
sub savemif {
    my $mif = shift;

    my @fileparts = split (/\./,$mif);

    ### I HATE THIS -- TLN -- WHY DID I DO IT THIS WAY????
    #my $sdc  =      shift @fileparts;
    #my $type =      shift @fileparts;
    #my $customer_short =  shift @fileparts;
    #$customer_short = uc($customer_short);
    my $cKey = shift @fileparts;
    my $customer = $cKey;

    #my $customer       = $map->{"$sdc.$type.$customer_short.tar"}->{NAME};
    $customer = $dbh->quote($customer);
    #pop @fileparts;

    #$sdc      = uc($sdc);
    #$type     = uc($type);


    pop @fileparts;
    my $hostname = uc(join "\.",@fileparts);
    $hostname =~ s/\.invscan//i;
    logger("parsing mif file");

    my $parse = MifParse->new;
    my $inv40 = Inv40->new;

    $parse->parse("$TEMP/$mif");

    $inv40->debug(0);
    $inv40->parser($parse);
    $inv40->format("db2");
    $inv40->hwsysid("$cKey.$hostname");
    $inv40->mifFile("$TEMP/$mif");
    $inv40->components(0,"ComponentID");
    $inv40->components(1,"ScanInfo");
    $inv40->components(2,"Regional");
    $inv40->components(3,"Operating System");
    $inv40->components(4,"TIV_Signature_Keys");
    $inv40->components(5,"TIV_Registry_Entries");
    $inv40->components(6,"TIV_Header_Data");
    $inv40->components(7,"Processor");
    $inv40->components(8,"Partition");
    $inv40->components(9,"WIN_AUTH");
    $inv40->components(10,"CPU_COUNT");
    $inv40->components(11,"IP Address");
    $inv40->components(12,"Memory");
    $inv40->components(13,"Storage");

    #print $inv40->getData();

    if ($inv40->getData()) {
    logger("getting SQL");
    my @sql = @{$inv40->getData()};

    unshift @sql, "insert into computer (computer_sys_id,tme_object_id,".
             "tme_object_label,computer_scantime) values (\'".$inv40->hwsysid()."\',".
             $customer.",\'".$hostname."\',CURRENT TIMESTAMP)";

    unshift @sql, "delete from computer where computer_sys_id = \'".
            $inv40->hwsysid()."\'";
    unshift @sql, "delete from computer_sys_mem where computer_sys_id = \'".
            $inv40->hwsysid()."\'";
    unshift @sql, "delete from inst_header_info where computer_sys_id = \'".
            $inv40->hwsysid()."\'";
    unshift @sql, "delete from matched_sware where computer_sys_id = \'".
            $inv40->hwsysid()."\'";
    unshift @sql, "delete from inst_nativ_sware where computer_sys_id = \'".
            $inv40->hwsysid()."\'";
    unshift @sql, "delete from inst_processor where computer_sys_id = \'".
            $inv40->hwsysid()."\'";
    unshift @sql,"delete from win_auth where computer_sys_id = \'".
            $inv40->hwsysid()."\'";
    unshift @sql,"delete from cpu_count where computer_sys_id = \'".
            $inv40->hwsysid()."\'";
    unshift @sql,"delete from inst_partition where computer_sys_id = \'".
            $inv40->hwsysid()."\'";
    unshift @sql,"delete from storage_dev where computer_sys_id = \'".
            $inv40->hwsysid()."\'";
    unshift @sql,"delete from ip_addr where computer_sys_id = \'".
            $inv40->hwsysid()."\'";


    logger("executing SQL");
    foreach my $query (@sql) {
        my $sth = $dbh->prepare($query);
        $sth->execute();
        #logger($query);
        dbErr($query) if $DBI::err;
    }

    logger("COMPLETE: $cKey.$hostname");
    }
}
#-----------------------------------------------------------------------------#
sub get_tables {
    my @tables = qw (win_auth inst_header_info inst_nativ_sware inst_processor
        matched_sware computer);

    return @tables;
}
#-----------------------------------------------------------------------------#
sub clear_db {
    my $file = shift;

    ##### CAUTION, THIS COULD BE DANGERIOUS #####

    my $customer = (split(/\./,$file))[0];
    my $sysid = $customer;
 
    logger ("Clearing the db of $sysid");

    my $query = "select computer_sys_id from computer where computer_sys_id".
        " like  \'$sysid\%\'";

    my $sth = $dbh->prepare($query);

    $sth->execute();

    my @deletable;
    while (my @columns = $sth->fetchrow_array() ) {
        push @deletable, $columns[0];
    }


    foreach (get_tables($dbh)) {
        logger("clearing: $_ of $sysid");
        foreach my $csysid (@deletable) {
            my $query = "delete from $_ where computer_sys_id = \'$csysid\'";
            my $sth = $dbh->prepare("$query");
            $sth->execute();
            dbErr($query) if $DBI::err;
        }
    }
}

