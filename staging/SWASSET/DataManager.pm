package SWASSET::DataManager;

use strict;
use File::Find;
use File::Copy;
use File::Basename;
use Base::Utils;
use Database::Connection;
use Sigbank::Delegate::SystemScheduleStatusDelegate;
use Sigbank::Delegate::BankAccountDelegate;
use CNDB::Delegate::CNDBDelegate;
use BRAVO::Delegate::BRAVODelegate;
use BRAVO::OM::SoftwareLpar;
use BRAVO::OM::InstalledSoftware;
use Staging::Delegate::StagingDelegate;
use Staging::OM::SoftwareLpar;
use Staging::OM::ScanRecord;

###Object constructor.
sub new {
    my ($class) = @_;
    my $self = {
                 _testMode      => undef,
                 _applyChanges  => undef,
                 _logsDir       => undef,
                 _cleanupDir    => undef,
                 _completeDir   => undef,
                 _managerScript => undef
    };
    bless $self, $class;
    dlog("instantiated self");

    return $self;
}

###Object get/set methods.
sub testMode {
    my ( $self, $value ) = @_;
    $self->{_testMode} = $value if defined($value);
    return ( $self->{_testMode} );
}

sub applyChanges {
    my ( $self, $value ) = @_;
    $self->{_applyChanges} = $value if defined($value);
    return ( $self->{_applyChanges} );
}

sub logsDir {
    my ( $self, $value ) = @_;
    $self->{_logsDir} = $value if defined($value);
    return ( $self->{_logsDir} );
}

sub cleanupDir {
    my ( $self, $value ) = @_;
    $self->{_cleanupDir} = $value if defined($value);
    return ( $self->{_cleanupDir} );
}

sub completeDir {
    my ( $self, $value ) = @_;
    $self->{_completeDir} = $value if defined($value);
    return ( $self->{_completeDir} );
}

sub managerScript {
    my ( $self, $value ) = @_;
    $self->{_managerScript} = $value if defined($value);
    return ( $self->{_managerScript} );
}

###Primary method used by calling clients.
sub load {
    my ( $self, %args ) = @_;

    dlog("start load method");

    ###Check and set arguments.
    dlog("checking passed arguments");
    $self->checkArgs( \%args );
    dlog("checked passed arguments");

    ###Set the job name of this script to update the status
    my $job = 'SWASSET DATA MANAGER';
    dlog("job=$job");

    my $systemScheduleStatus;
    if ( $self->applyChanges == 1 ) {
        ###Notify the scheduler that we are starting
        ilog("starting $job system schedule status");
        $systemScheduleStatus = SystemScheduleStatusDelegate->start($job);
        ilog("started $job system schedule status");
    }

    ###Get swasstdb bank account
    dlog("getting swasstdb bank account");
    my $swasstdbBankAccount = Sigbank::Delegate::BankAccountDelegate->getBankAccountByName('SWASSTDB');
    die "Unable to get swasstdb bank account!\n"
      unless defined $swasstdbBankAccount;
    dlog( "got swasstdb bank account: " . $swasstdbBankAccount->toString() );

    ###Get swdiscrp bank account
    dlog("getting swdiscrp bank account");
    my $swdiscrpBankAccount = Sigbank::Delegate::BankAccountDelegate->getBankAccountByName('SWDISCRP');
    die "Unable to get swdiscrp bank account!\n"
      unless defined $swdiscrpBankAccount;
    dlog( "got swdiscrp bank account: " . $swdiscrpBankAccount->toString() );

    ###Get tlcmz bank account
    dlog("getting tlcmz bank account");
    my $tlcmzBankAccount = Sigbank::Delegate::BankAccountDelegate->getBankAccountByName('TLCMZ');
    die "Unable to get tlcmz bank account!\n" unless defined $tlcmzBankAccount;
    dlog( "got tlcmz bank account: " . $tlcmzBankAccount->toString() );

    ####Get a connection to swasset
    dlog("getting swasset db connection");
    my $swassetConnection = Database::Connection->new($swasstdbBankAccount);
    die "Unable to get swasset db connection!\n"
      unless defined $swassetConnection;
    dlog("got swasset db connection");

    ###Get a connection to staging
    dlog("getting staging db connection");
    my $stagingConnection = Database::Connection->new('staging');
    die "Unable to get staging db connection!\n"
      unless defined $stagingConnection;
    dlog("got staging db connection");

    ###Get a connection to bravo
    dlog("getting bravo db connection");
    my $bravoConnection = Database::Connection->new('trails');
    die "Unable to get bravo db connection!\n" unless defined $bravoConnection;
    dlog("got bravo db connection");

    ###Get start time for processing
    my $begin = time();

    ###Wrap all of this in an eval so we can close the
    ###db connections if something dies.  Use dieMsg to
    ###determine if this method should throw the die.
    my $dieMsg = undef;
    eval {
        ###Get account number map
        dlog("getting account number map");
        my $accountNumberMap = CNDB::Delegate::CNDBDelegate->getAllAccountNumberMap();
        die "Unable to get account number map!\n"
          unless defined $accountNumberMap;
        dlog("got account number map");

        ###Start public log.
        my @localtime = localtime();
        my $fstamp = sprintf "%04d-%02d-%02d", $localtime[5] + 1900, $localtime[4] + 1, $localtime[3];
        dlog("fstamp=$fstamp");
        my $logFile = $self->logsDir . "/" . $fstamp . ".cleanup.log";
        dlog("logFile=$logFile");
        open LOG, ">>$logFile";
        dlog("opened append handle to $logFile");

        ###Get the pending input files.
        ilog("getting input files");
        my @inputFiles = $self->getInputFiles();
        ilog( "got input files, count: " . scalar @inputFiles );

        ###Process input files
        for ( my $i = 0 ; $i <= $#inputFiles ; $i++ ) {
            my $inputFile = $inputFiles[$i];
            ilog("processing inputFile: $inputFile");

            ###Open file handle to input file.
            unless ( open INFILE, "$inputFile" ) {
                print LOG "# Can not open: $inputFile: $!";
                next;
            }

            ###Process input file line by line.
            my $lineNumber = 0;
            while (<INFILE>) {
                $lineNumber++;
                chomp;
                s/\r//g;
                my $line = $_;

                my ( $host, $from, $to, $action ) = split(/\t/);
                $action = uc($action);
                dlog( "[$lineNumber] host=$host, from=$from, to=$to, action=$action" );

                ###Validate line.
                my @errors = ();
                if ( !( $action =~ /\s*REMOVE\s*/ ) ) {
                    if ( !( $action =~ /\s*MOVE\s*/ ) ) {
                        if ( !( $action =~ /\s*REMOVE_SAFE\s*/ ) ) {
                            push @errors, "Invalid action, must be MOVE/REMOVE";
                        }
                    }
                    elsif ( !( $to =~ /\d/ ) ) {
                        push @errors, "To column is required as account number if action is MOVE";
                    }
                }
                unless ( $from =~ /\d/ ) {
                    push @errors, "From column is required as the account number";
                }
                unless ($host) {
                    push @errors, "tme_object_label column is required";
                }
                if ( scalar @errors ) {
                    my $s;
                    $s = "# errors found on line $i";
                    print LOG ("$s\n");
                    dlog($s);
                    $s = "# \t" . join "\n", @errors;
                    print LOG ("$s\n\n");
                    dlog($s);
                    next;
                }

                ###Process line.
                my @cmds = ();
                if ( $action eq 'MOVE' ) {

                    push @cmds, $self->managerScript . " -f $from -t $to -s $host -m";
                }
                elsif ( $action eq 'REMOVE' ) {

                    ###
                    ###Purge all possible data for this sw lpar.
                    ###

                    ###Lookup sw lpar in bravo
                    my $bravoSoftwareLpar = new BRAVO::OM::SoftwareLpar();
                    $bravoSoftwareLpar->customerId( $accountNumberMap->{$from} );
                    $bravoSoftwareLpar->name($host);
                    $bravoSoftwareLpar->getByBizKey($bravoConnection);
                    dlog( "bravoSoftwareLpar=" . $bravoSoftwareLpar->toString() );

                    ###Lookup bank account ids in bravo
                    my @bankAccountIds = ();
                    if ( defined $bravoSoftwareLpar->id ) {
                        @bankAccountIds =
                          BRAVO::Delegate::BRAVODelegate->getBankAccountsBySoftwareLpar( $bravoConnection,
                                                                                         $bravoSoftwareLpar );
                        dlog( "bankAccountIds count=" . scalar(@bankAccountIds) );
                        foreach my $bankAccountId (@bankAccountIds) {
                            dlog("bankAccountId=$bankAccountId");
                        }
                    }

                    ###Lookup sw lpar in staging
                    my $stagingSoftwareLpar = new Staging::OM::SoftwareLpar();
                    $stagingSoftwareLpar->customerId( $accountNumberMap->{$from} );
                    $stagingSoftwareLpar->name($host);
                    $stagingSoftwareLpar->getByBizKey($stagingConnection);
                    dlog( "stagingSoftwareLpar=" . $stagingSoftwareLpar->toString() );

                    ###Lookup scan records in staging for sw lpar
                    my @stagingScanRecords = ();
                    if ( defined $stagingSoftwareLpar ) {
                        @stagingScanRecords = Staging::Delegate::StagingDelegate->getStagingScanRecordsBySoftwareLpar( $stagingConnection,
                                                                                                 $stagingSoftwareLpar );
                        dlog( "stagingScanRecords count=" . scalar(@stagingScanRecords) );
                        foreach my $stagingScanRecord (@stagingScanRecords) {
                            dlog( "stagingScanRecord=" . $stagingScanRecord->toString );
                        }
                    }

                    ###Purge variables
                    my %purgeSwassetRecords = ();
                    my $purgeBravoRecord    = 0;
                    my @purgeBankAccounts   = ();

                    ###Purge logic
                    if ( defined $bravoSoftwareLpar->id
                         && $bravoSoftwareLpar->status eq 'ACTIVE' )
                    {
                        dlog("active bravo sw lpar found");
                        if ( scalar @stagingScanRecords == 0 ) {
                            dlog("stagingScanRecords count = 0");
                            $purgeBravoRecord = 1;
                        }
                        else {
                            foreach my $bankAccountId (@bankAccountIds) {
                                dlog("checking bank acct id=$bankAccountId");
                                my $foundIt = 0;
                                foreach my $stagingScanRecord (@stagingScanRecords) {
                                    dlog( "checking staging scan record=" . $stagingScanRecord->toString() );
                                    if ( $bankAccountId == 0 ) {
                                        dlog("bank account is discrepancy");
                                        if ( $stagingScanRecord->bankAccountId == $swdiscrpBankAccount->id ) {
                                            dlog("scan record is swdiscrp");
                                            $foundIt = 1;
                                        }
                                    }
                                    else {
                                        dlog("bank account is not discrepancy");
                                        if ( $stagingScanRecord->bankAccountId == $bankAccountId ) {
                                            dlog( "bank account matches scan record" );
                                            $foundIt = 1;
                                        }
                                    }
                                }
                                if ( $foundIt == 0 || $bankAccountId == 0 ) {
                                    push @purgeBankAccounts, $bankAccountId;
                                }
                            }
                            foreach my $stagingScanRecord (@stagingScanRecords) {
                                if ( $stagingScanRecord->bankAccountId == $swasstdbBankAccount->id ) {
                                    $purgeSwassetRecords{ $stagingScanRecord->computerId }++;
                                }
                                elsif ( $stagingScanRecord->bankAccountId == $swdiscrpBankAccount->id ) {
                                    $purgeSwassetRecords{ $stagingScanRecord->computerId }++;
                                }
                                elsif ( $stagingScanRecord->bankAccountId == $tlcmzBankAccount->id ) {
                                    $purgeSwassetRecords{ $stagingScanRecord->computerId }++;
                                }
                            }
                        }
                    }
                    else {
                        ilog("no active bravo sw lpar found!");
                    }

                    ###Execute purges
                    my $takeAction = 0;
                    foreach my $swassetRecord ( sort keys %purgeSwassetRecords ) {
                        $takeAction = 1;
                        ilog("purge: swassetRecord=$swassetRecord");
                        my @a        = split( /\./, $swassetRecord );
                        my $acctId   = shift @a;
                        my $lparName = join( '.', @a );
                        dlog("acctId=$acctId, lparName=$lparName");
                        push @cmds, $self->managerScript . " -f $acctId -s $lparName -r";
                    }
                    if ( $purgeBravoRecord == 1 ) {
                        $takeAction = 1;
                        ilog("purge: purgeBravoRecord=$purgeBravoRecord");
                        if ( $self->applyChanges == 1 ) {
                            BRAVO::Delegate::BRAVODelegate->inactivateSoftwareLparById( $bravoConnection,
                                                                                        $bravoSoftwareLpar->id );
                            ilog( "inactivated sw lpar=" . $bravoSoftwareLpar->toString() );
                        }
                    }
                    else {
                        foreach my $bankAccountId (@purgeBankAccounts) {
                            $takeAction = 1;
                            ilog("purge: bankAccountId=$bankAccountId");
                            if ( $self->applyChanges == 1 ) {
                                BRAVO::Delegate::BRAVODelegate
                                  ->inactivateInstalledSoftwaresBySoftwareLparIdAndBankAccountId( $bravoConnection,
                                                                               $bravoSoftwareLpar->id, $bankAccountId );
                                ilog( "inactivated all bank acct: $bankAccountId for sw lpar="
                                      . $bravoSoftwareLpar->toString() );
                            }
                        }
                    }
                    if ( $takeAction == 0 ) {
                        ilog("no purge action can be performed.");
                    }
                }
                elsif ( $action eq 'REMOVE_SAFE' ) {

                    push @cmds, $self->managerScript . " -f $from -s $host -r -g";
                }

                ###Execute commands.
                foreach my $cmd (@cmds) {
                    dlog("cmd=$cmd");
                    if ( $self->applyChanges == 1 ) {
                        print LOG ("$cmd\n");
                        my $s = `$cmd 2>&1`;
                        print LOG $s;
                        dlog($s);
                    }
                    else {
                        dlog("applyChanges not set, not executing cmd");
                    }
                }
            }
            close(INFILE);

            ###Move file to complete directory.
            if ( $self->applyChanges == 1 ) {
                my $inputFileBasename = basename("$inputFile");
                dlog("inputFileBasename=$inputFileBasename");
                move( "$inputFile", $self->completeDir . "/$inputFileBasename" );
                dlog( "moved: $inputFile to: " . $self->completeDir . "/$inputFileBasename" );
            }
        }

        ###Close public log.
        close(LOG);
        dlog("closed handle to $logFile");
    };
    if ($@) {
        ###Something died in the eval, set dieMsg so
        ###we know to die after closing the db connections.
        elog($@);
        $dieMsg = $@;

        if ( $self->applyChanges == 1 ) {

            ###Notify the scheduler that we had an error
            ilog("erroring $job system schedule status");
            SystemScheduleStatusDelegate->error($systemScheduleStatus);
            ilog("errored $job system schedule status");
        }
    }
    else {
        if ( $self->applyChanges == 1 && !defined $dieMsg ) {

            ###Notify the scheduler that we are stopping
            ilog("stopping $job system schedule status");
            SystemScheduleStatusDelegate->stop($systemScheduleStatus);
            ilog("stopped $job system schedule status");
        }
    }

    ###Calculate duration of this processing
    my $totalProcessingTime = time() - $begin;
    ilog("totalProcessingTime: $totalProcessingTime secs");

    ###Close the swasset connection
    ilog("disconnecting swasset db connection");
    $swassetConnection->disconnect;    
    ilog("disconnected swasset db connection");

    ###Close the staging connection
    ilog("disconnecting staging db connection");
    $stagingConnection->disconnect;
    ilog("disconnected staging db connection");

    ###Close the bravo connection
    ilog("disconnecting bravo db connection");
    $bravoConnection->disconnect;
    ilog("disconnected bravo db connection");

    ###die if dieMsg is defined
    die $dieMsg if defined $dieMsg;
}

###Checks arguments passed to load method.
sub checkArgs {
    my ( $self, $args ) = @_;

    ###Check TestMode arg is passed correctly
    unless ( exists $args->{'TestMode'} ) {
        elog("Must specify TestMode sub argument!");
        die;
    }
    unless ( $args->{'TestMode'} == 0 || $args->{'TestMode'} == 1 ) {
        elog("Invalid value passed for TestMode param!");
        die;
    }
    $self->testMode( $args->{'TestMode'} );
    ilog( "testMode=" . $self->testMode );

    ###Check ApplyChanges arg is passed correctly
    unless ( exists $args->{'ApplyChanges'} ) {
        elog("Must specify ApplyChanges sub argument!");
        die;
    }
    unless ( $args->{'ApplyChanges'} == 0 || $args->{'ApplyChanges'} == 1 ) {
        elog("Invalid value passed for ApplyChanges param!");
        die;
    }
    $self->applyChanges( $args->{'ApplyChanges'} );
    ilog( "applyChanges=" . $self->applyChanges );

    ###Check LogsDir arg is passed correctly
    unless ( exists $args->{'LogsDir'} ) {
        elog("Must specify LogsDir sub argument!");
        die;
    }
    unless ( -d $args->{'LogsDir'} || -e $args->{'LogsDir'} ) {
        elog("Invalid value passed for LogsDir param!");
        die;
    }
    $self->logsDir( $args->{'LogsDir'} );
    ilog( "logsDir arg=" . $self->logsDir );

    ###Check CleanupDir arg is passed correctly
    unless ( exists $args->{'CleanupDir'} ) {
        elog("Must specify CleanupDir sub argument!");
        die;
    }
    unless ( -d $args->{'CleanupDir'} || -e $args->{'CleanupDir'} ) {
        elog("Invalid value passed for CleanupDir param!");
        die;
    }
    $self->cleanupDir( $args->{'CleanupDir'} );
    ilog( "cleanupDir arg=" . $self->cleanupDir );

    ###Check CompleteDir arg is passed correctly
    unless ( exists $args->{'CompleteDir'} ) {
        elog("Must specify CompleteDir sub argument!");
        die;
    }
    unless ( -d $args->{'CompleteDir'} || -e $args->{'CompleteDir'} ) {
        elog("Invalid value passed for CompleteDir param!");
        die;
    }
    $self->completeDir( $args->{'CompleteDir'} );
    ilog( "completeDir arg=" . $self->completeDir );

    ###Check ManagerScript arg is passed correctly
    unless ( exists $args->{'ManagerScript'} ) {
        elog("Must specify ManagerScript sub argument!");
        die;
    }
    unless ( -e $args->{'ManagerScript'} ) {
        elog("Invalid value passed for ManagerScript param!");
        die;
    }
    $self->managerScript( $args->{'ManagerScript'} );
    ilog( "managerScript arg=" . $self->managerScript );
}

sub getInputFiles {
    my ($self) = @_;

    ###List of files to return.
    my @inputFiles = ();

    ###Establish array of directories to search.
    my @inputFilesDirList = ();
    push @inputFilesDirList, $self->cleanupDir;
    foreach my $dir (@inputFilesDirList) {
        dlog("searching directory: $dir");
    }

    ###File::Find prints warning messages whenever you
    ###have it skip a file in the sub.  We do not want
    ###to see these.
    no warnings;

    ###Perform search of the file system for each of
    ###the directories in the list.
    find(
        sub {
            next unless -f;
            push( @inputFiles, $File::Find::name );
        },
        @inputFilesDirList
    );
    dlog( 'found ' . scalar @inputFiles . ' total files' );

    ###Sort the input files array so that the most
    ###recently modified files are the last in order.
    my @inputFilesSorted =
      sort { [ stat $a ]->[9] <=> [ stat $b ]->[9] } @inputFiles;

    return @inputFilesSorted;
}

1;
