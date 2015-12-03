#!/usr/bin/perl -w
##############################################################################
#
# Move files from staging/ into secondary/, refactoring along the way.
#
# Detailed documentation on this programs usage can be found at the end, or
# by invoking the application with the "--help" or "--man" parameters.
#
# REMEMBER TO RUN PERLTIDY BEFORE -- BEFORE! -- COMMITTING TO CVS!
#
# $Id: perl-app-dbi,v 1.7 2007/03/14 23:46:20 cweyl Exp $
# Based on template Id: perl-app-dbi,v 1.7 2007/03/14 23:46:20 cweyl Exp 
#############################################################################

use strict;
use warnings;

# in case we're working with files on GSA
use filetest 'access';

use English qw{-no_match_vars};
use Fatal qw{open close unlink};
use String::BOM qw(strip_bom_from_file);

use Encode::Guess;

use Carp;
use Pod::Usage;
use Getopt::Long;
use Readonly;

# for debugging
use Smart::Comments '###', '####';
use Carp qw{ confess };

use Archive::Extract;
use File::Copy qw{ mv };
import Fatal 'mv';
use File::Find::Rule;
use File::Slurp qw{ slurp };
use File::Pid;
#use PerlIO::gzip;

use Net::FTPServer::XferLog;

use Log::Log4perl qw{:easy};
$Archive::Extract::PREFER_BIN = 1; 

use HealthCheck::Delegate::EventLoaderDelegate;#Added by Larry for HealthCheck And Monitor Module - Phase 2B

#############################################################################
# globals/constants

# derive version directly from CVS revision.  As good a method as any. use version; our $VERSION = qv((split(/ /, q$Revision: 1.7 $))[1]);

# where we find / move files to
#Readonly my $FROM_DIR   => '/var/ftp/staging';
##Readonly my $FROM_DIR   => '/tmp/foo/staging';
#Readonly my $TO_DIR     => "$FROM_DIR/secondary";
#Readonly my $EXTRACT_TO => "$TO_DIR/tmp";
#Readonly my $FAIL_DIR   => "$FROM_DIR/fail";

# only move files whose mtime is older than min/tmp/foo/staging
Readonly my $LAST_MOD_TIME => time - 5*60;  

Readonly my $PID => '/var/run/staging-move.pid';

# filename regexps
Readonly my $TSV_RE => qr/.+\.tsv$/;
Readonly my $Z_RE   => qr/.+\.Z$/;

#############################################################################
# options, and option declarations

# widely-referred to options we want to reference outside of %opts
my $verbose = 0;
my $test    = 0;    # do not unlink original files

# where we store the options, etc.
my %opts = (

    upload_dir => '/var/ftp/staging',
    to_dir     => '/var/ftp/staging/secondary',
    tmp_dir    => '/var/ftp/staging/secondary/tmp',
    fail_dir   => '/var/ftp/staging/fail',


    mtime_check => 1,

    # don't unlink
    test => \$test,

    # how chatty are we to be?
    verbose => \$verbose,

    # help routines
    help => sub { pod2usage({ '-verbose' => 1 }); },    # brief usage
    man  => sub { pod2usage({ '-verbose' => 2 }); },    # man page
);

# this defines the options, and is later used by parse_options()
my @opt_definitions = (

    # various directories...
    'upload_dir|upload-dir=s',
    'to_dir|to-dir=s',
    'tmp_dir|tmp-dir=s',
    'fail_dir|fail-dir=s',

    # don't unlink
    'test',

    # skip mtime check for testing purposes
    'mtime_check|mtime-check',

    # "standard" options
    'verbose', 'help|?', 'man',
);

#############################################################################
# functions

sub archive_file {
    my $filename = shift @_;

    #my (undef, undef, $basename) = splitdir $filename;
    my $basename     = $filename;
    $basename        =~ s|.*/||;
    my $archive_name = "$opts{to_dir}/$basename.gz";

    DEBUG "Checking encoding: $filename";

#    my $enc = `/usr/bin/enca --guess -L none -i '$filename'`;
    my $enc=guess_encoding($filename);
    $enc=uc$enc->name;
    if (($enc eq 'ASCII') || ($enc eq 'UTF-8') || ($enc eq '???')) {

        DEBUG "encoding is $enc";
    }
    else {
        
        INFO "recoding $basename: $enc -> UTF-8";

        local $CHILD_ERROR;
        mv $filename, "$filename.to-recode";
        system "(cat $filename.to-recode | iconv -f $enc -t UTF-8 > $filename)";
    }

    # This is hokey, but worlds more efficient than reading a line/chunk at a
    # time and writing out using IO::Zlib, etc

    DEBUG "archiving via external gzip: $filename -> $archive_name";
    
    local $CHILD_ERROR;
    system "gzip -c $filename > $archive_name";
    
    confess "Error attempting to compress to $archive_name: $CHILD_ERROR"
        if $CHILD_ERROR;

    return;
}

# parse the file to get our db and password; then return our dbh
sub fetch_dbh {
    
    my @lines = 
        #join q{},
        grep  { /^\$dbs/ }
        slurp '/opt/staging/scripts/stagingImport/DBConnection.pm'
        ;
    my $to_eval = join q{}, @lines;
    
    ### now, eval to get the hash...
    my %dbs;
    eval $to_eval;
    
    ### %dbs

    ### open our connection to the database...
    my $dbh = DBI->connect(
        'dbi:DB2:TRAILS3',
        $dbs{trails3}{user},
        $dbs{trails3}{password},
        { RaiseError => 1 }
    );

    die 'Cannot get dbh: ' . $DBI::errstr unless $dbh;

    ### success! returning dbh...
    return $dbh;
}

# little helper
sub parse_logline { Net::FTPServer::XferLog->parse_line(shift @_) }

sub decompress_z {
    my $z_file = shift @_;

    # note, from the compress man page: "The uncompressed file will have the 
    # mode, ownership and timestamps of the compressed file."

    INFO "uncompressing .Z file: $z_file";
    
    local $CHILD_ERROR;
    system "uncompress $z_file";

    die "Error attempting to uncompress Z $z_file: $CHILD_ERROR"
        if $CHILD_ERROR;

    $z_file =~ s/\.Z$//;
    return $z_file;
}

#############################################################################
# template-standard functions: command line arguments

# configure and parse command line options
sub parse_options {

    # configure Getopt
    Getopt::Long::Configure qw{bundling};

    # get the options
    my $rc = GetOptions(\%opts, @opt_definitions);

    # check for valid parsing...
    die qq{Unknown options.  Try "--help" or "--man".\n} unless $rc;
    
    return $rc;
}

sub validate_options {

    # no specific options needed.

    return;
}

sub remove_white_characters {
    my ($file) = @_;
    DEBUG "Removing white characters from file: ".$file;

    strip_bom_from_file($file);
}


#############################################################################
# main()

## 
## Part the first: setup
##

# juuuuust to make sure
umask 0002;

my $eventTypeName = 'STAGINGMOVE_START_STOP_SCRIPT';#Added by Larry for HealthCheck And Monitor Module - Phase 2B
my $eventObject;#Added by Larry for HealthCheck And Monitor Module - Phase 2B

eval {#Added by Larry for HealthCheck And Monitor Module - Phase 2B
  
# get and validate our options
parse_options();
validate_options();

### init our logger...
Log::Log4perl->easy_init(
    { file => 'STDOUT', level => $DEBUG },
    { file => '>> /var/staging/logs/staging-move', level => $DEBUG },
);

    #Added by Larry for HealthCheck And Monitor Module - Phase 2B Start
    ###Notify Event Engine that we are starting.
    DEBUG "eventTypeName=$eventTypeName";
    INFO "starting $eventTypeName event status";
    $eventObject = EventLoaderDelegate->start($eventTypeName);
    INFO "started $eventTypeName event status";

    sleep 1;#sleep 1 second to resolve the startTime and endTime is the same case if process is too quick
    #Added by Larry for HealthCheck And Monitor Module - Phase 2B End 

INFO 'Beginning run!';

### make sure we're not running already...
DEBUG q{Check to make sure we're not running already};
my $pid = File::Pid->new();
die "$PROGRAM_NAME already running!" if $pid->running;
$pid->write;

## 
## Part the second: file tweaks 
##

### Find and nuke any 0-byte files...
my @losers = File::Find::Rule
    ->file()                   # just files...
    ->maxdepth(1)              # stay in $FROM_DIR
    ->empty()                  # 0-byte only, bitte
    ->mtime("<$LAST_MOD_TIME") # no writes since $LAST_MOD_TIME ago
    ->in($opts{upload_dir})           
    ;

for my $file (@losers) {

    INFO "Nuking 0-byte file: $file";
    unlink $file;
}

### aaaand find anything named gzip, rename to gz...
my @gzips = File::Find::Rule
    ->file()
    ->maxdepth(1)
    ->mtime("<$LAST_MOD_TIME")
    ->name('*.gzip')
    ->in($opts{upload_dir})
    ;

### DEBUG
for my $gzip (@gzips) {

    my $gz = $gzip;
    $gz =~ s/gzip$/gz/;

    INFO "renaming $gzip -> $gz";
}

## 
## Part the third: loop over found files
##


###### %log_entry

### Find our files in: $opts{upload_dir}
my @files = File::Find::Rule->file()
    ->readable()                # file is readable
    ->nonempty()                # > 0-byte
    ->mtime("<$LAST_MOD_TIME")  # no writes since $LAST_MOD_TIME ago
    ->maxdepth(1)               # stay in $FROM_DIR
    #->not_name('ALLYSCCM*')              # files without name
    #->name('TD4DSTANDALONE2_*')          # files with name
    ->size( '>0M' )          # files with size
    ->in($opts{upload_dir})
    ;

my $total = scalar @files;
my $i     = 0;

DEBUG "Found this many files to process: $total";

#### @files

FILE_LOOP:
for my $file (@files) {

    $i++;

    INFO "===> [$i of $total] processing: $file";

    # find our submitter...
    my $from_email;
        $from_email = 'no log entry';

    DEBUG "($file) username: $from_email";

    # check for .Z-ness
    if ($file =~ /.+\.Z$/) {

        local $EVAL_ERROR;
        eval { $file = decompress_z($file); };

        do { ERROR "$EVAL_ERROR"; next FILE_LOOP; } if $EVAL_ERROR;
    }

    if ($file =~ /.+\.tsv$/) {

        remove_white_characters($file);
        ### we're just a tsv: $file
        archive_file($file);
        unlink $file unless $test;
        next FILE_LOOP;
    }

    ### explode archive to: $opts{tmp_dir}
    my $ae = Archive::Extract->new(archive => $file);
    if (not defined $ae) { 
        
        ERROR "Cannot use: $file"; 
        mv $file, $opts{fail_dir};
        next FILE_LOOP; 
    }

    # the actual extraction...
    my $re = $ae->extract(to => $opts{tmp_dir});
    if (not $re) {
        
        ERROR "Cannot use: $file"; 
        mv $file, $opts{fail_dir};
        next FILE_LOOP; 
    }

    my @archive_files = @{ $ae->files };
    
    ### processing from archive: @archive_files
    EXTRACTED_LOOP:
    for my $extracted_file (@archive_files) {

        # FIXME!  should complain loudly when it isn't a .tsv
        $extracted_file = "$opts{tmp_dir}/$extracted_file";

        if (-d $extracted_file) {

            WARN "Is a directory: $extracted_file";
            next EXTRACTED_LOOP;
        }

        ### dealing with extracted file: $extracted_file
        if ($extracted_file !~ $TSV_RE) {
            
            ### bad file in extract loop: $extracted_file
            WARN "failing $extracted_file (from $file)";
            mv $extracted_file, $opts{fail_dir};
            next EXTRACTED_LOOP;
        }

        remove_white_characters($extracted_file);

        ### compressing: $extracted_file
        archive_file($extracted_file);
        unlink $extracted_file;
    }

    ### and deleting the original...
    unlink $file unless $test;
}

### fini...
DEBUG 'Cleaning up pid file...';
$pid->remove;

INFO '===> Finished!';

};#Added by Larry for HealthCheck And Monitor Module - Phase 2B

#Added by Larry for HealthCheck And Monitor Module - Phase 2B Start
if ($@) {
    
    ###Notify the Event Engine that we had an error
    INFO "erroring $eventTypeName event status";
    EventLoaderDelegate->error($eventObject,$eventTypeName);
    INFO "errored $eventTypeName event status";   

    die $@;
}
else {

    ###Notify the Event Engine that we are stopping
    INFO "stopping $eventTypeName event status";
    EventLoaderDelegate->stop($eventObject,$eventTypeName);
    INFO "stopped $eventTypeName event status";
}
#Added by Larry for HealthCheck And Monitor Module - Phase 2B End

__END__ 

# $Log$

#############################################################################
#   This is the brief usage AND manpage of this application.  Document it   #
#                       it well, and wisely!                                #
#############################################################################


# note that "OPTIONS" is shown via --help/-?

=head1 NAME
 
staging-move - move disconnected files from staging/ to secondary/ 
 

=head1 VERSION
 
This documentation refers to staging-move version 1.0. 
 
 
=head1 USAGE
 
    ./staging-move 
 
=head1 OPTIONS
 
Usage: staging-move [opts]

    # general options
    --test          Do not unlink the original files from staging/

    # help options
    --help,-?       Displays this help message
    --man           Displays the full man page
    --version       Displays version information
 
=head1 DESCRIPTION
 
Move files from staging/ to secondary/.  Simple enough :)

Files in staging/ are processed if and only if they have not been modified in
the last 5 minutes (that is, their mtime is older than 5 min).

Archive::Extract is used to explode anything without a .tsv extension; as a
result, any file type / combo currently supported by Archive::Extract -- its
man page has a full list -- is supported here as well.
 
Additionally, an override to support .Z compressed files is used.

=head1 DIAGNOSTICS

Note extensive diagnostics can be enabled by uncommenting "use
Smart::Comments".

This proggie dies on all errors.  An error is defined as being unable to
read/write to something.
 

=head1 CONFIGURATION AND ENVIRONMENT

All configuration is handled in the file itself (see the section "CONSTANTS").

 
=head1 DEPENDENCIES

This scriptie requires perl5. The following non core modules are required:

 Archive::Extract;
 
 File::Find::Rule;

 Readonly

Additionally, if you desire debugging capabilities, Smart::Comments is also
required.

=head1 INCOMPATIBILITIES

None known.

=head1 BUGS AND LIMITATIONS

None known.  Please email the author if you believe any have been discovered
:)

=head1 AUTHOR

Chris Weyl <cweyl@us.ibm.com>

=head1 LICENCE AND COPYRIGHT
 
(c) Copyright IBM 2005-2007.  All Rights Reserved.

This is revision $Id: perl-app-dbi,v 1.7 2007/03/14 23:46:20 cweyl Exp $.

=cut 


