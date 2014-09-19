package Base::Utils;

#
# includes
#
use strict;
use Exporter;
use File::Copy;
use File::Basename;
use Data::Dumper;
use Sys::Hostname;
use Log::Log4perl;
use Log::Log4perl::Layout;
use Log::Log4perl::Level;
use Log::Dispatch::FileRotate;

#
# package globals
#
use vars qw(
    @ISA
    @EXPORT
    $DEBUG_LEVEL
    $LOGFILE
);

$DEBUG_LEVEL = "info";
$LOGFILE     = undef;
my $logger     = undef;
my $init_done  = 0;
my $tmpLogFile = "/tmp/";

#
# exporter setup
#
@ISA = qw(Exporter);

@EXPORT = qw(
    logging_level
    logfile
    rollLog
    elog
    wlog
    mlog
    ilog
    dlog
    logMsg
    trim
    cleanValues
    upperValues
    blank2undef
    cleanArray
    printRec
    logRec
    dump
    stringEqual
    stringEqualOrBothUndef
    numericEqualOrBothUndef
    loaderStart
    loaderCheckForStop
    validateServer
    currentTimeStamp
    dbstamp
);

#
# logging methods
#
sub logging_level {
    my $value = shift;
    if (   $value eq "error"
        || $value eq "warn"
        || $value eq "info"
        || $value eq "debug" )
    {
        $DEBUG_LEVEL = $value if defined($value);
    }
    return $DEBUG_LEVEL;
}

sub logfile {
    my $value = shift;
    $LOGFILE = $value if defined($value);
    return $LOGFILE;
}

sub init_log4perl {

    my $tmpFileName = shift;

    $logger = Log::Log4perl->get_logger();

    # Define a layout
    my $layout = Log::Log4perl::Layout::PatternLayout->new("%m");

    my $appender = undef;
    my $logfile  = undef;

    # Define a file appender
    if ( defined $LOGFILE ) {
        $logfile = $LOGFILE;
    }
    else {
        $logfile = $tmpLogFile . $tmpFileName . '.log';
    }
    $appender = Log::Log4perl::Appender->new(
        "Log::Dispatch::FileRotate",
        filename => $logfile,
        mode     => 'append',
        size     => 10000000,
        max      => 5
    );

    ###Use the file appender
    $appender->layout($layout);

    $logger->add_appender($appender);
    $logger->level( uc($DEBUG_LEVEL) );
}

sub rollLog {
    ###Since we are using FileRotate appender in log4perl, we don't need this anymore.
    ###We will just return 1 to keep backward compatibility
    return 1;

    ###This code is not needed anymore - leaving for now
    my $maxsize = shift;
    die "Must pass maxsize arg to rollLog sub!\n"
        unless defined $maxsize && $maxsize =~ m/\d+/;
    return undef unless defined $LOGFILE;
    return undef unless -e $LOGFILE;
    my $size = ( -e "$LOGFILE.1" ) ? -s "$LOGFILE.1" : 0;
    move( "$LOGFILE.1", "$LOGFILE.2" )
        if ( -e "$LOGFILE.1" && $size > $maxsize );
    open( LOG1, ">>$LOGFILE.1" )
        or die "Unable to append file $LOGFILE.1: $!";
    open( LOG, "<$LOGFILE" ) or die "Unable to read file $LOGFILE: $!";

    while (<LOG>) {
        print LOG1;
    }
    close(LOG);
    close(LOG1);
    unlink "$LOGFILE" or die "ERROR: Unable to unlink file $LOGFILE: $!";
    return 1;
}

sub logit {
    my $level = shift;
    my $pkg   = shift;
    my $file  = shift;
    my $line  = shift;
    my $msg   = shift;
    chomp $msg;
    $msg =~ s/^\s+|\s+$//g;
    my ( $sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst )
        = localtime();
    my $dt = sprintf(
        "%04d-%02d-%02d %02d:%02d:%02d",
        $year + 1900,
        $mon + 1, $mday, $hour, $min, $sec
    );
    my $bfile  = basename($file);
    my $string = "[$dt][$level][$bfile:$line] $msg\n";

    if ( $level eq "ERROR" ) {
        print STDERR $string;
    }
    else {
        print STDOUT $string;
    }
    if ( defined($LOGFILE) ) {
        open( LOGFILE, ">>$LOGFILE" )
            or die "ERROR: Unable to open logfile $LOGFILE: $!";
        print LOGFILE $string;
        close(LOGFILE);
    }
}

sub format_log {
    my $level = shift;
    my $pkg   = shift;
    my $file  = shift;
    my $line  = shift;
    my $msg   = shift;
    chomp $msg;
    $msg =~ s/^\s+|\s+$//g;
    my ( $sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst )
        = localtime();
    my $dt = sprintf(
        "%04d-%02d-%02d %02d:%02d:%02d",
        $year + 1900,
        $mon + 1, $mday, $hour, $min, $sec
    );
    my $bfile  = basename($file);
    my $string = "[$dt][$level][$bfile:$line] $msg\n";

    ###First time around, init the log4perl engine
    if ( $init_done == 0 ) {
        init_log4perl( substr( $bfile, 0, index( $bfile, '.' ) ) );
        $init_done = 1;
    }

    return $string;
}

sub elog {
    my $msg = shift;
    my ( $pkg, $file, $line ) = caller;
    $logger->log( $ERROR, format_log( "ERROR", $pkg, $file, $line, $msg ) );

    my $bfile = basename($file);

    ###Do not email if test.
    my $host = hostname;
    my $shost = ( split( /\./, $host ) )[0];
    return if $shost eq 'tap2';
    return if $shost eq 'tapmf';

    `echo "$msg" "$bfile" >> /tmp/tmp_err.txt`;

    # `echo "$msg" |mail -s "elog alert: $bfile" lamm\@us.ibm.com`;
    # `echo "$msg" |mail -s "elog alert: $bfile" alexmois\@us.ibm.com`;
    # `echo "$msg" |mail -s "elog alert: $bfile" dbryson\@us.ibm.com`;
}

sub wlog {
    return
        unless ( $DEBUG_LEVEL eq "warn"
        || $DEBUG_LEVEL eq "info"
        || $DEBUG_LEVEL eq "debug" );
    my $msg = shift;
    my ( $pkg, $file, $line ) = caller;
    $logger->warn( format_log( "WARN", $pkg, $file, $line, $msg ) );
}

sub ilog {
    return unless ( $DEBUG_LEVEL eq "info"
        || $DEBUG_LEVEL eq "debug" );
    my $msg = shift;
    my ( $pkg, $file, $line ) = caller;
    $logger->info( format_log( "INFO", $pkg, $file, $line, $msg ) );
}

sub mlog {
	 return unless ( $DEBUG_LEVEL eq "error"
        || $DEBUG_LEVEL eq "debug" );
    my $msg = shift;
    my ( $pkg, $file, $line ) = caller;
    $logger->log( $ERROR, format_log( "MESSAGE", $pkg, $file, $line, $msg ) );
}

sub dlog {
    return unless ( $DEBUG_LEVEL eq "debug" );
    my $msg = shift;
    my ( $pkg, $file, $line ) = caller;
    $logger->debug( format_log( "DEBUG", $pkg, $file, $line, $msg ) );

}

sub logMsg {
    my $msg = shift;
    my ( $pkg, $file, $line ) = caller;
    $logger->log( $FATAL, format_log( "LOG", $pkg, $file, $line, $msg ) );
}

#
# misc string methods
#
sub trim {
    my ($string) = @_;
    $string =~ s/^\s+//;
    $string =~ s/\s+$//;
    return $string;
}

sub cleanValues {
    my ($rec) = @_;

    ###Loop through values
    foreach my $field ( keys %{$rec} ) {

        my $value = $rec->{$field};

        ###Trim leading and trails white space
        $value = trim($value) if defined $value;
        $rec->{$field} = $value if defined $value;
    }
}

sub upperValues {
    my ($rec) = @_;

    ###Loop through values
    foreach my $field ( keys %{$rec} ) {

        my $value = $rec->{$field};

        ###Trim leading and trails white space
        $value = uc($value) if defined $value;
        $rec->{$field} = $value if defined $value;
    }
}

sub blank2undef {
    my ($rec) = @_;
    foreach my $key ( keys %{$rec} ) {
        my $val = $rec->{$key};
        if ( defined $val ) {
            $val =~ s/^\s+//g;
            $val =~ s/\s+$//g;
            if ( $val eq '' ) {
                $rec->{$key} = undef;
            }
        }
    }
}

sub cleanArray {
    my (@array) = @_;

    ###Loop through values
    for ( my $i = 0; $i < $#array; $i++ ) {
        my $value = $array[$i];

        ###Trim leading and trails white space
        $value = trim($value) if ($value);
        $array[$i] = $value if ($value);
    }

    return @array;
}

sub upperArray {
    my (@array) = @_;

    ###Loop through values
    for ( my $i = 0; $i < $#array; $i++ ) {
        my $value = $array[$i];

        ###Trim leading and trails white space
        $value = uc($value) if ($value);
        $array[$i] = $value if ($value);
    }

    return @array;
}

sub printRec {
    my ($rec) = @_;
    my $s = "[rec] ";
    foreach my $key ( sort keys %{$rec} ) {
        $s .= $key . "=";
        $s .= $rec->{$key} if defined $rec->{$key};
        $s .= ",";
    }
    chop $s;
    print STDOUT "$s\n";
}

sub logRec {
    my ( $level, $rec ) = @_;
    my $s = "[rec] ";
    foreach my $key ( sort keys %{$rec} ) {
        $s .= $key . "=";
        $s .= $rec->{$key} if defined $rec->{$key};
        $s .= ",";
    }
    chop $s;
    if ( $level eq "dlog" ) {
        dlog($s);
    }
    elsif ( $level eq "ilog" ) {
        ilog($s);
    }
    elsif ( $level eq "wlog" ) {
        wlog($s);
    }
    elsif ( $level eq "elog" ) {
        elog($s);
    }
}

sub dump {
    my ($data) = @_;
    print STDOUT Dumper( \$data );
}

sub stringEqual {
    my ( $a, $b ) = @_;
    my $equal = 0;

    $a = undef if $a eq "";
    $b = undef if $b eq "";

    if ( defined $a ) {
        if ( defined $b ) {
            if ( $a eq $b ) {
                $equal = 1;
            }
        }
    }
    else {
        if ( !defined $b ) {
            $equal = 1;
        }
    }

    return $equal;
}

sub stringEqualOrBothUndef {
    my ( $a, $b ) = @_;
    my $equal = 0;

    if ( defined $a ) {
        if ( defined $b ) {
            if ( $a eq $b ) {
                $equal = 1;
            }
        }
    }
    else {
        if ( !defined $b ) {
            $equal = 1;
        }
    }

    return $equal;
}

sub numericEqualOrBothUndef {
    my ( $a, $b ) = @_;
    my $equal = 0;
    if ( defined $a ) {
        if ( defined $b ) {
            if ( $a == $b ) {
                $equal = 1;
            }
        }
    }
    else {
        if ( !defined $b ) {
            $equal = 1;
        }
    }

    return $equal;
}

sub loaderStart {

    ###Set usage message.
    my $baseName = basename($0);
    my $msg      = "Usage: $baseName [run-once|start|stop]\n";

    ###Check action argument was passed by user.
    my $action = shift;
    die $msg if ( !defined $action || $action =~ m/^\s+$/ );

    ###Check pid file argument.
    my $pidFile = shift;
    die "ERROR: Must pass pidFile arg to loaderStart sub!!\n"
        if ( !defined $pidFile || $pidFile =~ m/^\s+$/ );

    ###Handle action.
    if (   $action eq "run-once"
        || $action eq "start" )
    {

        ###Make sure not already running.
        if ( -e "$pidFile" ) {

            ###Check pid is running.
            my $pid;
            open( PIDFILE, "<$pidFile" )
                or die "ERROR: Unable to read pid file $pidFile: $!";
            while (<PIDFILE>) {
                chomp;
                next unless /^pid=/;
                $pid = ( split(/\=/) )[1];
            }
            close(PIDFILE);
            die "ERROR: Unable to get pid from pid file $pidFile!!\n"
                unless defined $pid;

            if ( -e "/proc/$pid" ) {

                ###Already running.
                print "$pid Loader is already running.\n";
                exit 0;
            }

            ###Not running, remove pid file.
            unlink "$pidFile";
        }

        ###Create pid file.
        open( PIDFILE, ">$pidFile" )
            or die "ERROR: Unable to write pid file $pidFile: $!";
        print PIDFILE "pid=$$\n";
        print PIDFILE "STOP\n"
            if $action eq "run-once";
        close(PIDFILE);
    }
    elsif ( $action eq "stop" ) {

        ###Respond to user based on pid file existance.
        if ( -e "$pidFile" ) {

            ###Check pid is running.
            my $pid;
            open( PIDFILE, "<$pidFile" )
                or die "ERROR: Unable to read pid file $pidFile: $!";
            while (<PIDFILE>) {
                chomp;
                next unless /^pid=/;
                $pid = ( split(/\=/) )[1];
            }
            close(PIDFILE);
            die "ERROR: Unable to get pid from pid file $pidFile!!\n"
                unless defined $pid;

            if ( !-e "/proc/$pid" ) {

                ###Not running, remove pid file.
                print "Loader not currently running.\n";
                unlink "$pidFile";
                exit 0;
            }

            ###Flag pid file for stop.
            open( PIDFILE, ">>$pidFile" )
                or die "ERROR: Unable to append to pid file $pidFile: $!";
            print PIDFILE "STOP\n";
            close(PIDFILE);
            print "Alterted loader to stop after current load, "
                . "please wait for process to stop gracefully.\n";
            exit 0;
        }
        else {
            print "Loader not currently running.\n";
            exit 0;
        }
    }
    else {
        die $msg;
    }
}

sub loaderCheckForStop {

    ###Check pid file argument.
    my $pidFile = shift;
    die "ERROR: Must pass pidFile arg to loaderCheckForStop sub!!\n"
        if ( !defined $pidFile || $pidFile =~ m/^\s+$/ );

    my $stop = 0;

    ###Check pid file exists.
    if ( -e "$pidFile" ) {

        ###Check if we should stop.
        my $flag = 0;
        open( PIDFILE, "<$pidFile" )
            or die "ERROR: Unable to read pid file $pidFile: $!";
        while (<PIDFILE>) {
            chomp;
            next unless /STOP/;
            $flag = 1;
        }
        close(PIDFILE);

        if ( $flag == 1 ) {

            unlink "$pidFile";
            $stop = 1;
        }
    }
    else {

        ###No pid file, stop.
        unlink "$pidFile";
        $stop = 1;
    }

    return $stop;
}

sub validateServer {
    my ($validShost) = @_;
    my $host = hostname;
    my $shost = ( split( /\./, $host ) )[0];
    if (   $shost eq $validShost
        || $shost eq 'tap2'
        || $shost eq 'tapmf'
        || $shost eq 'IBM-5AEEDFA3CF9'
        || $host  eq 'IBM-AFDBBE3079D'
        || $host  eq 'IBM-A867E5B5854'
        || $host  eq 'CALIOTO-WXP'
        || $host  eq 'lexbz2250' ) 
    {
        return 1;
    }
    else {
        return 0;
    }
}

sub currentTimeStamp {
    my ( $sec, $min, $hour, $mday, $mon, $year, $wday, $yday ) = localtime();
    return sprintf(
        "%04d-%02d-%02d-%02d.%02d.%02d.000000",
        ( $year + 1900 ),
        ( $mon + 1 ),
        $mday, $hour, $min, $sec
    );
}

sub isValidIpAddress {
    my ($ipStr) = @_;

    # if ($ipStr !~ /([^.]+)\.([^.]+)\.([^.]+)\.([^.]+)/) {
    # a.b.c.d will be considered as legal ip address
    # without ^ and $ below -123.235.1.248 is a legal ip address
    if ( $ipStr !~ /^([\d]+)\.([\d]+)\.([\d]+)\.([\d]+)$/ ) {
        return 0;
    }

    my $s;
    my $notIp;
    foreach $s ( ( $1, $2, $3, $4 ) ) {
        print "s=$s;";
        if ( 0 > $s || $s > 255 ) {
            $notIp = 1;
            last;
        }
    }
    if ($notIp) {
        return 0;
    }
    else {
        return 1;
    }
}

sub dbstamp {
    my ( $self, $stamp ) = @_;
    use Time::Local;
    my $localtime = $stamp ? $stamp : timelocal( localtime() );

    my @localtime = localtime($localtime);
    my $rc        = sprintf(
        "%04d-%02d-%02d-%02d.%02d.%02d.000000",
        $localtime[5] + 1900,
        $localtime[4] + 1,
        $localtime[3], $localtime[2], $localtime[1], $localtime[0]
    );
}

1;